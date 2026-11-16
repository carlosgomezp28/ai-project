# Reproduction and final-source migration

## Persistent workstreams

- Engine worktree: `/home/cjuni/AppliedModelingLib-liquidity`, branch `course/gomez26-liquidity`.
- Engine base: official `nikhgarg/AppliedModelingLib` commit `194edcc95df74806a39b961d10dedddc6e730cce` (fetched, not merged into the dirty original checkout).
- ai-project isolated branch: `lean-post-marco`, worktree `C:/Users/cjuni/Documents/Github/ai-project-lean-post-marco`.
- Preparation branch/files remain untouched in the original ai-project worktree.
- Lean `leanprover/lean4:v4.30.0-rc2`; Mathlib `5450b53e5ddc75d46418fabb605edbf36bd0beb6`. Every cached package revision was compared with the unmodified engine lockfile before use. No dependency source was edited.

## Initialization actually used

The supported facade is `scripts/paper_contribution.py new`, not a manual template copy. It registers the paper root and additive Lake target. The generated folder was new and nonconflicting.

```sh
export PATH=/home/cjuni/.elan/bin:/usr/local/bin:/usr/bin:/bin
export PYTHONPATH="$PWD"
export LEAN_NUM_THREADS=1
python3 scripts/paper_contribution.py new \
  https://github.com/carlosgomezp28/ai-project/blob/583e8b8cbb310d8b935d4b52ff85c304039a9677/paper/paper.pdf \
  --folder Gomez26LiquidityBuffers \
  --title 'Voluntary Liquidity Buffers under Finite Common Coverage' \
  --authors 'Carlos Gomez Puican' \
  --version 'PROVISIONAL-post-Marco-583e8b8-final-pin-pending' --no-download
```

Source bytes are cached outside Git; hashes and provisional status are in SOURCE_REFERENCE.json. The historical November-4 source pin is not used.

## Checks

From the engine worktree, with the environment above:

```sh
lake build +Gomez26LiquidityBuffers
lake env lean papers/Gomez26LiquidityBuffers/InterfaceValidation.lean
lake env lean papers/Gomez26LiquidityBuffers/ProofInventory.lean
python3 scripts/paper_contribution.py check Gomez26LiquidityBuffers --fast
```

ProofInventory uses Lean environment discovery and recursive axiom collection. It rejects sorryAx and any axiom other than propext, Classical.choice and Quot.sound. Its theorem count is a support-declaration count, never the count of economic propositions proved. The fast facade builds PaperInterface and performs paper import isolation; it does not prove source completeness or certify the current two economic propositions.

No non-fast canonical/planner/engine-registration/final-receipt procedure is pursued for the course deliverable. No human approval or source-semantic receipt is fabricated.

## Once the final immutable paper commit exists

1. Confirm the final PDF/TeX bytes and immutable GitHub URL. Compare every proposition, proof, assumption and governing equation to the provisional source; do not assume editorial equivalence if the mathematics changed.
2. Replace the PROVISIONAL source reference/version/cache hashes with that actual final reference. Keep a record that the preceding run was provisional.
3. Reconcile the two already registered full source-shaped Specs and the two P2 component/obligation Specs with the final source. Regenerate statement_spec.json/source map anchors using the supported init-spec + load_statement_spec/paper_statement_map_text mechanism; retain the empty full-P2 proof route and honest partial mapping unless actual proofs close it. Do not generate or add sorry placeholders. Any materially changed statements require proof/mapping updates.
4. Rerun the root build, native inventory/axiom check and official --fast command. Preserve their actual outputs and exact toolchain/engine pins.
5. Review source semantics and all added restrictions. Handwritten completion is separate evidence, not a Lean premise.
6. Copy the ENTIRE generated paper folder exactly into final `lean/` as required by Issue #7, respecting .gitignore. Preserve the historical folder separately through an explicitly authorized integration plan; do not overwrite it silently.
7. Update the paper appendix to one row per numbered economic result: proved, proved under specified added hypotheses, or open with exact blockers. Integrate by the course branch/PR workflow only when separately authorized.

The current parallel-workstream staging folder is not claimed to be the final lean/ deliverable and does not replace the historical folder in the preparation branch.


## Registered interface (packaging checkpoint)

- Full numbered targets: proposition1Spec (proved by proposition1); proposition2Spec (no full proof).
- P2 components: proposition2LocalSupportSpec (proved by proposition2LocalSupport); proposition2GlobalContinuationSpec (open, no theorem).
- Status routing is in review_surface.proposition_spec_proofs. Only the two genuine proof endpoints are paired. The numbered-result denominator remains TWO.
- InterfaceValidation is a Lean-native exact-type/definition check. It writes docs/INTERFACE_MANIFEST.json from the elaborated environment. This is a declaration manifest, not a semantic acceptance receipt. A simple metadata comparison checks its names/pairs against status.json; no Lean source parser supplies proof credit.
- ProofInventory imports ProofInterface, so it audits both registered endpoints and every imported proof recursively. It rejects sorryAx and nonstandard axioms.
- audit/statement_spec.json was created using the supported facade init-spec and filled with the two complete verbatim source proposition blocks and actual Lean-emitted Spec bodies. The supported new_paper.load_statement_spec and paper_statement_map_text generate audit/paper_statement_map.json. The unproved P2 proof route/template is cleared, not fabricated. The map remains a provisional non-accepted source-routing scaffold; no non-fast consumer is invoked.

## Eventual course folder copy

Authoritative generated directory: /home/cjuni/AppliedModelingLib-liquidity/papers/Gomez26LiquidityBuffers/.

The isolated ai-project staging copy is lean-current/Gomez26LiquidityBuffers/. It must match every generated file byte-for-byte, including .gitignore. It is NOT yet the course lean/ directory. Do not overlay the historical lean/ folder or change main without separate integration authorization. On integration, preserve historical work explicitly, then copy the complete generated folder contents into lean/ using the course's required structure; do not include the lean-current outer wrapper or engine-files staging aids in that copy.

The generated .gitignore protects local source caches, PDFs/archives and compilation intermediates. Its packaging reference SHA256 is fd9f67c80e311a15f7b601ef4f38d84825424d2d3e2beae257f1f27c49096c76. Verify it is preserved. Build/check commands run from AppliedModelingLib, whose additive Lake target/root import are already registered. The engine root wrapper and Lake-registration excerpt are retained outside the contribution under lean-current/engine-files/ for reconstruction; they are not extra generated course-folder files.

After the final paper commit exists: verify exact mathematical/source identity, update only to the actual immutable final SHA/PDF/TeX hashes, refresh source statement anchors and version, rerun full build, InterfaceValidation, recursive axiom audit and official --fast, update precise proved/partial/open mapping and validation logs, then perform the separately authorized exact course-folder copy. No canonical planner/engine registration/final closure receipt is required for this course deliverable.
