# Frozen-paper correspondence

Reference: cf37d3f402c04a73c832cce41f559e32348f8941. Equation numbers refer to that version.
These are support declarations and one continuation-block endpoint. They do not
create 31 separate paper-result rows: the paper has TWO numbered propositions,
both partial. Eight named assumptions govern them. No full v11 source-to-Spec
judgments or semantic closeout have been issued.

## Every proved theorem

| Declaration (namespace `Gomez26EligibilityBuffers`) | File | Frozen paper | Premises / added restriction | Fully proved | Outside scope |
|---|---|---|---|---|---|
| `min_add_shortfall` | `BufferCore.lean` | P1 (10), proof | None; arbitrary reals | Accounting identity | No feasibility or optimization claim |
| `continuation_feasible` | `BufferCore.lean` | P1 (10); constraints (7) | q,H>=0; no extra condition | Candidate feasible, including zero cases | No cost comparison |
| `continuation_cost_gap` | `BufferCore.lean` | P1 proof of (10) | Feasible competitor; no extra condition | Exact cost difference | No sign without cost ordering |
| `continuation_optimal` | `BufferCore.lean` | P1 (10) | p<g and feasible competitor | Comparison with every feasible competitor | Candidate feasibility supplied by separate theorem |
| `continuation_unique` | `BufferCore.lean` | P1 (10) | p<g, feasibility, competitor cost <= candidate cost | Both coordinates equal candidate | No ex-ante optimum |
| `continuation_solution` | `BufferCore.lean` | P1 (10) | q,H>=0, 0<=p<g; source assumptions | Feasibility, universal optimality, uniqueness | Rest of P1 |
| `positive_part_reduction` | `BufferCore.lean` | P1 proof between (10) and (11) | H>=0; no extra condition | Nested positive-part reduction | No probability |
| `optimized_cost_identity` | `BufferCore.lean` | P1 proof of (11) | None; scalar identity valid for all reals | Optimized scalar cost decomposition | Expectation bridge |
| `deferral_threshold` | `BufferCore.lean` | P1 (9)--(11), proof | chi*(U-u)>=0; source feasibility consequence made explicit | Exact severe-shortfall threshold | Does not derive eligibility nonnegativity from feasible u |
| `ell_lower` | `BufferCore.lean` | Appendix A (23) | sigma>0 | Lower endpoint value | Differentiability at endpoint |
| `ell_upper` | `BufferCore.lean` | Appendix A (23) | sigma>0 | Upper endpoint value | Differentiability at endpoint |
| `pi_lower` | `BufferCore.lean` | Appendix A (23) | None; holds for all sigma | Lower endpoint tail formula | Probability interpretation |
| `pi_upper` | `BufferCore.lean` | Appendix A (23) | sigma>0 | Upper endpoint tail formula | Probability interpretation |
| `uniform_joins` | `BufferCore.lean` | Appendix A after (23) | sigma>0 | Polynomial endpoint values and slope expressions coincide | Actual derivative at joins, global C1 |
| `ell_derivative_below` | `BufferCore.lean` | Appendix A after (23) | z < -sigma; local algebra does not need sigma>0 | HasDerivAt with slope -1 | Joins and integral bridge |
| `ell_derivative_inside` | `BufferCore.lean` | Appendix A after (23) | sigma>0 and -sigma<z<sigma | HasDerivAt with interior slope | Joins and integral bridge |
| `ell_derivative_above` | `BufferCore.lean` | Appendix A after (23) | sigma>0 and sigma<z | HasDerivAt with slope zero | Joins and integral bridge |
| `ell_derivative` | `BufferCore.lean` | Appendix A after (23) | sigma>0; ADDED restriction z != +/-sigma | Derivative equals -piTail off knots | Paper global derivative statement at knots |
| `ell_second_inside` | `BufferCore.lean` | Appendix A after (23) | sigma>0 and -sigma<z<sigma | Derivative of deriv ell equals 1/(2*sigma) | No global C2 claim |
| `ell_second_below` | `BufferCore.lean` | Appendix A after (23) | z < -sigma | Derivative of deriv ell is zero below support | Knots |
| `ell_second_above` | `BufferCore.lean` | Appendix A after (23) | sigma>0 and sigma<z | Derivative of deriv ell is zero above support | Knots |
| `uniform_curvature_nonneg` | `BufferCore.lean` | Appendix A after (23) | sigma>0 | Nonnegative interior curvature formula | Global convexity |
| `implicit_response` | `BufferCore.lean` | P2 proof of (17), differentiated (18) | Gu!=0 and ASSUMED Gu*response+Gr=0 | Derives quotient; does not assume quotient | Branch existence, actual derivatives, chain-rule bridge |
| `curvature_nonneg` | `BufferCore.lean` | P1 (14); P2 (20) | p>=0, g>=p, f1,f2>=0 | Nonnegative displayed curvature formula | Identification with a second derivative |
| `reserve_response_nonpos` | `BufferCore.lean` | P2 (17),(20),(21) | 0<=p<g, 0<=chi<1, phi>=chi, densities>=0, curvature>0; ASSUMED differentiated FOC equation | Conditional scalar response <=0 | IFT, branch existence, identification of Gu/Gr, optimizer interpretation |
| `finiteLoss_derivative` | `FiniteCompanion.lean` | Appendix A (23),(24) | sigma_j>0; ADDED all-component endpoint exclusions, even weight zero | Derivative of finite sum is negative finiteTail | Weights need not be probabilities; no expectation/integral bridge |
| `finiteObjective_derivative` | `FiniteCompanion.lean` | P1 (11),(12); Appendix A (23),(24) | sigma_j>0; ADDED endpoint exclusions for every component at both thresholds; U,r fixed for u derivative | HasDerivAt for explicit finite objective with exact factor 1-chi | Knots, general law, constrained optimization |
| `finite_foc_iff` | `FiniteCompanion.lean` | P1 (12), finite specialization | None; scalar equation equivalence | Displayed finite derivative zero iff marginal-cost equality | Does not assert optimizer or existence |
| `finiteDensity_nonneg` | `FiniteCompanion.lean` | Appendix A (25) | w_j>=0, sigma_j>0 | Nonnegative finite density FORMULA | Probability density interpretation or normalization |
| `finite_curvature_formula_nonneg` | `FiniteCompanion.lean` | P1 (14); Appendix A (25) | w_j>=0,sigma_j>0,p>=0,g>=p | Nonnegative weighted curvature FORMULA | Does not identify it with actual second derivative; no convexity proof |
| `continuationBlock` | `ProofInterface.lean` | P1 (10), isolated block | Same as continuation_solution | Exact-type endpoint for continuationBlockSpec | Not a complete P1 Spec or proof |

## Actual definitions

| Declaration | Frozen correspondence | Interpretation boundary |
|---|---|---|
| feasible | Constraints (7) | Exactly W+v=q, 0<=W<=min(q,H), v>=0 |
| continuationCost | Cost assumption, P1 proof | Scalar pW+gv |
| ell, piTail | Appendix A (23) | Piecewise real functions; integral/probability bridge open |
| finiteLoss, finiteTail | Appendix A (24) | Finite sums; mean_j=beta*A_j, not an endogenous law |
| finiteObjective | (11) with Appendix A (24) | Explicit finite objective, with U held fixed for u differentiation |
| finiteDensity | Appendix A (25) | Displayed open-support formula only |
| curvature | (14),(20) | Formula, not independently established differential identification |
| reserveNumerator | (21) | Formula, not independently established partial derivative |
| continuationBlockSpec | P1 (10) only | Full isolated continuation subclaim, not the complete P1 |

## Unproved source obligations

- P1 (11)--(16): general-law finiteness/continuity/convexity, minimizer-set
  existence and compact interval, expected-shortfall derivative, endpoint/interior
  optimality equivalences, uniqueness qualifications, variational and KKT bridges.
- P2 (17)--(21): U(r)=1+epsilon_E-r dependence, threshold partial derivatives,
  identification of Gu and Gr, differentiated FOC from a differentiable root,
  IFT branch existence, feasibility, global optimality and uniqueness locally in r.
- Appendix A (23): derivative at knots, global C1 and convexity, integral bridge.
- Finite implementation: actual J'' identity, convexity/existence and constrained
  corner characterization are open. Nonnegativity of a formula alone is insufficient.
- The scalar chain-equation premise is explicitly additional to the checked
  algebra. Its presence does not refute the paper or establish its branch.

## Source-only inventory

Named source rows: assumptions Environment and reserve treatment; Feasible
portfolio; Liquidity convention and eligibility; Direct-support restriction;
Incremental private costs; Analytical shock law; Finite-uniform implementation;
Local regularity and reserve variation; Proposition 1; Proposition 2.
The appendix formulas, KKT display, variational inequality, partials, continuation
helpers and numerical figures are support/context, not additional named results.

An independent source-only and source-to-code diagnostic found no mathematical
inconsistency. It did not inspect Lean's elaborated graph and is not an accepted
semantic-match judgment. The generated v11 review ledgers remain unissued.

## Semantic review disposition

All 31 existing closures were compared with the frozen source, their actual
Lean-emitted definitions/types, and the scope descriptions above. Independent
review records are in [partial_semantic_review.json](../audit/partial_semantic_review.json)
and [SEMANTIC_SCOPE_REVIEW.md](SEMANTIC_SCOPE_REVIEW.md). No mathematical target,
theorem hypothesis, proof, or source statement changed. No sign, max/min,
strictness, normalization or variable-interpretation mismatch was found in
the explicitly bounded claims.

**FULL below means only the isolated mathematical claim named in that row.**
It never denotes canonical machine closeout or all of a numbered proposition.

| Paper claim/reference | Lean declaration | Status | Added hypotheses / restrictions | Exact remaining gap |
|---|---|---|---|---|
| P1 (10), unique scalar continuation optimum | continuation_solution; continuationBlock | FULL | None beyond q,H>=0 and g>p>=0 | None within the scalar optimum; deriving q,H>=0 from feasible economic primitives is not a separate checked bridge |
| P1 proof of (11), scalar reduction | positive_part_reduction; optimized_cost_identity; deferral_threshold | FULL | H>=0 or chi*(U-u)>=0 supplied explicitly as source feasibility consequence | Expectations, integrability and ex-ante optimization remain outside these identities |
| Appendix A (23), endpoint values and slope-expression joins | ell_lower; ell_upper; pi_lower; pi_upper; uniform_joins | FULL | sigma>0 where needed; pi_lower is a broader scalar identity | Actual endpoint derivatives and global C1 are not consequences of this endpoint algebra alone |
| Appendix A (23), open-region first/second derivatives | ell_derivative_below/inside/above; ell_second_below/inside/above | FULL | Strict open-region inequalities; positive sigma for the source domain | No integral/probability interpretation or global join theorem |
| Appendix A (23), global derivative/C1/convexity | ell_derivative (off knots only) | PARTIAL | Both knots excluded from the checked first derivative | Derivative at both joins, continuity of derivative, global convexity |
| P1 (11)-(12), Appendix A (24), finite derivative/FOC companion | finiteLoss_derivative; finiteObjective_derivative; finite_foc_iff | PARTIAL | sigma_j>0; every component knot excluded, including zero-weight knots; U,r fixed for u differentiation (the standalone FOC iff needs none of these) | Global knot coverage; probability bridge; constrained optimality is not proved by stationarity algebra |
| P1 (14), Appendix A (25), formula nonnegativity | curvature_nonneg; finiteDensity_nonneg; finite_curvature_formula_nonneg | FULL | p>=0 and g>=p for curvature; nonnegative density inputs, or nonnegative weights and sigma_j>0 for the finite formulas; no weight normalization needed for formula sign | Identification with actual J'' and global convexity are OPEN |
| P2 (17), scalar rearrangement | implicit_response | FULL | Gu!=0 and assumed Gu*response+Gr=0 | Chain equation is algebraically equivalent to the quotient here; no independent differential/optimizer content is supplied |
| P2 conditional reserve sign | reserve_response_nonpos | PARTIAL | 0<=p<g, 0<=chi<1, phi>=chi, nonnegative density inputs, positive curvature, and assumed scalar chain equation | Actual Gu/Gr identification, U(r) dependence, differentiable branch and optimizer connection |
| Complete P1 (10)-(16) | Continuation and finite-function support only | PARTIAL | Current support restrictions remain explicit | General-law probability/regularity, convexity, minimizer existence, all corner/KKT/uniqueness clauses |
| P2 optimal-branch existence, feasibility and uniqueness | No existing declaration | OPEN | No substitute conclusion-bearing assumption added | IFT, branch construction and optimality/uniqueness locally in r |
| Complete P2 (17)-(21) | Scalar support only | PARTIAL | Differentiated equation remains a premise of scalar companions | Full probability/differential/IFT and optimal-branch bridges |

The premise in `continuation_unique` is a competitor cost comparison used to
prove coordinate equality, the standard uniqueness condition; it does not
assume coordinate equality. Conversely, `implicit_response` is deliberately
only a rearrangement of an algebraically equivalent equation. Claiming it proves
an optimizer derivative would implicitly assume all missing differential content.

## Strongest truthful Lean-slide sentence

Lean verifies the unique direct-support continuation optimum, positive-part
reduction, off-knot finite-uniform calculus, and reserve-response sign algebra
conditional on a differentiated FOC equation; the full probabilistic propositions
and optimal-branch existence remain open.
