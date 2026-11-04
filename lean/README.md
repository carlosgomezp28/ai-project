# Paper formalization plan

**Current status: NOT YET FORMALIZED.** No Lean proof, successful build,
paper-scoped check, generated paper folder, or formalized paper commit exists
for the new core. `7406387` is the Phase 1 code checkpoint, not a pinned paper
formalization. This README is a plan, not verification evidence.

The proposed V5.1 architecture is joint work by Carlos Gómez Puicán and Fabián
Méndez Suárez under Marco Ortiz. Its explicitly open choices remain pending
advisor validation. The direct-support restriction, optimization, proofs,
verification, simulations and formalization effort are Carlos's individual
course contribution. OTC/search/matching/Nash are outside these targets.

## Paper-to-Lean distinction

Proposition 1 in `paper/paper.tex` uses an integrable atomless law. Proposition 2
additionally requires local continuous density, positive curvature, an interior
solution and fixed primitives. Uniform shocks are a specialization for closed
forms, simulation and a tractable finite algebraic implementation.

For sigma>0 define ell_sigma(z) by -z below -sigma,
(sigma-z)^2/(4*sigma) between -sigma and sigma, and zero above sigma.
Define Pi_sigma(z) by 1, (sigma-z)/(2*sigma), and zero on those regions.
The explicit finite objective is

    Jhat(u,r) = c*(r+u)
               + p*sum_j w_j*ell_sigma_j(t1-beta*A_j)
               + (g-p)*sum_j w_j*ell_sigma_j(t2-beta*A_j).

These definitions must be identical in the paper appendix and Lean. Verifying
their algebra does not by itself verify a probabilistic expectation identity.

## Exact targets A-F

### A. Assistance/deferral optimum - main

Statement: for q,H>=0 and g>p>=0, the unique feasible minimizer of pW+gv under
W+v=q and 0<=W<=min(q,H) is W=min(q,H), v=(q-H)^+.

- Verifies: feasibility, the cost comparison against every feasible alternative,
  and uniqueness, including zero q or H.
- Does not verify: the institutional interpretation of eligibility or prices.
- Dependencies: real order, min/max, affine cost and inequalities.
- Status: NOT YET FORMALIZED.

### B. Positive-part representation - main

Statement: H>=0 implies (a^+-H)^+=(a-H)^+; with q=(e-t1)^+ and
H=chi*(U-u), v=(e-t2)^+ and optimized cost is p*q+(g-p)*v.

- Verifies: the exact scalar reduction used in Proposition 1.
- Does not verify: probabilities or an interbank continuation value.
- Dependencies: A, positive-part case splits and field arithmetic.
- Status: NOT YET FORMALIZED.

### C. Uniform shortfall calculus - main

Statement: ell_sigma is convex and continuously differentiable, with derivative
-Pi_sigma; its second derivative is 1/(2*sigma) strictly inside support and zero
strictly outside. Values and first derivatives join at both endpoints.

- Verifies: the explicit piecewise function, calculus and endpoint joins.
- Does not verify: ell_sigma=E[(eps-z)^+] unless the integral bridge in F is
  also completed. No global C2 claim is permitted.
- Dependencies: real calculus, piecewise functions, continuity and convexity.
- Status: NOT YET FORMALIZED.

### D. Finite-uniform Proposition 1 implementation - main

Statement: under positive sigma_j, nonnegative finite weights summing to one,
U>0, g>p>=0, c>0 and 0<=chi<1, Jhat has the displayed derivative, is continuous
and convex on [0,U], attains a minimum, and has the exact variational/corner/FOC
characterization. Include sufficient uniqueness from strict endpoint slopes or
positive local curvature at an interior stationary point. Do not claim universal
interiority, strict convexity or uniqueness.

- Verifies: the full explicit finite-function optimization statement, not just
  a polynomial FOC inside one support region.
- Does not verify: the general atomless-distribution Proposition 1 automatically.
- Dependencies: A-C, finite sums, compact intervals, extremum and convexity theory.
- Status: NOT YET FORMALIZED.

### E. Proposition 2 identity and sign - main conditional target

Statement: along a differentiable feasible interior FOC branch with positive
G_u, derive G_u=J_uu, the displayed G_r, u_r=-G_r/G_u, and u_r<=0 for phi>=chi.
Strictness requires positive numerator. For phi<chi use the stated dominance
conditions, not a universal positive sign.

- Verifies: threshold derivatives, chain rule, mixed derivative and sign algebra.
- Does not verify: existence of the branch unless the implicit-function bridge
  in F is proved. Merely assuming the desired derivative would be unacceptable.
- Dependencies: D, local support exclusions, differentiability and inequalities.
- Status: NOT YET FORMALIZED.

### F. Probability and implicit-function bridges - stretch work, needed for full claims

Statements: derive ell_sigma from the uniform integral; prove the general
expected-shortfall derivative using atomlessness and integrability; prove that
the local regularity assumptions produce the differentiable optimal branch.

- Verifies: transfer from the probabilistic model to closed forms and the full
  local existence component of Proposition 2.
- Does not verify: advisor approval, calibration, welfare or an OTC equilibrium.
- Dependencies: measure/integration theory, differentiation under expectations,
  and an implicit-function theorem with checked hypotheses.
- Status: NOT YET FORMALIZED. If unfinished, disclose precisely which bridge is
  open; completed algebraic companions do not close the general propositions.

## Reporting and later workflow

The paper's formalization appendix must have one row for each numbered result.
Use proved, proved under an added hypothesis (explicitly named), or open with
the exact blocker. A verified closed-form companion must not be reported as a
proved general probabilistic proposition without the corresponding bridge.
Do not add the conclusion as a hypothesis or hide `sorry`.

After the paper statements are stable and a later checkpoint is authorized,
follow Issue #7's AppliedModelingLib paper-formalization workflow against the
actual pinned paper PDF. A proposed folder name is `Gomez26EligibilityBuffers`;
the generated content and declarations do not exist yet. Run the prescribed
paper-scoped check and copy the complete generated paper folder exactly as
produced, respecting its `.gitignore`. Record the actual paper commit,
declarations, file locations, added assumptions and check output in the paper.
If a proposition changes afterward, repeat the corresponding workflow.

Do not fabricate generated files or a successful run in advance. This phase
does not authorize commits, pushes, merges, PRs or an external formalization run.
