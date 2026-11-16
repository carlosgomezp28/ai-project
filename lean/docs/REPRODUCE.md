# Reproduce the final-source contribution

## Source/environment

- Immutable paper: [5b2959633962f46fc59d963b92f756e06da2ff00](https://github.com/carlosgomezp28/ai-project/blob/5b2959633962f46fc59d963b92f756e06da2ff00/paper/paper.pdf); exact source hashes in `../SOURCE_REFERENCE.json`.
- Official `nikhgarg/AppliedModelingLib` engine base: `194edcc95df74806a39b961d10dedddc6e730cce`.
- Actual engine worktree: `/home/cjuni/AppliedModelingLib-liquidity`, branch `course/gomez26-liquidity`; additive target registered using supported `paper_contribution.py new`.
- Lean `leanprover/lean4:v4.30.0-rc2`; Mathlib `5450b53e5ddc75d46418fabb605edbf36bd0beb6`. No dependency edits.
- Later course PDF changes concern formalization/evidence documentation only; two propositions/proofs, six assumptions and seven equations match the pinned source byte-for-byte.

## Commands actually run

From the registered AppliedModelingLib root:

```sh
export PATH=/home/cjuni/.elan/bin:/usr/local/bin:/usr/bin:/bin
export PYTHONPATH="$PWD"
export LEAN_NUM_THREADS=1
lake build +Gomez26LiquidityBuffers
lake env lean papers/Gomez26LiquidityBuffers/InterfaceValidation.lean
lake env lean papers/Gomez26LiquidityBuffers/ProofInventory.lean
python3 scripts/paper_contribution.py check Gomez26LiquidityBuffers --fast
```

All four exit 0. Actual outputs: `validation/gomez-final-build.txt`, `gomez-final-registration.txt`, `gomez-final-axioms.txt`, `gomez-final-fast.txt`, and `validation/final-check-results.json`. Registration: four transparent Specs, two exact proofs. Recursive axiom inventory: 168 supporting/generated constants, zero sorryAx/nonstandard axioms; permitted foundations are propext, Classical.choice and Quot.sound. Seven pre-existing cosmetic Lean linter warnings remain; no compiler errors.

## Fresh-engine registration

Check out the official engine base above, with its unmodified lockfile and required toolchain/cache. Initialize only if the contribution does not already exist:

```sh
python3 scripts/paper_contribution.py new \
  https://github.com/carlosgomezp28/ai-project/blob/5b2959633962f46fc59d963b92f756e06da2ff00/paper/paper.pdf \
  --folder Gomez26LiquidityBuffers \
  --title 'Voluntary Liquidity Buffers under Finite Common Coverage' \
  --authors 'Carlos Gomez Puican' \
  --version 'post-Marco-final-5b2959633962f46fc59d963b92f756e06da2ff00' --no-download
cp -a /path/to/ai-project/lean/. papers/Gomez26LiquidityBuffers/
```

Then run the four checks above. The supported initializer registers root import/Lake target; overlaying the entire course folder supplies actual proofs, replacing initializer skeletons. Reported PASS is from the actual registered worktree; this fresh-checkout recipe is documented, not a separate executed validation.

## Source mapping/copy

Final TeX/PDF bytes came from immutable Git objects. The supported init-spec template plus new_paper.load_statement_spec and paper_statement_map_text refreshed version, SHA256, exact source quotes and line anchors. Full P2's proof route was cleared because no full proof exists. Source/review scaffolds remain unaccepted; no human verdict or canonical receipt was fabricated.

To regenerate the map on another machine, obtain the exact pinned TeX, verify its hash in SOURCE_REFERENCE.json, update source_artifact_path in audit/statement_spec.json to that local file, then use the supported loader/map generator. Clear the unproved full-P2 proof route; do not generate theorem skeletons. The recorded external cache path is machine-local. Official --fast does not require that cache.

Authoritative generated directory: papers/Gomez26LiquidityBuffers/. Its complete contents reside directly in ai-project lean/. Preserve .gitignore exactly and stage normally with git add lean/; never force-add ignored source caches/builds. PACKAGING_MANIFEST.json records all deliverable hashes excluding itself. Historical November-4 files live outside lean/ in archive/lean-november4/.

## Scope

P1 is proved under source assumptions, with explicit nonnegative integrable PDF representations/local threshold continuity for density-dependent clauses; these do not follow from arbitrary atomlessness. P2 remains PARTIAL: base-point IFT response and strict local-minimum persistence proved; neighborhood-wide response, exported local uniqueness and compact-gap global continuation OPEN. See PAPER_TO_LEAN.md. Handwritten evidence is not a Lean premise. No non-fast planner/engine-ledger/final receipt is required or claimed. Earlier checkpoint documents/logs retain historical provisional status.
