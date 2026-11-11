"""Independent symbolic/integration/grid audits for the post-Marco course core.

Invoked by code/verify.py only. No Monte Carlo, equilibrium or advisor approval.
"""

import csv
import json
from dataclasses import replace
from pathlib import Path

import numpy as np
import sympy as sp

from post_marco_model import (BankType, BufferProblem, FrozenSchedule, ShockState,
                              allocate, moments)
from simulate_post_marco import baseline, experiment_data, generate_outputs


def grid(problem, n=16001):
    """Independent vectorized global grid; no FOC or model objective calls."""
    us = np.linspace(0, problem.bank.u_max, n)
    costs = problem.r*us
    for s in problem.schedules:
        mean = problem.bank.beta*s.state.A+us
        sigma = s.state.sigma
        L = np.where(mean >= sigma, 0, np.where(mean <= -sigma, -mean, (sigma-mean)**2/(4*sigma)))
        X = np.where(mean <= -sigma, 0, np.where(mean >= sigma, mean, (sigma+mean)**2/(4*sigma)))
        phi = min(1, problem.F/s.delta) if s.delta > 0 else 0
        costs = costs+s.state.probability*(problem.i*s.psi*L-problem.i*s.ell*X
                                         +problem.kappa*(1-phi)*(1-s.psi)*L)
    index = int(np.argmin(costs))
    return float(us[index]), float(costs[index])


def integrated_cost(problem, u, n=65536):
    result = problem.r*u
    for s in problem.schedules:
        eps = -s.state.sigma+(np.arange(n)+.5)*2*s.state.sigma/n
        flow = problem.bank.beta*s.state.A+eps+u
        L, X = np.maximum(-flow, 0), np.maximum(flow, 0)
        phi = min(1, problem.F/s.delta) if s.delta > 0 else 0
        result += s.state.probability*float(np.mean(
            problem.i*s.psi*L-problem.i*s.ell*X
            +problem.kappa*(1-phi)*(1-s.psi)*L))
    return result


def reconstruct(row):
    bank = BankType(row['name'], float(row['mu']), float(row['d']), float(row['beta']),
                    float(row['tau']), float(row['u_max']))
    schedules = tuple(FrozenSchedule(ShockState(**s['state']), s['psi'], s['ell'], s['delta'])
                      for s in json.loads(row['schedules']))
    return BufferProblem(bank, schedules, *[float(row[k]) for k in ('r', 'i', 'kappa', 'F')])


def run_checks():
    checks, diagnostics = [], {}

    def check(label, condition):
        if not bool(condition):
            raise AssertionError('POST-MARCO: '+label)
        checks.append(label)
        print('PASS [post_marco_course_core]: '+label)

    def rejects(operation):
        try:
            operation()
        except ValueError:
            return True
        return False

    # Derive signs independently from the signed-flow SHORTFALL AND SURPLUS.
    u, beta, A, sigma, d = sp.symbols('u beta A sigma d', positive=True)
    a, b, r, kappa, psi, delta, F = sp.symbols('a b r kappa psi delta F', real=True)
    L, X = (sigma-beta*A-u)**2/(4*sigma), (sigma+beta*A+u)**2/(4*sigma)
    minus, plus = (sigma-beta*A-u)/(2*sigma), (sigma+beta*A+u)/(2*sigma)
    check('D_u/d=-pi_minus and X_u/d=pi_plus on uniform interior',
          sp.simplify(sp.diff(L, u)+minus) == 0 and sp.simplify(sp.diff(X, u)-plus) == 0)
    check('amount derivatives carry d; normalized derivatives do not',
          sp.simplify(sp.diff(d*L, u)+d*minus) == 0 and sp.simplify(sp.diff(d*X, u)-d*plus) == 0)
    J = r*u+a*L-b*X
    check('FOC independently differentiated including lending income',
          sp.simplify(sp.diff(J, u)-(r-a*minus-b*plus)) == 0)
    check('curvature includes negative lending-income contribution',
          sp.simplify(sp.diff(J, u, 2)-(a-b)/(2*sigma)) == 0)
    a_F = a+kappa*(1-F/delta)*(1-psi)
    check('rationed mixed derivative J_uF is nonnegative under stated signs',
          sp.simplify(sp.diff(r-a_F*minus-b*plus, F)-kappa*(1-psi)*minus/delta) == 0)

    banks, states, parameters, buffers, reference, problems = baseline()
    max_moment_error, derivative_error = 0.0, 0.0
    for bank in banks:
        for state in states:
            eps = -state.sigma+(np.arange(65536)+.5)*2*state.sigma/65536
            for buffer in (0.0, .11, .37, .5, .8):
                m = moments(bank, state, buffer)
                flow = bank.beta*state.A+eps+buffer
                max_moment_error = max(max_moment_error, abs(m['L']-np.maximum(-flow, 0).mean()),
                                       abs(m['X_over_d']-np.maximum(flow, 0).mean()))
                check_id = m['X_over_d']-m['L']-(bank.beta*state.A+buffer)
                assert abs(check_id) < 1e-13
                h = 1e-6
                low, high = moments(bank, state, buffer-h), moments(bank, state, buffer+h)
                derivative_error = max(derivative_error,
                    abs((high['L']-low['L'])/(2*h)+m['pi_minus']),
                    abs((high['X_over_d']-low['X_over_d'])/(2*h)-m['pi_plus']))
    check('closed D/X versus independent conditional midpoint integration', max_moment_error < 1e-9)
    check('D/X first derivatives, including joins, versus finite differences', derivative_error < 2e-6)
    check('signed-flow identity X/d-D/d=beta*A+u', True)
    diagnostics.update(moment_integration_max_error=max_moment_error, moment_derivative_max_error=derivative_error)

    # Cover both short sides, equality, zero sides/access/residual/capacity.
    allocation_cases = [
        (banks, states, buffers, problems[0].F),
        (banks, states, (.8, .8), 0.0),
        (banks, (ShockState(-4, 1, .5),), buffers, .1),
        (banks, (ShockState(0, 1, .5),), (0.0, 0.0), .01),
        (tuple(replace(b, tau=0) for b in banks), states, buffers, .01),
        (tuple(replace(b, tau=1) for b in banks), (ShockState(0, 1, .5),), buffers, .01),
        (banks, states, buffers, 0.0), (banks, states, buffers, 10.0)]
    regimes, zero_delta = set(), False
    for bs, ss, us, capacity in allocation_cases:
        rows = allocate(bs, ss, us, capacity)
        for state in ss:
            group = [row for row in rows if row['A'] == state.A]
            P, Q, Delta = (group[0][key] for key in ('P', 'Q', 'Delta'))
            regimes.add('zero' if min(P, Q) == 0 else 'equal' if abs(P-Q) < 1e-12 else
                        'supply_short' if P < Q else 'demand_short')
            assert abs(sum(row['mu']*row['borrowed'] for row in group)-min(P, Q)) < 1e-12
            assert abs(sum(row['mu']*row['lent'] for row in group)-min(P, Q)) < 1e-12
            assert abs(sum(row['mu']*row['coverage'] for row in group)-min(capacity, Delta)) < 1e-12
            assert abs(sum(row['mu']*row['residual'] for row in group)-Delta) < 1e-12
            for row in group:
                assert 0 <= row['coverage'] <= row['residual']+1e-12
                assert abs(row['coverage']+row['uncovered']-row['residual']) < 1e-12
                if Delta == 0:
                    zero_delta = True
                    assert row['phi'] == 0
    check('interbank conservation with masses and UNEQUAL deposits in all short-side regimes',
          regimes == {'zero', 'equal', 'supply_short', 'demand_short'})
    check('fund feasibility: weighted coverage=min(F,Delta); residual accounting', True)
    check('zero residual means phi=0; zero supply/demand means zero trade', zero_delta)
    total_D = sum(b.mu*b.d for b in banks)
    check('NU common capacity F=nu_F*rho*D+R with no individual reuse',
          abs(problems[0].F-(parameters['nu_F']*parameters['rho']*total_D+parameters['R'])) < 1e-14)

    integration_error, foc_error, curvature_error = [], [], []
    for problem in problems:
        for buffer in (.07, .23, .41, .63, .77):
            integration_error.append(abs(problem.objective(buffer)-integrated_cost(problem, buffer)))
            h = 1e-5
            foc_error.append(abs((problem.objective(buffer+h)-problem.objective(buffer-h))/(2*h)
                                 -problem.derivative(buffer)))
            curvature_error.append(abs((problem.derivative(buffer+h)-problem.derivative(buffer-h))/(2*h)
                                      -problem.curvature(buffer)))
    check('J versus independent shock-by-shock cost integration', max(integration_error) < 1e-9)
    check('FOC versus independent objective finite differences', max(foc_error) < 1e-8)
    check('actual curvature versus derivative finite differences off knots', max(curvature_error) < 1e-8)
    check('baseline convexity checked on EVERY support interval', all(p.convexity_certificate() for p in problems))
    nonconvex = problems[0].at_capacity(10.0)
    check('full public coverage supplies counterexample to automatic convexity',
          not nonconvex.convexity_certificate() and nonconvex.curvature(.65) < 0)
    cases = [*problems, nonconvex, replace(problems[0], r=1), replace(problems[0], r=0),
             replace(problems[0].at_capacity(10), r=0, i=0)]
    regimes_found = {p.optimum()['regime'] for p in cases}
    grid_errors = []
    for problem in cases:
        opt = problem.optimum()
        _, cost = grid(problem, 40001)
        grid_errors.append(abs(cost-opt['J']))
    check('global interval optimizer versus independent 40001-point grid, including nonconvex case',
          max(grid_errors) < 1e-7)
    check('lower/upper/interior/nonunique solutions explicitly exercised',
          {'lower_corner', 'upper_corner', 'interior', 'nonunique'} <= regimes_found)
    flat = cases[-1].optimum()
    check('flat minimizing interval reported, not silently called unique',
          not flat['unique'] and min(flat['minimizer_points']) == 0
          and max(flat['minimizer_points']) == flat['minimizing_flat_intervals'][-1][1])

    response_errors, responses = [], []
    for base in problems:
        for capacity in (.008, .015, .025, .035):
            problem = base.at_capacity(capacity)
            exact = problem.capacity_response()
            h = 1e-6
            plus_p, minus_p = problem.at_capacity(capacity+h), problem.at_capacity(capacity-h)
            assert plus_p.optimum()['regime'] == minus_p.optimum()['regime'] == 'interior'
            response_errors.append(abs(exact-(plus_p.optimum()['u']-minus_p.optimum()['u'])/(2*h)))
            responses.append(exact)
    check('conditional du*/dF versus finite differences within same regular regime', max(response_errors) < 1e-6)
    check('strictly negative capacity response requires positive rationed deficit exposure', max(responses) < 0)
    saturated = BufferProblem(banks[0], (FrozenSchedule(ShockState(0, 1, .5), .8, .1, 1),),
                              .006, .02, .25, 2)
    check('zero response when no relevant state is rationed', abs(saturated.capacity_response()) < 1e-13)
    check('reject capacity derivative at corners and nonunique choices',
          all(rejects(p.capacity_response) for p in cases[-3:]))
    at_kink = problems[0].at_capacity(problems[0].schedules[0].delta)
    check('reject two-sided derivative at coverage kink', rejects(at_kink.capacity_response))
    check('reject two-sided derivative at zero-capacity boundary',
          rejects(problems[0].at_capacity(0).capacity_response))
    check('invalid laws/domains/coverage rejected',
          rejects(lambda: ShockState(0, 1, 0)) and rejects(lambda: replace(problems[0], F=-1))
          and rejects(lambda: FrozenSchedule(states[0], 1.1, .3, 1))
          and rejects(lambda: replace(problems[0], schedules=(problems[0].schedules[0],))))

    paths = generate_outputs()
    output = Path(__file__).resolve().parent/'output/post_marco'
    validated_rows, max_grid_gap = 0, 0.0
    for filename in ('baseline_optima', 'capacity_sweep', 'exposure_sweep'):
        with (output/(filename+'.csv')).open(newline='', encoding='utf-8') as stream:
            for row in csv.DictReader(stream):
                problem, buffer = reconstruct(row), float(row['u'])
                assert 0 <= buffer <= problem.bank.u_max
                assert abs(float(row['J'])-integrated_cost(problem, buffer, 8192)) < 2e-8
                assert abs(float(row['J'])-(float(row['opportunity_cost'])+float(row['borrowing_cost'])
                           -float(row['lending_income'])+problem.kappa*float(row['uncovered_over_d']))) < 1e-12
                assert float(row['kkt_residual']) < 1e-10
                _, cost = grid(problem)
                max_grid_gap = max(max_grid_gap, abs(cost-float(row['J'])))
                if filename == 'capacity_sweep':
                    assert float(row['backing_R']) >= 0
                    assert all(problem.F < s.delta for s in problem.schedules)
                validated_rows += 1
    check('every exported optimum row: integration, private-cost ledger, feasibility and global grid',
          max_grid_gap < 1e-7)
    with (output/'cost_curves.csv').open(newline='', encoding='utf-8') as stream:
        for row in csv.DictReader(stream):
            problem = problems[int(row['bank_type'])-1]
            assert abs(float(row['J'])-problem.objective(float(row['u']))) < 1e-12
            validated_rows += 1
    check('every exported cost-curve point reproduced', True)
    with (output/'reference_market_accounting.csv').open(newline='', encoding='utf-8') as stream:
        market_rows = list(csv.DictReader(stream))
    groups = {}
    for row in market_rows:
        groups.setdefault((row['F'], row['A']), []).append({k:float(v) if k != 'bank_type' else v for k,v in row.items()})
        validated_rows += 1
    for rows in groups.values():
        first = rows[0]
        assert abs(sum(r['mu']*r['borrowed'] for r in rows)-min(first['P'], first['Q'])) < 1e-12
        assert abs(sum(r['mu']*r['lent'] for r in rows)-min(first['P'], first['Q'])) < 1e-12
        assert abs(sum(r['mu']*r['coverage'] for r in rows)-min(first['F'], first['Delta'])) < 1e-12
    check('every exported population state conserves interbank and fund amounts', True)
    with (output/'fixed_buffer_incidence.csv').open(newline='', encoding='utf-8') as stream:
        incidence_rows = list(csv.DictReader(stream))
    incidence_groups = {}
    for row in incidence_rows:
        assert abs(float(row['I'])-(float(row['C_k'])/float(row['d']))/(float(row['Cbar'])/float(row['aggregate_deposits']))) < 1e-12
        incidence_groups.setdefault(row['F'], []).append(row)
        validated_rows += 1
    for rows in incidence_groups.values():
        assert abs(sum(float(r['mu'])*float(r['d'])/float(r['aggregate_deposits'])*float(r['I']) for r in rows)-1) < 1e-12
    check('fixed-buffer incidence identity and deposit-weighted mean one for every row', True)
    for name in ('1', '2'):
        values = [float(r['I']) for r in incidence_rows if r['bank_type'] == name]
        assert max(values)-min(values) < 1e-12
    check('fixed-buffer I is invariant here under proportional fully rationed capacity scaling', True)
    config = json.loads((output/'parameters.json').read_text())
    check('parameters explicitly constructed; cap/shock laws are course additions; no equilibrium claim',
          config['status'] == 'constructed_course_specialization' and len(config['assumptions_added_for_course']) == 3)
    diagnostics.update(objective_integration_max_error=max(integration_error),
                       objective_finite_difference_max_error=max(foc_error),
                       curvature_finite_difference_max_error=max(curvature_error),
                       optimizer_grid_max_cost_gap=max(grid_errors),
                       exported_grid_max_cost_gap=max_grid_gap,
                       capacity_response_max_error=max(response_errors),
                       capacity_response_range=[min(responses), max(responses)],
                       validated_exported_csv_rows=validated_rows)
    report = output/'verification.json'
    report.write_text(json.dumps(dict(status='PASS', count=len(checks), checks=checks,
                                      diagnostics=diagnostics,
                                      scope='Post-Marco conditional atomistic course specialization; not GE, calibration or advisor approval'),
                                 indent=2, allow_nan=False)+'\n', encoding='utf-8')
    return checks, [*paths, report], diagnostics
