"""Single entry point: python code/verify.py.

Sections 1 and 2 preserve the historical October and November-4 course cores.
Section 3 verifies the separate post-Marco prescribed-allocation course core.
Each model has separate outputs. No participation equilibrium/search/Nash.
"""

import json
from dataclasses import replace
from pathlib import Path

import numpy as np
import sympy as sp

from buffer_model import AggregateState, BufferModel, reserve_requirement
from simulate_buffers import baseline, generate_outputs


CHECKS = []
SECTION = 'historical_october'


def checked(label):
    CHECKS.append(dict(section=SECTION, check=label, status='PASS'))
    print(f"PASS [{SECTION}]: {label}")


def equal(label, actual, expected):
    residual = sp.simplify(actual - expected)
    if residual != 0:
        raise AssertionError(f"{label}: nonzero residual {residual}")
    checked(label)


def require(label, condition):
    if condition is not True:
        raise AssertionError(f"{label}: sign not established ({condition})")
    checked(label)


def historical_october_checks():
    a = sp.Symbol("a", positive=True)
    e, z, u, beta, A, chi, rho = sp.symbols(
        "e z u beta A chi rho", real=True
    )
    z_u = beta * A + u + chi * rho

    # Valid only when -a < z < a. The negative part is then integrated
    # from the lower support endpoint to the zero-liquidity threshold.
    integral = sp.integrate((-z - e) / (2 * a), (e, -a, -z))
    L = (a - z) ** 2 / (4 * a)
    pi = (a - z) / (2 * a)
    equal("interior uniform expected-deficit integral", integral, L)
    L_u = L.subs(z, z_u)
    pi_u = pi.subs(z, z_u)
    equal("interior dL/du = -pi", sp.diff(L_u, u), -pi_u)
    equal("interior d2L/du2 = 1/(2a)", sp.diff(L_u, u, 2), 1 / (2 * a))
    equal("interior dpi/du = -1/(2a)", sp.diff(pi_u, u), -1 / (2 * a))

    # Outside the interior, L=-z (certain deficit) or L=0 (no deficit).
    equal("certain-deficit derivative", sp.diff(-z_u, u), -1)
    equal("no-deficit derivative", sp.diff(sp.Integer(0), u), 0)
    equal("lower-support value joins", L.subs(z, -a), a)
    equal("upper-support value joins", L.subs(z, a), 0)
    equal("lower-support slope joins", sp.diff(L, z).subs(z, -a), -1)
    equal("upper-support slope joins", sp.diff(L, z).subs(z, a), 0)

    kappa, h = sp.symbols("kappa h", positive=True)
    V = kappa * u + h * L_u
    equal("single-state marginal cost", sp.diff(V, u), kappa - h * pi_u)
    curvature = sp.diff(V, u, 2)
    equal("single-state convexity expression", curvature, h / (2 * a))
    require("positive curvature when h>0 and threshold is inside support",
            curvature.is_positive)

    # Two-state curvature, conditional on both thresholds inside support.
    a0, a1, h0, h1 = sp.symbols("a0 a1 h0 h1", positive=True)
    z0, z1, p = sp.symbols("z0 z1 p", real=True)
    two_state_V = kappa * u + (1-p)*h0*(a0-z0-u)**2/(4*a0) \
        + p*h1*(a1-z1-u)**2/(4*a1)
    equal("two-state weighted curvature", sp.diff(two_state_V, u, 2),
          (1-p)*h0/(2*a0) + p*h1/(2*a1))

    psi, phi = sp.symbols("psi phi", real=True)
    qI, qF, ell = sp.symbols("q_I q_F ell", nonnegative=True)
    composite = psi*qI + (1-psi)*(phi*qF + (1-phi)*ell)
    equal("exclusive funding weights sum to one",
          psi + (1-psi)*phi + (1-psi)*(1-phi), 1)
    equal("deficit-composite rewrite", composite,
          psi*qI + (1-psi)*(ell-phi*(ell-qF)))

    RD, corpus = sp.symbols("R_D corpus", nonnegative=True)
    Delta = sp.Symbol("Delta", positive=True)
    rationed_phi = (corpus + RD) / Delta
    rationed_h = composite.subs(phi, rationed_phi)
    h_RD = sp.diff(rationed_h, RD)
    equal("rationed coverage derivative", sp.diff(rationed_phi, RD), 1/Delta)
    equal("rationed private-cost derivative", h_RD,
          -(1-psi)*(ell-qF)/Delta)
    equal("fully covered private-cost derivative",
          sp.diff(composite.subs(phi, 1), RD), 0)
    equal("capacity derivative in NU", sp.diff(corpus+RD, RD), 1)
    equal("capacity derivative in U", sp.diff(RD, RD), 1)

    # Differentiating M(u,R_D)=kappa gives M_u du/dR_D + M_R_D=0.
    # Here M_u=-D and M_R_D=pi*h_RD in a single rationed state.
    D, pi_prob = sp.symbols("D pi_prob", positive=True)
    du_RD = pi_prob*h_RD / D
    equal("implicit-function differentiated FOC", (-D)*du_RD + pi_prob*h_RD,
          0)
    equal("conditional buffer derivative", du_RD,
          -pi_prob*(1-psi)*(ell-qF)/(Delta*D))

    # Strict conditions: positive gap, residual fraction, deficit probability,
    # Delta, and curvature. These parameterizations encode ell>qF, psi<1.
    gap, residual = sp.symbols("gap residual", positive=True)
    strict_derivative = sp.simplify(
        du_RD.subs({ell: qF+gap, psi: 1-residual})
    )
    require("strictly negative conditional backing derivative",
            strict_derivative.is_negative)
    equal("zero derivative if public and uncovered costs coincide",
          du_RD.subs(ell, qF), 0)
    equal("zero derivative if all deficits are interbank-funded",
          du_RD.subs(psi, 1), 0)

    # In the multistate result each state contributes a nonnegative term.
    t0, t1 = sp.symbols("t0 t1", nonnegative=True)
    aggregate_derivative = -gap*(t0+t1)/D
    require("weakly negative multistate derivative",
            aggregate_derivative.is_nonpositive)
    t_strict = sp.Symbol("t_strict", positive=True)
    require("strict sign with at least one positive state contribution",
            aggregate_derivative.subs(t0, t_strict).is_negative)

    print("All symbolic checks passed.")
    print("Scope: interior-support algebra and conditional best-response effects.")
    print("Not verified: equilibrium feedbacks, calibration, or contract accounting.")


def numeric_check(label, condition):
    if not condition:
        raise AssertionError(label)
    checked(label)


def close(actual, expected, atol=1e-9, rtol=1e-7):
    return bool(np.isclose(actual, expected, atol=atol, rtol=rtol))


def must_reject(label, operation):
    try:
        operation()
    except ValueError:
        checked(label)
    else:
        raise AssertionError(f"{label}: invalid operation was accepted")


def midpoint_expectation(model, function, n=32768):
    """Independent unsplit midpoint quadrature over eps, not production formulas."""
    unit_midpoints = (np.arange(n)+0.5)/n
    result = 0.0
    for state in model.states:
        eps_k = (2*unit_midpoints-1)*state.eps_half_width
        e = model.beta*state.A+eps_k
        result += state.probability*float(np.mean(function(e)))
    return result


def independent_grid(model, n=12001):
    """Objective-only exhaustive grid; never calls derivative/optimum/curvature."""
    us = np.linspace(0, model.U, n)
    values = np.array([model.objective(float(u)) for u in us])
    index = int(np.argmin(values))
    return float(us[index]), float(values[index]), model.U/(n-1)


def v51_core_checks():
    global SECTION
    SECTION = 'v51_course_core'
    base = baseline()
    diagnostics = {}

    # A: symbolic reserve identities, both branches and the join.
    d, B, tauB, rho_m = sp.symbols('d B tauB rho_m', positive=True)
    above = tauB*B+rho_m*(d-B)
    equal('A: above-Base average reserve identity', above/d,
          rho_m-B/d*(rho_m-tauB))
    equal('A: below-Base average reserve identity', tauB*d/d, tauB)
    equal('A: reserve amount joins at Base', above.subs(d, B), tauB*B)
    equal('A: above-Base marginal reserve rate', sp.diff(above, d), rho_m)
    numeric_check('A: numeric reserve branches, B=0, B=d, and B>d', all(
        close(reserve_requirement(deposit, historical_base, .1, .35), expected)
        for deposit, historical_base, expected in
        [(1, 0, .35), (1, 1, .1), (1, 2, .1), (2, 1, .45)]))

    # B and the balance-sheet link to eligibility.
    u, r, equity, chi = sp.symbols('u r epsilon_E chi', real=True)
    U = 1+equity-r
    equal('B: normalized balance-sheet identity', (U-u)+r+u, 1+equity)
    equal('B: eligibility falls with the buffer', sp.diff(chi*(U-u), u), -chi)
    feasibility_points = 0
    for model in (base, replace(base, chi=0, phi=0), replace(base, phi=1, chi=.8)):
        for u_value in np.linspace(0, model.U, 9):
            for state in model.states:
                for eps_k in np.linspace(-state.eps_half_width, state.eps_half_width, 11):
                    outcome = model.state_outcome(float(u_value), state.A, float(eps_k))
                    assert close(outcome['b_over_d']+model.r+u_value, 1+model.epsilon_E)
                    assert outcome['q'] >= 0 and outcome['H'] >= 0
                    assert close(outcome['W']+outcome['v'], outcome['q'])
                    assert 0 <= outcome['W'] <= min(outcome['q'], outcome['H'])
                    assert outcome['v'] >= 0
                    # Grid the feasible public decision: maximum assistance is
                    # optimal because g>p, not merely because it is feasible.
                    candidates = np.linspace(0, min(outcome['q'], outcome['H']), 7)
                    costs = model.p*candidates+model.g*(outcome['q']-candidates)
                    assert model.p*outcome['W']+model.g*outcome['v'] <= min(costs)+1e-12
                    feasibility_points += 1
    numeric_check('B/C: balance, q/H/W/v feasibility and optimal public recourse', True)
    diagnostics['state_feasibility_points'] = feasibility_points

    # D: all three support regions and joins, plus multi-state mixtures.
    integration_errors = []
    for model in (base, replace(base, beta=1.4),
                  replace(base, states=(AggregateState(-.2, .25, .12),
                                        AggregateState(.25, .75, .33)))):
        tests = list(np.linspace(-.7, 1.2, 19))
        for state in model.states:
            tests.extend([model.beta*state.A-state.eps_half_width,
                          model.beta*state.A+state.eps_half_width])
        for threshold in tests:
            numerical = midpoint_expectation(model, lambda e: np.maximum(e-threshold, 0))
            integration_errors.append(abs(numerical-model.expected_positive_part(threshold)))
    numeric_check('D: closed expected positive parts vs independent midpoint integration',
                  max(integration_errors) < 2e-9)
    diagnostics['positive_part_max_absolute_error'] = max(integration_errors)
    diagnostics['positive_part_test_points'] = len(integration_errors)

    recourse_errors = []
    for u_value in np.linspace(0, base.U, 17):
        H = base.chi*(base.U-u_value)
        q = lambda e: np.maximum(e-u_value-base.phi*base.r, 0)
        W = midpoint_expectation(base, lambda e: np.minimum(q(e), H))
        v = midpoint_expectation(base, lambda e: np.maximum(q(e)-H, 0))
        total = base.c*(base.r+u_value)+base.p*W+base.g*v
        metrics = base.metrics(float(u_value))
        recourse_errors.extend([abs(W-metrics['expected_W']), abs(v-metrics['expected_v']),
                                abs(total-metrics['private_cost'])])
    numeric_check('D: independent q/W/v integration reproduces assistance, deferral and J',
                  max(recourse_errors) < 2e-9)
    diagnostics['recourse_max_absolute_error'] = max(recourse_errors)

    # E/F/H symbolic interior algebra. These do not prove support conditions;
    # the numerical checks below enforce regions and account for all pieces.
    sigma = sp.Symbol('sigma', positive=True)
    c, p, g, phi, mean = sp.symbols('c p g phi mean', real=True)
    t1 = u+phi*r
    t2 = phi*r+chi*U+(1-chi)*u
    L1 = (sigma-(t1-mean))**2/(4*sigma)
    L2 = (sigma-(t2-mean))**2/(4*sigma)
    J = c*(r+u)+p*L1+(g-p)*L2
    equal('E: single-active-state derivative', sp.diff(J, u),
          c-p*(sigma-t1+mean)/(2*sigma)
          -(g-p)*(1-chi)*(sigma-t2+mean)/(2*sigma))
    equal('F: single-active-state curvature', sp.diff(J, u, 2),
          (p+(g-p)*(1-chi)**2)/(2*sigma))
    equal('H: mixed derivative with reserve burden', sp.diff(J, u, r),
          (p*phi+(g-p)*(1-chi)*(phi-chi))/(2*sigma))
    positive_gap, nonnegative_p, factor = sp.symbols('gap p_positive factor', positive=True)
    require('F: curvature positive when density weights are positive',
            ((nonnegative_p+positive_gap*factor**2)/(2*sigma)).is_positive)

    derivative_errors, curvature_errors, convexity_violations = [], [], []
    differentiable_points = 0
    for model in (base, replace(base, phi=0), replace(base, phi=1, chi=.7),
                  replace(base, p=0), replace(base, chi=0)):
        for u_value in np.linspace(.001, model.U-.001, 51):
            step = 1e-6
            finite = (model.objective(u_value+step)-model.objective(u_value-step))/(2*step)
            derivative_errors.append(abs(finite-model.derivative(u_value)))
            if min(abs(u_value-knot) for knot in model.breakpoints()) > 1e-4:
                finite_curvature = (model.derivative(u_value+step)-model.derivative(u_value-step))/(2*step)
                curvature = model.curvature(u_value)
                assert curvature >= 0
                curvature_errors.append(abs(finite_curvature-curvature))
                differentiable_points += 1
        for left, right in zip(np.linspace(0, model.U, 33), np.linspace(model.U, 0, 33)):
            convexity_violations.append(model.objective((left+right)/2)
                                       -(model.objective(left)+model.objective(right))/2)
    numeric_check('E: full-mixture J derivative vs central differences', max(derivative_errors) < 2e-8)
    numeric_check('F: nonnegative curvature vs derivative finite differences away from knots',
                  max(curvature_errors) < 2e-8)
    numeric_check('F: global Jensen checks across support boundaries', max(convexity_violations) < 1e-12)
    for knot in base.breakpoints()[1:-1]:
        assert close(base.derivative(knot-1e-8), base.derivative(knot+1e-8), atol=1e-7)
    numeric_check('E/F: first derivative joins at internal support boundaries', True)
    diagnostics.update(derivative_max_absolute_error=max(derivative_errors),
                       curvature_max_absolute_error=max(curvature_errors),
                       smooth_curvature_points=differentiable_points)

    # G: independent global grid, including upper/lower corners and flat minima.
    scenarios = [replace(base, beta=beta, c=carrying)
                 for beta in (.4, 1.0, 1.7) for carrying in (.005, .035, .4)]
    upper = replace(base, states=(AggregateState(3, 1, .1),), c=.001)
    flat = replace(base, states=(AggregateState(3, 1, .1),), chi=0, c=base.g)
    scenarios.extend([upper, flat, replace(base, p=0), replace(base, phi=0)])
    grid_cost_errors, grid_position_errors, regimes = [], [], set()
    for model in scenarios:
        optimum = model.optimum()
        grid_u, grid_cost, mesh = independent_grid(model)
        assert model.objective(optimum['u']) <= grid_cost+1e-11
        assert optimum['kkt_residual'] < 1e-10
        if optimum['unique']:
            assert abs(grid_u-optimum['u']) <= mesh+1e-9
            grid_position_errors.append(abs(grid_u-optimum['u']))
        else:
            assert optimum['minimizer_lower']-mesh <= grid_u <= optimum['minimizer_upper']+mesh
        grid_cost_errors.append(abs(grid_cost-model.objective(optimum['u'])))
        regimes.add(optimum['regime'])
    numeric_check('G: piecewise analytical minimizers vs independent 12001-point global grids', True)
    numeric_check('G: lower corner, upper corner, interior and nonunique cases covered',
                  regimes == {'lower_corner', 'upper_corner', 'interior', 'nonunique'})
    diagnostics.update(optimizer_scenarios=len(scenarios), optimizer_regimes=sorted(regimes),
                       optimizer_max_cost_gap=max(grid_cost_errors),
                       optimizer_max_buffer_gap=max(grid_position_errors))

    # H: recompute optima at r+/-h. Reject corners, zero curvature and support
    # changes rather than manufacturing a derivative at a nonregular point.
    response_errors, responses = [], []
    for phi_value in (0.0, .2, .6):
        for chi_value in (.1, .2, .4):
            for r_value in (.12, .20, .30):
                model = replace(base, phi=phi_value, chi=chi_value).at_reserve_burden(r_value)
                optimum = model.optimum()
                if optimum['regime'] != 'interior':
                    continue
                step = 1e-5
                left, right = model.at_reserve_burden(r_value-step), model.at_reserve_burden(r_value+step)
                left_opt, right_opt = left.optimum(), right.optimum()
                assert left_opt['regime'] == right_opt['regime'] == 'interior'
                assert left.support_signature(left_opt['u']) == model.support_signature(optimum['u'])
                assert right.support_signature(right_opt['u']) == model.support_signature(optimum['u'])
                analytic = model.reserve_response()
                finite = (right_opt['u']-left_opt['u'])/(2*step)
                response_errors.append(abs(analytic-finite))
                responses.append(analytic)
                if phi_value >= chi_value:
                    assert analytic <= 1e-12
    numeric_check('H: reserve response vs finite differences in unchanged regular interior regimes',
                  len(response_errors) >= 6 and max(response_errors) < 2e-7)
    numeric_check('H: positive and negative reserve responses both exhibited',
                  min(responses) < -1e-6 and max(responses) > 1e-6)
    must_reject('H: refuse reserve derivative at upper corner', upper.reserve_response)
    must_reject('H: refuse reserve derivative at lower corner', replace(base, c=1).reserve_response)
    must_reject('H: refuse reserve derivative at nonunique optimum', flat.reserve_response)
    knot = next(x for x in base.breakpoints()[1:-1] if base.derivative(x) < base.c)
    kink_model = replace(base, c=base.c-base.derivative(knot))
    must_reject('H: refuse reserve derivative at optimum on support boundary', kink_model.reserve_response)
    diagnostics.update(reserve_response_points=len(response_errors),
                       reserve_response_max_absolute_error=max(response_errors),
                       reserve_response_range=[min(responses), max(responses)])

    for label, operation in [
        ('invalid state probability sum', lambda: replace(base, states=(AggregateState(0, .5, .2),))),
        ('zero uniform width', lambda: AggregateState(0, 1, 0)),
        ('negative state probability', lambda: AggregateState(0, -.1, .2)),
        ('invalid public cost ordering', lambda: replace(base, g=base.p)),
        ('invalid chi', lambda: replace(base, chi=1)),
        ('invalid usability', lambda: replace(base, phi=1.1)),
        ('infeasible U', lambda: replace(base, B=base.d, tauB=1, epsilon_E=0)),
        ('infeasible buffer', lambda: base.objective(base.U+.01)),
        ('zero deposits', lambda: reserve_requirement(0, 1, .1, .35)),
    ]:
        must_reject('Input guard: '+label, operation)
    return diagnostics


def main():
    global SECTION
    CHECKS.clear()
    SECTION = 'historical_october'
    print('=== HISTORICAL OCTOBER MODEL: phi=public coverage; R_D result is historical only ===')
    historical_october_checks()
    print('\n=== HISTORICAL NOVEMBER-4 V5.1-COURSE CORE: phi=reserve usability; direct support; advisor review pending ===')
    diagnostics = v51_core_checks()
    paths = generate_outputs()
    # Validate generated machine-readable rows before declaring the run successful.
    import csv
    generated_rows = 0
    paired = {}
    for file in paths:
        if file.suffix == '.csv' and file.stem != 'buffer_cost_curves':
            with file.open(encoding='utf-8', newline='') as stream:
                for row in csv.DictReader(stream):
                    u, U, r = (float(row[key]) for key in ('u', 'U', 'r'))
                    assert 0 <= u <= U and float(row['b_over_d']) >= -1e-12
                    assert close(float(row['b_over_d'])+r+u, 1+float(row['epsilon_E']))
                    assert float(row['expected_W']) >= -1e-12 and float(row['expected_v']) >= -1e-12
                    assert close(float(row['expected_W'])+float(row['expected_v']), float(row['expected_q']))
                    assert close(float(row['private_cost']), float(row['c'])*(r+u)
                                 +float(row['p'])*float(row['expected_W'])
                                 +float(row['g'])*float(row['expected_v']))
                    assert float(row['kkt_residual']) < 1e-10
                    if row['bank_type'] in ('1', '2') and row['type_cost_gap'] != '':
                        key = (row['experiment'], row['case'], row.get('varied_value', ''))
                        paired.setdefault(key, {})[row['bank_type']] = row
                    generated_rows += 1
    numeric_check('Outputs: all experiment rows satisfy accounting, feasibility, cost and KKT checks', True)
    for pair in paired.values():
        first, second = pair['1'], pair['2']
        gap = float(second['private_cost'])-float(first['private_cost'])
        assert close(float(first['type_cost_gap']), gap) and close(float(second['type_cost_gap']), gap)
        allowed = ('B' if first['case'] == 'Base' else
                   'tauB' if first['case'] == 'Base_rate' else 'beta')
        parameters = ('d', 'B', 'tauB', 'rho_m', 'epsilon_E', 'beta', 'phi', 'chi', 'p', 'g', 'c', 'states')
        for parameter in parameters:
            if parameter != allowed:
                assert first[parameter] == second[parameter], (first['case'], parameter)
    numeric_check('Outputs: paired cost gaps and pure exposure/Base/Base-rate experiments', True)
    with (Path(__file__).resolve().parent/'output'/'buffer_cost_curves.csv').open(
            encoding='utf-8', newline='') as stream:
        cost_curve_rows = 0
        for row in csv.DictReader(stream):
            model = baseline() if row['bank_type'] == '1' else replace(baseline(), beta=1.35)
            assert close(float(row['J']), model.objective(float(row['u'])))
            assert close(float(row['optimum_u']), model.optimum()['u'])
            cost_curve_rows += 1
    numeric_check('Outputs: every cost-curve point and reported optimum reproduced', True)
    diagnostics['validated_experiment_rows'] = generated_rows
    diagnostics['validated_cost_curve_rows'] = cost_curve_rows
    report = Path(__file__).resolve().parent/'output'/'buffer_verification.json'
    counts = {section: sum(item['section'] == section for item in CHECKS)
              for section in ('historical_october', 'v51_course_core')}
    report.write_text(json.dumps(dict(status='PASS', counts=counts, checks=CHECKS,
                                      diagnostics=diagnostics,
                                      scope='Conditional direct-support benchmark; not advisor approval, OTC equilibrium or Peru calibration'),
                                 indent=2, allow_nan=False)+'\n', encoding='utf-8')
    print('\nCHECK COUNTS:', counts)
    for file in [*paths, report]:
        print('GENERATED:', file.relative_to(Path(__file__).resolve().parents[1]).as_posix())
    print('All historical and V5.1-course-core checks passed. OTC extension remains deferred.')

    print('\n=== POST-MARCO COURSE CORE: prescribed allocation; phi=common coverage; atomistic best responses only ===')
    from verify_post_marco import run_checks
    post_checks, post_paths, _ = run_checks()
    SECTION = 'post_marco_course_core'
    CHECKS.extend(dict(section=SECTION, check=label, status='PASS') for label in post_checks)
    combined = dict(counts, post_marco_course_core=len(post_checks))
    print('\nALL-MODEL CHECK COUNTS:', combined, 'TOTAL:', sum(combined.values()))
    for file in post_paths:
        print('GENERATED:', file.relative_to(Path(__file__).resolve().parents[1]).as_posix())
    print('All checks passed. Post-Marco results are conditional best responses, not an equilibrium or incidence-direction theorem.')


if __name__ == '__main__':
    main()
