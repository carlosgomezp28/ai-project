# Handwritten derivations: historical and final model

The proposed V5.1 architecture is joint work by Carlos Gómez Puicán and
Fabián Méndez Suárez, supervised by Marco Ortiz. Explicitly open architecture
choices remain pending advisor validation. The direct-support restriction,
buffer optimization, proofs, verification, simulations, and formalization
effort are Carlos's individual AI-course contribution.

## Historical October material - preserved

`Hand_derivation.pdf` is the six-page historical derivation for the older
public-dollar-backing model: normalized shortfall derivative, the old
conditional FOC, and the conditional backing response. It has not been changed.
It does not verify the new asset-linked eligibility channel. In particular,
the October meaning of `phi` and the old `R_D` result do not belong to the
current direct-support core.

## Final-model material - still to be handwritten

**No new final-model handwritten scans have been supplied yet.** Carlos must
write and scan the following derivations, naming each assumption and checking
its domain where it is used:

1. `02-final-continuation.pdf`: assistance/deferral feasible set and unique solution.
2. `03-final-positive-part.pdf`: shortfall/eligibility substitution and objective.
3. `04-final-buffer-optimality.pdf`: existence, convexity, derivative, curvature,
   exact constrained conditions, and sufficient uniqueness.
4. `05-final-reserve-response.pdf`: local implicit-function argument and sign cases.
5. `06-final-uniform-mixture.pdf`: uniform integrals, support joins, and mixture formulas.

These filenames are planned, not existing deliverables. Follow
[FINAL_DERIVATION_GUIDE.md](FINAL_DERIVATION_GUIDE.md), which is a **typed guide
only, not a substitute for Carlos's handwritten derivations**. Keep the scans
aligned with the actual numbered assumptions and propositions in
`paper/paper.tex`. Do not label a proof complete if a substantive step remains
unexplained or if a regularity condition has only been presumed from a graph.
