"""Deterministic constructed-parameter illustrations; run via code/verify.py.

V5.1 joint architecture: Carlos Gomez Puican and Fabian Mendez Suarez under
Marco Ortiz. Individual course closure: Carlos. Provisional, not advisor-approved;
not estimates for Peru. OTC/interbank/search/Nash remain a modular extension.
"""

import csv
import json
from dataclasses import asdict, replace
from pathlib import Path

import numpy as np

from buffer_model import AggregateState, BufferModel


def baseline():
    return BufferModel(d=1.0, B=0.6, tauB=0.10, rho_m=0.35, epsilon_E=0.10,
                       beta=1.0, phi=0.50, chi=0.20, p=0.04, g=0.40, c=0.035,
                       states=(AggregateState(0.0, 0.70, 0.20),
                               AggregateState(0.45, 0.30, 0.20)))


def result_row(model, experiment, case, bank_type, **extra):
    optimum = model.optimum()
    parameters = asdict(model)
    parameters['states'] = json.dumps(parameters['states'], sort_keys=True)
    return dict(experiment=experiment, case=case, bank_type=bank_type,
                **parameters, r=model.r, U=model.U, **model.metrics(optimum['u']),
                regime=optimum['regime'], unique=optimum['unique'],
                minimizer_lower=optimum['minimizer_lower'],
                minimizer_upper=optimum['minimizer_upper'],
                kkt_residual=optimum['kkt_residual'], type_cost_gap='', **extra)


def paired_rows(models, experiment, case, **extra):
    rows = [result_row(m, experiment, case, str(i+1), **extra) for i, m in enumerate(models)]
    gap = rows[1]['private_cost']-rows[0]['private_cost']
    for row in rows:
        row['type_cost_gap'] = gap
    return rows


def write_csv(path, rows):
    fields = list(dict.fromkeys(key for row in rows for key in row))
    with path.open('w', newline='', encoding='utf-8') as stream:
        writer = csv.DictWriter(stream, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def generate_outputs():
    """Called only after checks pass by the single executable entry point."""
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt

    directory = Path(__file__).resolve().parent
    output, figures = directory/'output', directory/'figures'
    output.mkdir(exist_ok=True)
    figures.mkdir(exist_ok=True)
    base = baseline()
    models = (base, replace(base, beta=1.35))
    optimum_rows = paired_rows(models, 'baseline_cost', 'exposure_types')
    curves = []
    for bank_type, model in enumerate(models, 1):
        for u in np.linspace(0, model.U, 401):
            curves.append(dict(bank_type=bank_type, u=float(u), J=model.objective(float(u)),
                               optimum_u=model.optimum()['u']))

    reserve_rows = []
    for phi, label in ((0.6, 'phi>chi'), (0.2, 'phi=chi'), (0.0, 'phi<chi')):
        for r in np.linspace(0.04, 0.44, 81):
            model = replace(base, phi=phi).at_reserve_burden(float(r))
            row = result_row(model, 'reserve_burden', label, '1')
            try:
                row['local_du_dr'] = model.reserve_response()
            except ValueError:
                row['local_du_dr'] = ''
            reserve_rows.append(row)

    exposure_rows = []
    for beta in np.linspace(0.6, 1.6, 51):
        exposure_rows.extend(paired_rows((base, replace(base, beta=float(beta))),
                                        'pure_exposure', f'beta2={beta:.3f}', varied_value=float(beta)))

    regulation_rows = []
    for B in np.linspace(0.1, 1.2, 56):
        regulation_rows.extend(paired_rows((base, replace(base, B=float(B))),
                              'pure_regulation', 'Base', varied_value=float(B)))
    for tauB in np.linspace(0.02, 0.40, 39):
        regulation_rows.extend(paired_rows((base, replace(base, tauB=float(tauB))),
                              'pure_regulation', 'Base_rate', varied_value=float(tauB)))

    tables = dict(buffer_type_optima=optimum_rows, buffer_cost_curves=curves,
                  buffer_reserve_sweep=reserve_rows, buffer_exposure=exposure_rows,
                  buffer_regulation=regulation_rows)
    paths = []
    for name, rows in tables.items():
        file = output/(name+'.csv')
        write_csv(file, rows)
        paths.append(file)

    plt.rcParams.update({'font.size': 10, 'axes.spines.top': False, 'axes.spines.right': False})

    def finish(fig, name):
        fig.text(0.5, 0.015, 'Constructed parameters; not estimates for Peru. Direct support only; advisor review pending.',
                 ha='center', fontsize=8)
        fig.tight_layout(rect=(0, 0.055, 1, 0.95))
        file = figures/(name+'.png')
        fig.savefig(file, dpi=170)
        plt.close(fig)
        paths.append(file)

    fig, ax = plt.subplots(figsize=(8, 4.8))
    for i, model in enumerate(models, 1):
        us = np.linspace(0, model.U, 401)
        ax.plot(us, [model.objective(float(u)) for u in us], label=f'Type {i}: beta={model.beta:g}')
        optimum = model.optimum()
        ax.scatter([optimum['u']], [model.objective(optimum['u'])], zorder=3)
    ax.set(xlabel='Voluntary buffer u (per deposit)', ylabel='Private cost J(u) (per deposit)',
           title='Direct-support buffer cost and optimum')
    ax.legend()
    finish(fig, 'buffer_cost')

    fig, axes = plt.subplots(1, 3, figsize=(12, 4.2), sharey=True)
    for ax, label in zip(axes, ('phi>chi', 'phi=chi', 'phi<chi')):
        rows = [r for r in reserve_rows if r['case'] == label]
        ax.plot([r['r'] for r in rows], [r['u'] for r in rows])
        for regime, marker in (('lower_corner', 'v'), ('upper_corner', '^')):
            corners = [r for r in rows if r['regime'] == regime]
            if corners:
                ax.scatter([r['r'] for r in corners], [r['u'] for r in corners], marker=marker, label=regime)
                ax.legend(fontsize=8)
        ax.set(title=f"{label}; phi={rows[0]['phi']:g}, chi={base.chi:g}", xlabel='Reserve burden r')
    axes[0].set_ylabel('Optimal voluntary buffer u*')
    finish(fig, 'buffer_reserve_usability')

    def comparison_figure(rows, cases, name, title):
        fig, axes = plt.subplots(2, len(cases), figsize=(6*len(cases), 6), squeeze=False)
        for column, case in enumerate(cases):
            chosen = [r for r in rows if r['bank_type'] == '2' and
                      (r['case'] == case or case == 'beta')]
            xs = [r['varied_value'] for r in chosen]
            axes[0, column].plot(xs, [r['u'] for r in chosen], label='Type 2')
            reference = base.optimum()['u']
            axes[0, column].axhline(reference, color='gray', linestyle='--', label='Type 1 (fixed)')
            display_case = {'beta': 'Exposure beta', 'Base': 'Historical Base B',
                            'Base_rate': 'Base rate tauB'}[case]
            axes[0, column].set(ylabel='Optimal buffer u*', title=display_case)
            axes[0, column].legend()
            axes[1, column].plot(xs, [r['type_cost_gap'] for r in chosen])
            axes[1, column].axhline(0, color='gray', linewidth=0.8)
            axes[1, column].set(xlabel=display_case, ylabel='Private cost gap (J2 - J1)')
        fig.suptitle(title)
        finish(fig, name)

    comparison_figure(exposure_rows, ['beta'], 'buffer_exposure', 'Pure exposure experiment')
    comparison_figure(regulation_rows, ['Base', 'Base_rate'], 'buffer_regulation',
                      'Pure regulatory experiments at fixed deposits')

    metadata = dict(
        architecture_provenance='Joint work: Carlos Gomez Puican and Fabian Mendez Suarez; supervisor Marco Ortiz',
        individual_contribution='Carlos: course optimization, verification and simulation closure',
        status='Proposed V5.1-course restriction; not advisor-approved; constructed parameters, not Peru estimates',
        scope='Direct support only. OTC/interbank/search/matching/Nash deferred as a separate modular extension.',
        notation=dict(u='voluntary buffer', v='deferral', phi='reserve usability',
                      chi='public eligibility coefficient', p='public funding unit cost',
                      g='deferral unit cost', c='reserve opportunity cost',
                      epsilon_E='equity ratio', eps_k='idiosyncratic liquidity shock'),
        assumptions=['Finite aggregate states; eps_k conditional uniform on symmetric support',
                     'Exogenous deposits; g>p>=0; c>0; 0<=phi<=1; 0<=chi<1; U>0',
                     'Incremental costs; assistance/deferral principal remains payable',
                     'No interbank encounter; no aggregate public capacity or R_D',
                     'Reserve sweep realizes r through B=d, tauB=r; other primitives fixed'],
        baseline=asdict(base), row_counts={key: len(value) for key, value in tables.items()},
        files=[p.relative_to(directory).as_posix() for p in paths],
        units='Amounts normalized by deposits, except d, B and reserve amount R; type gap is J2-J1',
        nonunique_convention='Report leftmost minimizer and full minimizer interval; do not claim uniqueness',
    )
    file = output/'buffer_experiments.json'
    file.write_text(json.dumps(metadata, indent=2, allow_nan=False)+'\n', encoding='utf-8')
    paths.append(file)
    return paths
