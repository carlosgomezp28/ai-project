# Handwritten evidence: current post-Marco paper

The thesis architecture is joint work by **Carlos Gómez Puicán and Fabián Méndez Suárez**, supervised by **Marco Ortiz**. Carlos's individual course contribution is the private buffer-choice closure, proofs, computational verification and constructed simulations.

## Assessment: PASS on substantive mathematics

The accepted current set contains **eight genuine student PDFs (02–09), 23 pages**. All 17 pages of 03 and 06–09 were visually audited against the [current paper](../paper/paper.tex) and [typed guides](guides/); 02, 04 and 05 retain their previous reconciled evidence. Manuscript 06 was genuinely corrected and re-exported by the student, then reinspected. No scan was digitally altered during integration.

| Manuscript | Pages | Demonstrated mathematics |
|---|---:|---|
| [02 — Shortfall and surplus](02-post-marco-shortfall-surplus.pdf) | 2 | Signed flows, normalized/amount derivatives and the explicit student unit verdict: −0.30 versus −0.48 when deposits equal 1.6. |
| [03 — Buffer optimality](03-post-marco-buffer-optimality.pdf) | 2 | Lender-inclusive FOC, density-weighted curvature and corrected convex upper-corner condition. Read its page 2 negative-curvature sentence with **07, page 3**. |
| [04 — Capacity response](04-post-marco-capacity-response.pdf) | 2 | Nonnegative capacity partial, strict-exposure restrictions and construction of the IFT branch before differentiation. |
| [05 — Conservation and incidence](05-post-marco-conservation-incidence.pdf) | 2 | Interbank conservation, fund bounds, weighted relative incidence and zero-demand accounting with expected aggregate coverage F p_B. |
| [06 — Differentiation and existence](06-post-marco-differentiation-existence.pdf) | 3 | Positive homogeneity, moment identity, dominated differentiation, atomlessness, continuity, lender-inclusive FOC, compactness/existence and density evaluated at −u. Page 1 explicitly assumes E_j[abs(omega)] < infinity; page 3 correctly gives D_u = 1.6(−0.30) = −0.48. |
| [07 — Convexity and optimality](07-post-marco-convexity-optimality.pdf) | 3 | Convex decomposition, supporting inequality, corners, uniqueness and the full-coverage negative-curvature counterexample. Page 3 provides the genuine qualification to 03. |
| [08 — Uniform integration and enumeration](08-post-marco-uniform-enumeration.pdf) | 4 | All integral branches, reflection, tail probabilities, support joins, full knot partition, global candidates, corners, flat intervals, ties and numerical-tolerance limitations. |
| [09 — Optimizer continuation and incidence](09-post-marco-optimizer-continuation-incidence.pdf) | 5 | Local regularity, actual IFT construction, strict local minima, capacity sign/strictness, compact-gap global continuation, conservation, zero-demand states and F p_B incidence cancellation. |

## Manuscript 03 qualification/addendum

**Manuscript 07, page 3, is a genuine handwritten qualification/addendum to manuscript 03, page 2. It establishes the positive threshold-density condition for a strictly negative state curvature contribution.**

Under full coverage, a negative coefficient contributes strictly negative curvature only where the conditional density at **−u** is positive. The new handwritten page also explains that other states can offset this contribution. The original manuscript 03 was **not physically modified** during this integration and is not represented as containing a newly inserted sentence. Read the two pages together.

## Minor editorial clarifications

These clarify the accepted mathematics without pretending the original scans contain different expressions:

- **06, page 3:** finiteness uses the corrected first-moment assumption and the bound positive-part(±(omega+u)) <= abs(omega)+abs(u); the Lipschitz inequalities establish continuity.
- **07, page 2:** the weak corner tests mean that **0 or u_bar belongs to argmin J**. They do not uniquely select a corner when several minimizers exist. Strict endpoint inequalities supply the separate uniqueness claims.
- **07, page 3:** the displayed decimal psi_1 = 0.041202615 is rounded; read it as an approximation. The preceding ratio is exact and supports the curvature sign independently of rounding.

No additional substantive handwritten proof was required after the comprehensive audit. The uniform support joins are C1 without a general second-derivative claim there. The IFT supplies local minima first; the compact-gap argument separately establishes conditional global continuation. Zero residual demand contributes zero coverage, and the relative index requires positive expected aggregate coverage. These are conditional individual/fixed-profile results, not aggregate equilibrium or welfare statements.

## Evidence, human verdicts and preparation guides

The actual human unit verdict is visible in manuscript 02. The student reported correcting and re-exporting manuscript 06, and its accepted pages directly demonstrate those corrections. Codex independently audited the mathematics. Student-written work is not automatically a blanket student endorsement of every AI contribution, nor evidence of student execution of all program checks. No unrecorded disagreement or verdict is invented. See [prompts.md](../prompts.md) and paper Appendix D.

The [four typed guides](guides/) are preserved unchanged as AI-assisted preparation materials. Their pending-language records the preparation stage; they are not handwriting or student-verification records. The accepted PDFs above now supply the audited work. All historical and genuine post-Marco scans are preserved; no combined `Post_marco_derivations.pdf` is claimed to exist. The [delivered presentation](../slides/final.pdf) and its authentic manuscript-02 crop remain unchanged.

## Historical evidence and separate formalization

- [Hand_derivation.pdf](Hand_derivation.pdf): historical October public-dollar-backing manuscript (6 pages).
- [FINAL_DERIVATION_GUIDE.md](FINAL_DERIVATION_GUIDE.md): historical typed November-4 eligibility/deferral guide for paper commit `cf37d3f`.
- The existing [lean/](../lean/README.md) is historical. A separate provisional post-Marco package has proved Proposition 1 and local support for Proposition 2; global continuation remains open in Lean. Its final source pin/revalidation and integration are separate tasks, not performed by adding these scans.

Only **33 of the 99** Python checks concern the current model; handwritten reasoning, program checks and Lean proofs have distinct scopes.
