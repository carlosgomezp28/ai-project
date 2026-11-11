"""Constructed post-Marco COURSE illustrations, not a thesis calibration.

All displayed u* are atomistic best responses to frozen reference schedules.
No fixed point or voluntary interbank participation is implemented.
"""

import csv
import json
from dataclasses import asdict, replace
from pathlib import Path

import numpy as np

from post_marco_model import BankType, ShockState, allocate, freeze_problem


def baseline():
    banks = (BankType('1', .6, 1.0, .8, .65, .8),
             BankType('2', .4, 1.6, 1.2, .80, .8))
    states = (ShockState(-.4, .4, .5), ShockState(0.0, .6, .5))
    parameters = dict(r=.045, i=.015, kappa=.25, rho=.10, nu_F=.05, R=.0088)
    reference_buffers = (.10, .10)
    D = sum(b.mu*b.d for b in banks)
    F = parameters['nu_F']*parameters['rho']*D+parameters['R']
    rows = allocate(banks, states, reference_buffers, F)
    problems = tuple(freeze_problem(b, states, rows, parameters['r'], parameters['i'],
                                    parameters['kappa'], F) for b in banks)
    return banks, states, parameters, reference_buffers, rows, problems


def result_row(problem, experiment, varied_value):
    optimum = problem.optimum()
    row = dict(experiment=experiment, varied_value=varied_value,
               bank_type=problem.bank.name, **asdict(problem.bank),
               r=problem.r, i=problem.i, kappa=problem.kappa, F=problem.F,
               **problem.metrics(optimum['u']), regime=optimum['regime'],
               unique=optimum['unique'], convex=optimum['convex'],
               kkt_residual=optimum['kkt_residual'],
               minimizer_points=json.dumps(optimum['minimizer_points']),
               minimizing_flat_intervals=json.dumps(optimum['minimizing_flat_intervals']),
               schedules=json.dumps([asdict(s) for s in problem.schedules], sort_keys=True),
               scope='individual best response; frozen reference schedules; not equilibrium')
    row['local_du_dF'] = ''
    try:
        row['local_du_dF'] = problem.capacity_response()
    except ValueError:
        pass
    return row


def experiment_data():
    banks, states, parameters, buffers, reference, problems = baseline()
    deposits = sum(b.mu*b.d for b in banks)
    reserve_capacity = parameters['nu_F']*parameters['rho']*deposits
    optima = [result_row(p, 'baseline', '') for p in problems]
    curves = [dict(bank_type=p.bank.name, u=float(u), J=p.objective(float(u)))
              for p in problems for u in np.linspace(0, p.bank.u_max, 401)]
    capacity, incidence, accounting = [], [], []
    # The normal reference state has Delta=0.02704. Keep this figure strictly
    # below that threshold; saturated/zero/kink regimes are tested separately.
    for F in np.linspace(.007, .024, 45):
        F = float(F)
        for problem in problems:
            row = result_row(problem.at_capacity(F), 'capacity_F', F)
            row['backing_R'] = F-reserve_capacity
            capacity.append(row)
        # This accounting uses the FIXED reference buffers, not the u* above.
        rows = allocate(banks, states, buffers, F)
        accounting.extend(rows)
        C = {b.name: sum(s.probability*row['coverage'] for s, row in
                        zip(states, [r for r in rows if r['bank_type'] == b.name])) for b in banks}
        total_C = sum(b.mu*C[b.name] for b in banks)
        for bank in banks:
            incidence.append(dict(F=F, backing_R=F-reserve_capacity, bank_type=bank.name,
                                  mu=bank.mu, d=bank.d, fixed_reference_u=buffers[int(bank.name)-1],
                                  C_k=C[bank.name], Cbar=total_C, aggregate_deposits=deposits,
                                  I=(C[bank.name]/bank.d)/(total_C/deposits) if total_C > 0 else '',
                                  interpretation='fixed-buffer coverage share; not transfers or welfare'))
    exposure = []
    for beta in np.linspace(.6, 1.6, 41):
        for problem in problems:
            # A single atomistic type-2 bank changes beta. The population and
            # its market schedules remain the disclosed BASELINE reference.
            changed = (replace(problem, bank=replace(problem.bank, beta=float(beta)))
                       if problem.bank.name == '2' else problem)
            exposure.append(result_row(changed, 'individual_beta2_fixed_schedules', float(beta)))
    tables = dict(baseline_optima=optima, cost_curves=curves, capacity_sweep=capacity,
                  exposure_sweep=exposure, reference_market_accounting=accounting,
                  fixed_buffer_incidence=incidence)
    return tables


def generate_outputs():
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt

    directory = Path(__file__).resolve().parent
    output, figures = directory/'output/post_marco', directory/'figures/post_marco'
    output.mkdir(parents=True, exist_ok=True)
    figures.mkdir(parents=True, exist_ok=True)
    tables = experiment_data()
    files = []
    for name, rows in tables.items():
        path = output/(name+'.csv')
        with path.open('w', encoding='utf-8', newline='') as stream:
            writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
            writer.writeheader()
            writer.writerows(rows)
        files.append(path)
    banks, states, parameters, buffers, reference, _ = baseline()
    D = sum(b.mu*b.d for b in banks)
    config = dict(status='constructed_course_specialization', banks=[asdict(b) for b in banks],
                  states=[asdict(s) for s in states], parameters=parameters,
                  reference_buffers=buffers, aggregate_deposits=D,
                  baseline_F=parameters['nu_F']*parameters['rho']*D+parameters['R'],
                  reference_market=reference,
                  scope='Frozen-schedule individual best responses; no equilibrium fixed point',
                  assumptions_added_for_course=['finite A states', 'conditional uniform eps',
                                                'compact buffer domain [0,0.8]'],
                  not_claimed=['Peru estimates', 'advisor acceptance of open decisions',
                               'voluntary participation', 'directional incidence theorem'],
                  provenance='Joint thesis: Carlos Gomez Puican and Fabian Mendez Suarez under Marco Ortiz, using his benchmark note; individual course closure: Carlos.',
                  source='thesis-bank-liquidity-peru/docs/ie1/post_marco/final_candidate_11nov_academic_review/sections/05_analytical_framework.tex; equations (1)-(7)',
                  source_file_sha256={'05_analytical_framework.tex': 'aa03f4507289b33f396277610cc2fce04c79114836f4c7c93a60bb0ee317357f',
                                      '06_methodology.tex': 'a0c49699ee872e93194ce5491b1f8c294ecdcdb722066d9ba92ab98776eb5f48'},
                  history='October and November-4 models retained unchanged in separate modules')
    path = output/'parameters.json'
    path.write_text(json.dumps(config, indent=2, allow_nan=False)+'\n', encoding='utf-8')
    files.append(path)

    plt.rcParams.update({'font.size': 10, 'axes.spines.top': False, 'axes.spines.right': False})

    def finish(fig, name):
        fig.text(.5, .025, 'Constructed parameters, not estimates for Peru. Frozen market schedules; individual best responses only.',
                 ha='center', fontsize=8)
        fig.tight_layout(rect=(0, .08, 1, .94))
        file = figures/(name+'.png')
        fig.savefig(file, dpi=170)
        plt.close(fig)
        files.append(file)

    fig, ax = plt.subplots(figsize=(9, 5.1))
    for bank in banks:
        rows = [r for r in tables['cost_curves'] if r['bank_type'] == bank.name]
        optimum = next(r for r in tables['baseline_optima'] if r['bank_type'] == bank.name)
        ax.plot([r['u'] for r in rows], [r['J'] for r in rows],
                label=f'Type {bank.name}: beta={bank.beta:g}, tau={bank.tau:g}')
        ax.scatter([optimum['u']], [optimum['J']], zorder=3)
    ax.set(xlabel='Voluntary buffer u (per deposit)', ylabel='Expected net private cost J (per deposit)',
           title='Buffer choice with borrowing costs and lending income')
    ax.legend()
    finish(fig, 'cost_and_optima')

    fig, ax = plt.subplots(figsize=(9, 5.1))
    for bank in banks:
        rows = [r for r in tables['capacity_sweep'] if r['bank_type'] == bank.name]
        ax.plot([r['F'] for r in rows], [r['u'] for r in rows], label=f'Type {bank.name}')
    ax.set(xlabel='Common capacity F (liquidity amount)', ylabel='Optimal individual buffer u* (per deposit)',
           title='Capacity response: all reference states remain rationed')
    secondary = ax.secondary_xaxis('top', functions=(lambda F: F-.05*.1*D, lambda R: R+.05*.1*D))
    secondary.set_xlabel('Additional backing R; nu_F rho D fixed')
    ax.legend()
    finish(fig, 'capacity_response')

    fig, ax = plt.subplots(figsize=(9, 5.1))
    for bank in banks:
        rows = [r for r in tables['exposure_sweep'] if r['bank_type'] == bank.name]
        ax.plot([r['varied_value'] for r in rows], [r['u'] for r in rows],
                label='Type 1 fixed' if bank.name == '1' else 'Type 2 individual exposure varies')
    ax.set(xlabel='Individual type-2 exposure beta (A is adverse or zero here)',
           ylabel='Optimal individual buffer u* (per deposit)',
           title='Exposure experiment: access and market schedules held fixed')
    ax.legend()
    finish(fig, 'exposure_response')
    return files
