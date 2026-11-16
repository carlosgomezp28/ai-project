# Final Validation Report: Required Reserves, Public-Support Eligibility, and Voluntary Buffers

## 1. Human Verdict

Completion status: **Partially formalized**. The unique continuation optimum
and supporting finite-function algebra/calculus are checked; neither complete
numbered proposition has been formalized.

## 2. Course Validation Status

The course-required --fast check and Lean build pass; all 31 existing theorem
closures received accepted bounded independent semantic review. Honest partial
formalization is reported. Canonical/non-fast closeout is not a course
requirement and is no longer being pursued.

## 3. Source and Scope

The frozen individual course manuscript governs this work. The proposed V5.1
architecture is joint work by Carlos Gómez Puicán and Fabián Méndez Suárez,
supervised by Marco Ortiz. The course closure is Carlos's contribution. Open
architecture choices remain provisional; the interbank extension is outside scope.

## 4. Researcher Summary of Checked Results

| Source result | Disposition |
|---|---|
| Proposition 1 | Partial: unique continuation solution and scalar cost reduction; finite-objective first derivative off support knots. General probability, global convexity, existence and constrained optimality remain open. |
| Proposition 2 | Partial: quotient/sign algebra from an explicitly assumed differentiated FOC equation. Branch existence, differential identification and optimizer interpretation remain open. |
| Appendix A support | Endpoint value/slope expressions and derivatives on open regions checked. Integral interpretation, actual join derivatives, global C1/convexity remain open. |

## 5. Remaining Boundaries and Gaps

No expectation or probability bridge is established. All 31 theorem descriptions were checked against their actual bounded meanings; that semantic reading does not remove the following mathematical gaps. No global finite-objective
second-derivative identity, convexity, existence, corner or uniqueness theorem is
proved. Derivatives at uniform joins are open. Neither IFT nor existence of an
optimal differentiable reserve branch is proved.

## 6. Additional Assumptions Beyond Paper

The derivative companion excludes knots for every component, including zero
weights; the paper only excludes positive-weight knots in its regular finite
calculus. The reserve-response companion assumes the scalar differentiated FOC
equation and coefficient values instead of deriving them from an optimal branch.
These are explicit restrictions of the current partial proofs, not repairs to
the source. See docs/PAPER_TO_LEAN.md for each exact declaration.

## 7. Proof-Strategy Deviations

None identified for the proved subclaims. Missing source bridges are unfinished
proof obligations, not evidence of a false source proof.

## 8. Proof Tricks Worth Reusing

Separate continuation feasibility, an exact cost gap, optimality and uniqueness.
Use local equality on open support regions for calculus.

## 9. Generalizations, Conjectures, and Extensions

Some scalar identities allow arbitrary real coefficients. This is algebraic
generality and supplies no additional banking or probability result.

## 10. Source Clarifications and Exact Readings

Positive part is real max with zero. Uniform endpoint conventions and the factor
one minus eligibility are preserved. Endpoint polynomial slope identities do not
themselves establish derivatives of the piecewise function at the joins.

## 11. Paper Issues or Caveats

No genuine mathematical inconsistency found. The frozen paper remains unchanged;
its historical not-yet-formalized status text is intentionally not updated here.

## 12. Detailed Formalization Evidence

Every theorem, exact paper correspondence, premises and exclusions are in
[PAPER_TO_LEAN.md](docs/PAPER_TO_LEAN.md) and [THEOREMS.json](docs/THEOREMS.json).
All declarations use namespace Gomez26EligibilityBuffers. The exact source and
tool versions are recorded in SOURCE_PIN.json and docs/WORKFLOW_AUDIT.md.

## 13. Paper Assumption Provenance

Source-only discovery found eight governing assumptions and two numbered
propositions. Subclaim premises are visible in Lean. The generated assumption
review ledger remains unreviewed; no assumption-review certificate is claimed.

## 14. Displayed Formula Provenance

P1 (10)--(16), P2 (17)--(21), Appendix A (23)--(25), all at the frozen source
commit. The per-declaration mapping distinguishes differential identities from
algebra on a displayed formula. No October backing result is reclassified.

## 15. Library Lift Pass

Direct standard Mathlib calculus/order/tactic imports at the pinned revision.
No external Lean code port or new shared-library API. All proofs are paper-local.

## 16. DAG Audit

No completed semantic DAG audit. Implementation dependency order is BufferCore,
FiniteCompanion, MainTheorems, PaperInterface, ProofInterface, paper root;
Assumptions imports MainTheorems. This is not a source-coverage certificate.

## 17. Validation Checks

Required course command results are recorded in [VALIDATION.json](docs/VALIDATION.json).
The course fast check and forced root build must succeed before reporting this
implementation as checked. Axioms are queried from Lean for every proved theorem;
the output is in docs/AXIOM_CHECK.txt. No custom axioms or proof holes are allowed.

## 18. Paper Definitions Checked

Exact scalar feasibility/cost, positive-part formulas, uniform functions, finite
sums, finite objective and coefficient formulas are represented. Their probability
and institutional interpretations are not established by their Lean definitions.

## 19. Named Theorem Statements Checked

Zero of two complete numbered propositions proved. One complete isolated
continuation block has a transparent Spec and exact-type proof endpoint.
The other theorems are support companions, not additional source-result rows.

## 20. Paper-Facing Statement Validator Ledger

All 31 declarations received independent bounded source-to-Lean review using
Lean-emitted definitions/types; a separate adversarial reviewer checked the
scope. No mismatch was found in the explicitly bounded claims. See
audit/partial_semantic_review.json and docs/SEMANTIC_SCOPE_REVIEW.md.

All six generated audit JSON scaffolds and the final-agent-audit scaffold were reviewed. Library and defect-support rows are
not applicable to this import/claim surface. Source-proof-fidelity passages were
annotated within the bounded scopes. Canonical source-to-Spec and claim-atom
judgments remain unissued because the builder-issued graph/routes are absent.
See audit/scaffold_review.json. No human approval, semantic identity, match
receipt or acceptance graph was fabricated.

## 21. Numbered-Result Status and Folder Fidelity

| Frozen-paper numbered result | Course reporting status | Exact remaining gap |
|---|---|---|
| Proposition 1 | OPEN as a complete result; supporting subclaims proved | General probability/integrability bridge, global convexity, existence and constrained optimality; finite derivatives exclude every component knot. |
| Proposition 2 | OPEN as a complete result; scalar algebra proved under an assumed differentiated FOC equation | Identification of actual derivatives, IFT/differentiable optimizer branch, and optimizer interpretation. |

No complete numbered proposition is classified as proved or proved under an
added hypothesis. A proved algebraic companion is not the complete proposition.

The successful AML paper folder was later modified. No untouched historical
copy was located. The user authorized cleanup of lean/ only, with the source
folder mismatch disclosed. This folder is therefore not claimed to be an exact
current or historical generated-folder copy. See docs/COURSE_CLEANUP.json for
the exhaustive byte comparison. AML source and the frozen paper are unchanged.
The post-generation source-map/canonical repairs and obsolete post-commit
instructions were removed. Genuine generated scaffolds and accepted bounded
semantic-review evidence remain; they are not fabricated full-result verdicts.
