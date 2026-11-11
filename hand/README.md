# Handwritten evidence: final post-Marco reconciliation

The thesis architecture is joint work by **Carlos Gómez Puicán and Fabián
Méndez Suárez**, supervised by **Marco Ortiz**, incorporating his benchmark
note. Carlos's individual course contribution is the buffer-choice closure,
proofs, verification and constructed simulations.

## Assessment: PASS for the requested reconciliation

All **eight pages** of the four updated student PDFs were visually reinspected
against the current [paper](../paper/paper.tex), [computational audit](../code/POST_MARCO_AUDIT.md)
and implementation. The student supplied the corrections; the AI did not alter
the scans. The former upper-corner error, local-IFT omission and incidence
notation ambiguity are resolved.

| Student document | Demonstrated work and final assessment |
|---|---|
| [02-post-marco-shortfall-surplus.pdf](02-post-marco-shortfall-surplus.pdf) (2 pp.) | Correct signed-flow definitions, shortfall/surplus signs, atomless/Lipschitz differentiation and deposit normalization. Page 2 explicitly records the human verdict: at d=1.6 and deficit probability 0.30, the normalized derivative is **−0.30**, while the amount derivative is **−0.48**. |
| [03-post-marco-buffer-optimality.pdf](03-post-marco-buffer-optimality.pdf) (2 pp.) | Correct lender-inclusive FOC and density-weighted curvature. **Page 2 now uses J'(u_bar) <= 0 under global convexity**, alongside the lower-corner test J'(0) >= 0. Uniqueness is not presumed; global candidate comparisons are distinguished from an interior FOC. |
| [04-post-marco-capacity-response.pdf](04-post-marco-capacity-response.pdf) (2 pp.) | Page 1 obtains GF >= 0 generally. **Page 2 establishes a local differentiable branch by the IFT from G(u0,F0)=0, Gu(u0,F0)>0 and local C1 regularity before differentiating it.** Strict positivity of GF requires positive rationed deficit exposure. Fixed schedules, shock law/domain, interiority, curvature and coverage-kink restrictions remain explicit. |
| [05-post-marco-conservation-incidence.pdf](05-post-marco-conservation-incidence.pdf) (2 pp.) | Correct interbank conservation and zero volumes, finite-fund bounds and deposit-weighted mean-one index. **Page 2 explicitly defines B={A: Delta(A)>0} and pB=Pr(Delta>0)**. When every positive-demand state is rationed, Cbar(F)=F pB; zero-demand states contribute zero. Fixed-buffer capacity scaling cancels in the relative index. |

## Scope retained for the defense

- Amount derivatives retain the deposit factor; ratios do not. Positive flows
  improve liquidity; they are not always-positive withdrawals.
- The FOC includes lending income. Convex corner sufficiency requires global
  convexity. A negative state coefficient gives **strictly negative curvature
  only where the conditional density at the threshold is positive**; otherwise
  its curvature contribution may be zero.
- The IFT constructs a local stationary branch. Positive curvature gives local
  minima; continuation of a unique global best response is separately proved
  in the paper. Neither the local calculation nor the scans establish general
  equilibrium.
- Capacity derivatives hold population schedules and other stated primitives
  fixed. Coverage/support kinks, corners and nonunique choices are outside
  the implemented regular two-sided formula.
- Expectations divided by Delta are restricted to positive-demand states.
  The relative index requires Cbar>0. Fixed-buffer incidence is not welfare
  or endogenous-buffer incidence.
- Full existence, finite-uniform global enumeration and global continuation
  remain proved in the typed paper. The scans demonstrate the stated core
  derivations; they are not a claim of complete independent formalization.

No further student erratum is required for the requested corrections.
The eight pages remain unchanged during this reconciliation. Slide 12 retains
the authentic direct PDF crop of document 02, page 2; its unit check is still
readable and correct.

The student reports correcting the evidence, and the updated pages directly
support that report. The human unit verdict is visible in the writing. This
does not imply that the student independently executed all 99 program checks
or that any unrecorded human–AI disagreement occurred.

## Historical evidence and proof status

- [Hand_derivation.pdf](Hand_derivation.pdf) is the six-page **October**
  public-dollar-backing manuscript, preserved unchanged.
- [FINAL_DERIVATION_GUIDE.md](FINAL_DERIVATION_GUIDE.md) is the **typed historical
  November-4 asset-eligibility/deferral guide** for paper commit cf37d3f.

The current four files replace the old plan for a combined
hand/Post_marco_derivations.pdf; no combined PDF is claimed to exist.
Only 33 of the 99 verification checks concern the current model. The 31
historical Lean closures do not prove the post-Marco economic propositions,
which remain open in Lean. A current-paper formalization mapping/check is
still a separate final-repository task.
