# Current post-Marco paper-to-Lean correspondence

## Source and proof boundary

Provisional source: post-Marco paper commit `583e8b8cbb310d8b935d4b52ff85c304039a9677`. The final source pin remains UNSET in SOURCE_REFERENCE.json. The previous source comparison found both numbered propositions, proofs, six assumptions and seven governing equations unchanged in the preparation draft. No source, paper or economic parameter was changed during this pass.

There are TWO numbered economic propositions. Proposition 1 now has a complete transparent `proposition1Spec` and exact-type theorem `proposition1`. Proposition 2 has a full transparent `proposition2Spec` with NO full proof endpoint; its separately labelled `proposition2LocalSupportSpec` has the exact-type proof `proposition2LocalSupport`. The open `proposition2GlobalContinuationSpec` is a definition of the missing obligation, not an axiom or proof. The two component Specs do not increase the numbered-result denominator.

`status.json` registers the four Spec names and ONLY the two actual proof routes. Lean-native InterfaceValidation checks transparent proposition definitions, exact Spec/proof types and absence of full P2/global proof endpoints. Its manifest agrees with the status routes. The source statement map is generated with the supported statement-spec loader/map generator from the two complete verbatim source propositions; the open P2 proof route is explicitly empty. It remains provisional, without canonical acceptance or a final pin. No non-fast closure/receipt procedure was pursued.

The Spec includes every Proposition 1 conclusion under the original economic assumptions. It additionally exposes the proved integrability of the moment integrands and the full-real derivative of their natural mathematical extensions; these imply the source's finite cost and one-sided endpoint derivatives and impose no additional economic premise. Curvature explicitly asserts HasDerivAt as well as the derivative value, avoiding Lean's totalized-deriv ambiguity at zero curvature. Density-free positive-curvature uniqueness is assembled directly from the generic convexity proof; it does not acquire a PDF premise.

Historical `Gomez26EligibilityBuffers` and its 31 closures are not imported and receive no proof credit here.

## Numbered results

| Paper result | Status | Exact compiled scope | Remaining gap |
|---|---|---|---|
| Proposition 1, Private choice | PROVED: complete registered Spec and exact-type endpoint; final pin pending | Actual source instance; integrable moments and normalization; C1 objective; lender-inclusive derivative/FOC; existence; density curvature; sufficient convexity; convex endpoint/interior iff; strict endpoint uniqueness; stationary positive-curvature interior uniqueness under global convexity; nonconvex endpoint/interior necessity | No P1 mathematical clause gap identified. Final immutable pin and final source reconciliation/checks remain pending; no canonical acceptance or final submission is claimed. |
| Proposition 2, Conditional capacity response | PARTIAL | Actual economic joint C1; actual native IFT with invertibility derived from positive curvature; scalar derivative and exact sign/strictness at the base capacity; eventual strict interior local-minimum persistence | Explicit local stationary-branch uniqueness is not exported. Formula/sign at every nearby capacity, rather than just the base point, is not exported. Compact-gap continuation of a unique global minimum is OPEN. |

## Proposition 1 correspondence

All names below are in `Gomez26LiquidityBuffers`; `SourceInstance.` denotes the source-specialized namespace.

| Source reference / clause | Declaration(s) | Status and hypotheses |
|---|---|---|
| Assumptions 1–5; equations flow, moments, market, residual, fund, objective | `SourceInstance`, `SourceInstance.law`, `Dref`, `Xref`, `P`, `Q`, `ψ`, `ℓ`, `Δ`, `capacity`, `objective`, `marginal` | Source primitives only. Exactly two bank types, finite positive-weight aggregate states, conditional atomless probability laws with first moment, signed beta*A+eps, reference-profile schedules, positive deposits, NU. No optimizer or derivative is a record field. |
| Shifted law regularity | `SourceInstance.lawProb`, `lawNoAtoms`, `law_first_moment` | Derived from the actual conditional eps law by translation. No independence premise added. |
| Deposit normalization and amount derivatives | `shortfall_amount_normalization`, `surplus_amount_normalization`, `shortfall_amount_ratio`, `surplus_amount_ratio`, `shortfall_amount_derivative`, `surplus_amount_derivative` | Actual currency integrals; amount derivatives retain d, ratio derivatives do not. Positive d for ratios. |
| Moment definedness and identity | Integrability lemmas in `Moments`, `expected_moment_identity` | Actual expectations under finite first moment. No totalized nonintegrable expectation is used as evidence. |
| Eq. derivatives: L'=-piMinus and M'=piPlus | `shortfall_derivative_probability`, `surplus_moment_derivative`, `probability_partition` | Atomless probability law, actual dominated differentiation. |
| Continuous first differentiability | `surplus_probability_continuous`, `shortfall_probability_continuous`, `current_marginal_continuous`, `current_cost_C1`, `SourceInstance.objective_C1` | Atomlessness, finite first moment; probability continuity proved by dominated convergence. No density required for C1 cost. |
| Existence | `SourceInstance.objective_exists` | Actual objective on compact [0,U], U>0. |
| Lender-inclusive derivative and necessary FOC | `SourceInstance.objective_derivative`, `SourceInstance.interior_foc` | Actual a=i*psi+kappa*(1-coverage)*(1-psi), b=i*ell. Frozen schedules/laws. Interior global optimum implies local Fermat condition. |
| Eq. curvature | `density_interval`, `cumulative_derivative`, `shortfall_probability_density_derivative`, `surplus_probability_density_derivative`, `current_marginal_density_derivative`, `current_cost_density_curvature`, `SourceInstance.density_curvature` | Explicit probability-density representation, integrable nonnegative PDF, continuous at threshold. Actual CDF/FTC proof, not an assumed CDF derivative. Local statement; excludes discontinuous support joins. |
| Sufficient global convexity | `shortfall_convex`, `bank_decomposition`, `current_sufficient_convexity`, `SourceInstance.objective_convex` | Positive state weights and a>=b; convexity derived from expectation convexity. Coefficient dominance is sufficient, not necessary. |
| Convex corners and interior iff | `SourceInstance.lower_corner_iff`, `upper_corner_iff`, `interior_iff` | Assume actual global convexity on [0,U], not only the stronger sufficient coefficient restriction. Upper condition uses marginal at U. |
| Strict endpoint uniqueness | `SourceInstance.strict_lower_unique`, `SourceInstance.strict_upper_unique` | Global convexity and strict correct-endpoint derivative sign. |
| Positive-curvature interior uniqueness | `convex_positive_curvature_unique`, `SourceInstance.positive_curvature_unique` | Stationarity, interior point, actual global convexity and positive local curvature. No global strict convexity assumed. Proof rules out a convex flat segment of minima by the derivative tangent-cone inequalities. |
| Necessity without convexity | `lower_corner_necessary`, `upper_corner_necessary`, `SourceInstance.interior_foc` | Actual derivative and feasible tangent directions. Does not assert sufficiency in a nonconvex model. |

The paper's separate numerical negative-curvature example has no exact Lean counterexample endpoint. This is outside the numbered Proposition 1 conclusion and remains OPEN as supporting illustration.

## Proposition 2 correspondence

| Source reference / clause | Declaration(s) | Status / exact scope |
|---|---|---|
| Assumption 6: regular coverage regimes | `coverage_derivative`, `coverage_C1_at`, `deficitCoefficient_C1_at` | Actual piecewise coverage; zero-demand derivative zero, no division by zero; exclude F=Delta for Delta>0. Source application retains F>0. |
| Density continuity near threshold | `shortfall_probability_C1_at`, `surplus_probability_C1_at` | Explicit PDF representation with continuity in a neighborhood; no global density smoothness or smoothness across uniform support joins. |
| Joint C1 of economic G | `current_marginal_joint_C1` | Derived from actual coverage and actual probability functions. Joint C1 is not assumed in the specialized economic theorem. |
| Native IFT and invertibility | `scalar_stationary_branch`, `current_stationary_branch` | Invertibility derived from H>0 by explicit continuous-linear inverse; Mathlib's native IFT constructs branch before derivative conversion. No branch or differentiated-FOC identity is assumed. |
| Scalar response at regular base | `SourceInstance.capacity_branch` | Actual source laws/schedules. HasDerivAt branch (-N/H) at base F; positive H is exactly Assumption 6. |
| Weak sign and exact strictness at base | `SourceInstance.capacity_branch` | kappa>0 derived from kappa>i>=0; w>0; psi in [0,1] derived from source allocations. Derivative <0 iff some state has 0<F<Delta, psi<1 and positive deficit probability. No old R_D result used. |
| Persistence of strict interior local minima | `strict_local_minimum_from_curvature`, `current_strict_local_minimum`, `current_curvature_joint_continuousAt`, `SourceInstance.capacity_branch` | Eventually 0<branch<U and an explicit punctured buffer neighborhood has strictly higher objective at every other point. Positive curvature persists by actual continuity. This is stronger than merely weak IsLocalMin. |
| Formula/sign throughout a nearby capacity interval | No exported theorem | OPEN: obtain differentiability/eventual equation at each nearby capacity, differentiate that identity there, identify the two partials and retain positivity and regimes. Base-point formula alone is not that claim. |
| Local branch uniqueness | No exported economic endpoint | OPEN wrapper: Mathlib's IFT local uniqueness must be exported with an explicit common neighborhood and matched to the constructed source branch. |
| Unique-global continuation | No endpoint | OPEN: compact gap outside a strict-convex buffer neighborhood, uniform-in-capacity continuity, global-minimum localization, and identification/uniqueness of the local branch. The IFT does not prove this. No no-switch premise has been added. |

## Density witnesses and added hypotheses

`hμ` represents each conditional law as Lebesgue.withDensity(ofReal f); `hf` requires an integrable PDF; `hn` requires nonnegative PDF values. These are explicit representation witnesses, not consequences proved from the atomless-law fields of SourceInstance alone. Under the paper's ordinary meaning of a probability density, they describe the same class of distributions, not a stronger economic assumption. They must be supplied when invoking density-dependent clauses. No global continuity is imposed: local threshold continuity is sufficient. No claim about arbitrary atomless non-density laws having curvature is made.

Abstract helpers expose their own mathematical premises. Only source-specialized declarations receive current-model credit. No differentiable optimizer, derivative identity, no-switch certificate or conclusion-encoding hypothesis is used as a substitute for proof.

## Supporting results retained and deferred

| Paper reference | Compiled support | Remaining boundary |
|---|---|---|
| Interbank conservation / zero volumes | `interbank_conservation_all`, `SourceInstance.interbank_conservation`; `P_nonneg`, `Q_nonneg`, `ψ_bounds`, `Δ_nonneg` | Complete source-reference amount bridge for conservation; prescribed allocations, not voluntary participation or bilateral equilibrium. |
| Common capacity | `SourceInstance.deposits_pos`, `capacity_nonneg`; `coverage_bounds`, `fund_feasible`, `aggregate_state_coverage` | Actual state accounting; no fiscal/welfare/equilibrium result. |
| Relative incidence | `weighted_incidence`, `sourceRelative_defined`, `sourceRelative_zero_coverage` | Guarded denominator/Option support. Full sourceRelative invariance under all source guards remains OPEN. |
| Fixed-buffer scaling | `type_coverage_scaling`, `fixed_capacity_scaling`, `relative_scaling` | F*p_B handles zero-demand states; full population/expectation assembly and guarded cancellation remain OPEN. |
| Uniform formulas | Regional/combined `uniform_derivative`, reflection and finite-function objective results | Uniform probability/integral realization and join derivatives remain OPEN. |
| Global enumeration | `quadratic_stationary_difference`, `quadratic_convex_stationary_min`, `quadratic_flat` | Complete finite partition/enumeration with concave/affine pieces, support knots and all ties remains OPEN. |

No lower-priority infrastructure was expanded after closing the feasible high-priority connections. No sorry/admit/axiom placeholders stand in for the open results.


## Registered interface and assumption audit

| Registered target | Exact proof endpoint | Status | Source scope |
|---|---|---|---|
| proposition1Spec | proposition1 | PROVED | Entire numbered Proposition 1, including density-free convex uniqueness and nonconvex necessity. |
| proposition2Spec | NONE | PARTIAL / full target OPEN | Entire numbered Proposition 2, including neighborhood-wide derivative and conditional unique-global continuation. |
| proposition2LocalSupportSpec | proposition2LocalSupport | PROVED COMPONENT | Source economic IFT, base-point derivative/sign and persistence of strict local interior minima. Not full P2. |
| proposition2GlobalContinuationSpec | NONE | OPEN OBLIGATION | Source regularity plus unique global minimum at base imply a C1 branch of unique nearby global minima. No no-switch or optimizer-branch premise. |

| Antecedent | Actual Lean form / audit | Additional assumption? |
|---|---|---|
| Assumption 1 | SourceInstance positive type masses, deposits and U; rho>=0; reference normalization. | No. Exactly two types; the finite state specialization is in the paper. |
| Assumption 2 | eps_probability, eps_atomless, eps_first_moment; beta*A+eps mapped law. | No. No independence, symmetry or uniform-law assumption. |
| Assumption 3 | tau in [0,1], feasible uref; actual reference P,Q,psi,ell,Delta. | No. Prescribed allocations and zero-volume conventions remain source model assumptions, not market equilibrium. |
| Assumptions 4–5 | nu in [0,1], R>=0, rho>=0; r>=0,kappa>i>=0; immutable source instance across deviations/capacity scenarios. | No. No personal reserve usability is introduced. |
| Conditional density clause | ConditionalDensities explicitly binds a nonnegative, Lebesgue-integrable PDF to the actual law. | Explicit PDF representation witnesses; equivalent to the ordinary source density meaning. Not derived from atomlessness. No density premise on base C1/FOC/convex uniqueness. |
| Density continuity near threshold | DensityContinuousNear: point continuity and continuity at points of a neighborhood of -u. | No global continuity/smoothness added; uniform support joins are not silently covered. The point clause is redundant but explicit. |
| Assumption 6 | RegularCapacityPoint: F>0, interior buffer, actual marginal zero, kink exclusion, local density continuity, actual positive curvature. | No. Marginal/curvature identities are proved, and no differentiable branch/response formula is assumed. |
| Global continuation antecedent | Unique GLOBAL optimum at F0, plus original regularity. | Source antecedent only; no conclusion-encoding certificate. The Spec is unproved. |

The generated assumption review ledgers remain unaccepted scaffolds; no human or canonical review annotation was manufactured. The bounded context-isolated AI reading found no substantive mismatch and its zero-curvature expressiveness observation was repaired using an already-proved derivative. See docs/PACKAGING_REVIEW.md.
