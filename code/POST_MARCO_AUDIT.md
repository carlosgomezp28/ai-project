# Post-Marco AI-course migration audit — 10 November 2026

Branch: `final-13nov-post-marco`. This audit implements code/simulations only.
No slide, paper, historical hand derivation, Lean file or thesis source is edited.
No commit, push, merge, PR, or canonical Lean closeout is authorized/performed.

## 1. Source authority and migration diagnosis

The current source is the thesis repository's
`docs/ie1/post_marco/final_candidate_11nov_academic_review/sections/05_analytical_framework.tex`
(equations 1–7) and `06_methodology.tex`. Thesis HEAD inspected:
`e4b863b4581eaaad3db7d3ee0cffe9a21ab35b8e`. The actual source-file SHA-256 pins
are recorded in `output/post_marco/parameters.json`; local review-package files
are not silently represented as committed or approved.

Also inspected: `integration_09nov/outputs/IE1_FREEZE_09NOV.md` and
`paquete_revision_marco/{DECISIONES_PARA_MARCO,STORYTELLING_PARA_MARCO,JURY_FEEDBACK_CLOSURE}.md`.
The freeze is a recommendation, not advisor approval. The latest decisions
document explicitly leaves A (prescribed participation), B (operational
hypothesis/shocks/domain), and C (deferral of voluntary participation/Nash)
pending. The candidate's directory name is not an advisor-approval record.

The thesis architecture is joint Carlos Gómez Puicán / Fabián Méndez Suárez work
under Marco Ortiz, incorporating his benchmark note. Carlos's individual
course contribution is the best-response derivation, conditions, implementation,
verification and illustrations. No sole authorship of the architecture is claimed.

| Existing component | Treatment for final presentation |
|---|---|
| October two-currency backing model, README/proposal/topic slides/hand scan | Historical milestone; not the main final model |
| November-4 asset-linked eligibility model, paper and code | Preserve as historical course development; do not import H=chi(U-u), usable reserve phi, Base rule or its reserve comparative static |
| Existing 31 Lean declarations | Preserve; reuse only their actual scalar/finite-function meanings |
| Post-Marco thesis candidate | One USD currency; NU; prescribed allocation and priority; given i; finite common capacity; free coverage |
| Course specialization implemented here | Finite aggregate states, uniform conditional shocks and compact buffer interval; explicit additional assumptions, not thesis decisions or Peru estimates |
| Aggregate consistency and voluntary participation | OPEN; no fixed point or participation equilibrium claimed |

The thesis asks about heterogeneous coverage incidence. The narrower course
question is: **How does finite common protection change an atomistic bank's
optimal voluntary buffer under prescribed interbank allocation?**

## 2. Independent derivation from equation (7)

Write L_k=D_k/d_k, M_k=X_k/d_k, with fixed d_k>0. Conditional on A,

    L_k(u,A) = E[(-omega_k-u)^+ | A],
    M_k(u,A) = E[(omega_k+u)^+ | A].

Assume an integrable signed shock and an atomless conditional law, almost surely
in A. Positive-part differences are 1-Lipschitz in u. Dominated differentiation
therefore gives, including locations inside gaps of the shock support,

    L_u = -Pr(omega_k+u<0 | A) = -pi_minus,
    M_u =  Pr(omega_k+u>0 | A) =  pi_plus.

There is no mass at zero, so pi_minus+pi_plus=1. Amount derivatives instead are
D_u=-d_k*pi_minus and X_u=d_k*pi_plus. This is not the November-4 convention
of a positive liquidity need e. Positive omega improves liquidity here.

Hold psi_k(A), ell_k(A), phi(A), i, the conditional law, deposits and the
aggregate environment fixed under this single-bank deviation. Define

    a_k(A) = i*psi_k(A) + kappa*(1-phi(A))*(1-psi_k(A)),
    b_k(A) = i*ell_k(A).

Equation (7) is exactly J(u)=r*u+E[a*L-b*M], hence

    J'(u) = r - E[a*pi_minus + b*pi_plus].

Thus the supplied interior FOC is correct. The lending term enters with a
PLUS on the FOC's benefit side: a buffer increases surplus and lending income.
No derivative of the market schedules is included in this atomistic result.

## 3. Curvature, sufficiency and boundaries

With a conditional density continuous near -u, plus conditions allowing the
outer expectation derivative (automatic for the implemented finite mixture
away from support knots),

    J''(u) = E[(a(A)-b(A))*f_{omega|A}(-u)].

The lending-income contribution is NEGATIVE, -E[b*f]. kappa>i alone does not
imply convexity: at phi=1 the difference is i*(psi-ell), which can be negative.
The executable audit includes a nonconvex, fully covered counterexample.

A sufficient global condition is a(A)>=b(A) almost surely, along the whole
fixed-schedule comparison. Indeed M=L+E[omega|A]+u, so

    J(u) = (r-E[b])*u + E[(a-b)*L] - E[b*E[omega|A]].

The weighted positive-part representation proves convexity without demanding
second derivatives at support knots. Weaker sufficient conditions can use
nonnegative expected curvature everywhere with appropriate continuity.
Local J''(u*)>0 gives a strict local minimum, not automatic global uniqueness.
Under global convexity it also makes that stationary point the unique global
minimum. More generally strict growth of J' on every nontrivial interval gives
strict convexity/uniqueness. A uniform curvature lower bound is sufficient.

For the COURSE domain [0,u_max], continuity gives attainment. If convex,
J'(0)>=0 characterizes a lower minimizer, J'(u_max)<=0 an upper minimizer, and
J'(u*)=0 an interior minimizer; equality may permit nonuniqueness. Without
convexity these first-order conditions are not global sufficiency conditions.
The implementation enumerates every quadratic-region endpoint and stationary
point, and reports flat/disconnected ties rather than assuming uniqueness.

## 4. Conditional capacity result

For Delta(A)>0 and F != Delta(A), hold psi, ell, Delta, P, Q, i, r, kappa,
deposits, feasible domain and shock laws fixed across F. Only phi changes:

    phi_F(A) = 1{0<F<Delta(A)}/Delta(A).

The displayed form is for positive interior capacity comparisons; a one-sided
derivative is needed at F=0. When Delta=0, the source sets phi=0, so this state
has no capacity derivative. At coverage kinks a two-sided derivative is not
asserted. Under local differentiability/IFT regularity and J''(u*)>0,

    du*/dF = - kappa * E[
        1{0<F<Delta(A)}*(1-psi_k(A))*pi_minus(u*,A)/Delta(A)
      ] / J''(u*).

For finite states, require no positive-probability coverage kink and no active
support knot at the selected interior optimum. For a general aggregate law,
also require valid expectation interchange/local integrability of the ratio.
The effect is weakly negative; strictness requires kappa>0 and positive-measure
states jointly having rationing, incomplete interbank coverage, and positive
individual deficit probability. This is a regular local branch result. Calling
the branch a global best response additionally requires global sufficiency or
stability against other minima. The implemented selected minima satisfy the
global interval check. Corners, ties, kinks and branch switching are excluded.

Since F=nu_F*rho*D+R, du*/dR=du*/dF when nu_F,rho,D are fixed. This is NOT a
derivative with respect to rho: rho could also change portfolio constraints.
It is not GE, not a participation result, and not an implication about I_k.

## 5. Constructed numerical design and interpretation

All values below are course choices, not estimates for Peru or newly accepted
thesis assumptions. Monetary amounts use an arbitrary reference liquidity unit.

| Parameter | Value | Interpretation |
|---|---|---|
| mu_1, mu_2 | 0.6, 0.4 | Population masses |
| d_1, d_2 | 1, 1.6 | Deposits per reference bank |
| beta_1, beta_2 | 0.8, 1.2 | Signed-flow exposure; A is adverse or zero in this example |
| tau_1, tau_2 | 0.65, 0.80 | Prescribed access, not estimated search probabilities |
| A, probabilities | (-0.4,0), (0.4,0.6) | Finite aggregate COURSE law |
| eps conditional on A | uniform[-0.5,0.5] | COURSE specialization, common width |
| r, i, kappa | 0.045, 0.015, 0.25 | Per-episode opportunity, borrowing/lending, uncovered costs |
| rho, nu_F | 0.10, 0.05 | NU reserve ratio and common-capacity fraction |
| R, baseline F | 0.0088, 0.015 | Extra backing and total common capacity; D=1.24 |
| Reference buffers | (0.10,0.10) | Disclosed population profile used to form the frozen schedules |
| Individual feasible set | [0,0.8] | Compact COURSE cap; not a settled thesis balance-sheet rule |

The reference population determines P,Q,psi,ell,Delta by state. Individuals then
optimize holding those schedules fixed. Their displayed best responses are NOT
fed back into the population. Conservation is checked for the actual reference
profile, not falsely asserted for the simultaneous profile of frozen-schedule
best responses. Resolving that fixed point is deferred, not assumed solved.

Baseline individual best responses are u_1*=0.41152264 and u_2*=0.55338093,
with J_1*=0.02457788 and J_2*=0.03067155, both unique/interior in this example.
These large buffers are illustrative; they do not predict actual portfolios.
The baseline types differ in BOTH exposure and access; their level difference
does not identify a pure access effect.

The capacity plot varies F from 0.007 to 0.024, hence R from 0.0008 to 0.0178.
Reference residual deficits are 0.3843536 (adverse) and 0.02704 (normal), so
all plotted states remain strictly rationed. Baseline du_1*/dF=-2.37754022 and
du_2*/dF=-1.21491624. Units matter: these are buffer-ratio changes per reference
liquidity amount. An initially wider proposed plotting grid crossed the normal
state threshold; verification rejected the all-rationed label. The grid was
restricted to the intended regime; saturation remains explicitly tested.

The exposure plot changes a single type-2 individual's beta from 0.6 to 1.6,
keeping the population, access and schedules fixed. Its buffer rises from
0.34450249 to 0.71338093 on this grid. Type 1 is unchanged. This does not prove
that increasing exposure to an arbitrary signed A always raises buffers.

Fixed-reference-buffer incidence is exported separately. In all these rationed
states, C_k=F*E[(1-psi_k)D_k/Delta] and Cbar=F, so each I_k is invariant to F.
Absolute coverage increases; relative incidence need not. Endogenous-buffer
incidence is NOT reported as an equilibrium: it would require re-solving
aggregate consistency. Neither I_k nor J differences identify net transfers,
subsidies, welfare or competition. Figure vertical axes are truncated; state
this when presenting the magnitudes.

## 6. Code and validation

`post_marco_model.py` owns signed moments, prescribed allocation/fund accounting,
frozen-schedule objectives, global piecewise optimization and local derivatives.
`simulate_post_marco.py` owns constructed parameters, CSV/JSON and three figures.
`verify_post_marco.py` independently differentiates, integrates, grids and audits
exported rows. `verify.py` remains the ONLY executable entry point.

Run `python code/verify.py`. Its sections preserve 28 historical October and
38 historical November-4 checks, and add 33 post-Marco checks (99 total).
The new audit covers conditional uniform integrals and derivatives, amount
scaling, every interbank short-side/zero regime, fund exhaustion/saturation/zero,
the FOC, negative lending curvature, nonconvexity, corners/flat solutions,
global grids, capacity finite differences, kink rejection and all 1,246 CSV rows.
The old model modules, old CSV/JSON results and figures remain historical.

Maximum errors from the initial successful run: conditional moment integration
2.69e-11; objective finite differences 2.73e-13; curvature differences 9.16e-13;
capacity response differences 1.96e-9; exported optimizer/grid cost gap 3.40e-11.
These are executable numerical/symbolic checks, not new Lean theorems.

New outputs in `output/post_marco/`: `baseline_optima.csv`, `cost_curves.csv`,
`capacity_sweep.csv`, `exposure_sweep.csv`, `reference_market_accounting.csv`,
`fixed_buffer_incidence.csv`, `parameters.json`, `verification.json`.
New figures in `figures/post_marco/`: `cost_and_optima.png`,
`capacity_response.png`, `exposure_response.png`.

## 7. Existing Lean: exactly what can be reused

No Lean folder changes or new formalization run is needed for this migration.
The 31 earlier closures are historical partial formalization of cf37d3f.

- `ell_lower`, `ell_upper`, `pi_lower`, `pi_upper`, `uniform_joins` retain their
  literal scalar meanings; polynomial joins are not actual join derivatives.
- `ell_derivative_below/inside/above`, `ell_derivative`, and
  `ell_second_below/inside/above` verify explicit positive-part branches, with
  their stated support/knot restrictions.
- `finiteLoss_derivative` applies to the reflected signed-flow input:
  mean_j=-beta*A_j and threshold u, giving ell_sigma(u+beta*A_j). For symmetric
  uniform eps, reflecting eps preserves its law. The reflection/probability
  integral interpretation itself is NOT an existing Lean bridge.
- Surplus uses ell_sigma(-beta*A-u), or the moment identity X/d=L+beta*A+u.
  Neither its new model interpretation nor the whole post-Marco FOC was newly
  formalized. The former objective-specific `finiteObjective_derivative` and
  `reserve_response_nonpos` must not be relabeled as proofs of the new model.
- Continuation min/max identities remain scalar truths. Their former
  asset-eligibility optimum is not the current interbank/fund mechanism.

Truthful slide wording: **Existing Lean proofs verify off-knot derivatives of
the explicit finite-uniform positive-part building block. The post-Marco
probability interpretation, buffer FOC, capacity response and equilibrium are
not newly Lean-verified.** No full frozen-paper P1/P2 claim is promoted.

## 8. New handwritten target and AI check

Carlos should write one new derivation (do not overwrite the October scan):
state units, timing and atomistic information; derive D_u/d=-pi_minus and
X_u/d=pi_plus by dominated differences; differentiate equation (7) including
lending income; derive curvature and conditional du*/dF by the IFT; list all
regularity/fixed-environment/strictness assumptions and explain corners/kinks.

Retain amount-versus-normalized scaling as a documented AI-check candidate:
for d=1.6, A=0, sigma=0.5 and u=0.2, pi_minus=0.3, so D_u=-0.48, NOT -0.3.
Carlos must supply his actual independent calculation/verdict; do not invent a
past exchange where an AI or professor asserted or rejected a formula.

## 9. Paper migration map (paper remains unchanged)

| Existing paper/paper.tex part | Status for new final model |
|---|---|
| Abstract line 27; Introduction; joint V5.1 baseline framing | Stale as current-model description; preserve historical contribution/provenance, replace later |
| Model: reserve rule, balance sheet, usable liquidity, asset eligibility, direct-support recourse (lines 60–144) | Stale architecture; do not transfer chi, phi-usability, H or the Base rule |
| P1, equations (9)–(16), lines 147–240 | Historical eligibility theorem; new signed-flow/lending problem needs independent statements/proof and nonautomatic convexity |
| P2, equations (17)–(21), lines 242–289 | Historical reserve-burden theorem; replace later with conditional capacity result, not by renaming r to F |
| Numerical section, table/figures and Delta J incidence, lines 292–375 | Historical figures; new I_k is relative coverage, not the former private-cost gap |
| OTC extension / Conclusion, lines 377–388 | Reframe around prescribed-allocation benchmark and open voluntary participation, not asset-linked OTC as the controlling model |
| Appendix A, lines 397–429 | Uniform positive-part integration/algebra reusable after reflecting the shock sign and adding surplus; old two-threshold objective mapping is not reusable unchanged |
| Verification appendix, lines 431–441 | Historical 28+38 coverage remains valid; add separate 33 checks and new figures later |
| Lean appendix, lines 443–459 | Its 'NOT YET FORMALIZED' blanket claim is stale after the 31 partial closures; new model still needs an honest building-block-only claim |
| AI appendix, lines 461–475 | Normalization and human-verification cautions reusable; eligibility-specific checklist and no-Lean-work wording stale; no invented disagreement |

The paper remains the frozen historical source for the existing Lean package;
do not silently replace its source pin. A future paper revision must separate
the new economic claims from the old formalized scalar building blocks. Existing
references are not evidence of a new literature-wide novelty claim.

## 10. Proposed final deck: 13 main slides / 30 minutes

No slides are created in this run. Present as a research defense, with
mathematical details and parameter/state accounting available in backup later.

| # | Title and defense purpose | Minutes |
|---|---|---:|
| 1 | Uniform contributions, unequal protection: the economic puzzle; provenance | 2 |
| 2 | Current benchmark and scope: USD, NU, two types, prescribed redistribution, finite fund | 2 |
| 3 | Individual course question versus thesis-wide incidence question; what changed historically | 2 |
| 4 | Timing, signed shock, units, and equation (7); bank takes schedules as given | 3 |
| 5 | Post-Marco course Proposition 1: derivative identities and interior FOC; lending benefit | 3 |
| 6 | Why convexity is conditional: curvature, counterexample, corners/uniqueness | 3 |
| 7 | Constructed two-type J curves and global minima; reference population versus best response | 2.5 |
| 8 | Conditional capacity result plus F/R figure; all fixed objects and strictness | 2.5 |
| 9 | Pure exposure illustration; why lower u does not imply a directional I result; fixed-buffer invariance | 2 |
| 10 | What Lean actually verifies: explicit function building block; probability/FOC/GE gaps | 2 |
| 11 | Hand proof and AI unit check: d=1.6 exposes missing-deposit scaling | 2 |
| 12 | Open participation and aggregate consistency: prescribed matching is not a voluntary equilibrium | 2 |
| 13 | Feedback questions and bounded final-paper plan | 2 |

Feedback: (1) Is a conditional prescribed-allocation contribution acceptable
despite unresolved participation? (2) Is the reference-market best response
sufficient for the course, with the population fixed point explicitly open?
(3) Which shock ordering and feasible-domain assumptions should be prioritized
before a broader incidence claim? Do not pretend these decisions are approved.

## 11. Next implementation step, not performed here

After review of these results, the minimal next step modifies only
`slides/final.tex` and compiles `slides/final.pdf`, referencing the three new
figures. Deadline requested: Thursday 12 November, 22:00 Lima; presentation
Friday 13 November. Historical `slides/topic.*` and `proposal/` remain protected.

Carlos separately creates a NEW handwritten scan, e.g.
`hand/Post_marco_buffer_derivation.pdf`, only when the derivation is actually
completed. Never manufacture handwriting or overwrite Hand_derivation.pdf.
After the presentation, a separately authorized pass can migrate
`paper/paper.tex` and `paper/paper.pdf`, update root `README.md` and append real
raw interactions to `prompts.md`. None is modified now. No bibliography change
is justified without new verified literature work. No Lean rewrite is needed
for the proposed building-block slide.
