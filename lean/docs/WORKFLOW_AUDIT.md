# Workflow audit and reproduction

The controlling course requirement is Issue #7:
https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7

## Required shape

Run AppliedModelingLib's `scripts/paper_contribution.py new`, then copy the
ENTIRE `papers/Gomez26EligibilityBuffers/` folder to this project's `lean/`,
respecting the generated `.gitignore`; never use `git add -f`.
The generated root import and additive Lake registration live outside that
folder in AppliedModelingLib; they are not standalone ai-project build files.
All generated template modules and review scaffolds are retained. The previous
lean README/plan is preserved as docs/PHASE2_FORMALIZATION_PLAN.md.

## Frozen inputs and tools

- Source: paper PDF at commit cf37d3f402c04a73c832cce41f559e32348f8941;
  exact PDF/TeX SHA-256 pins are in ../SOURCE_PIN.json. Source bytes cached
  outside both repositories; no private joint proposal is included.
- Engine: https://github.com/nikhgarg/AppliedModelingLib at
  2db7d108cd3a2cb10148974bb2a77856e7d87428.
- Lean: leanprover/lean4:v4.30.0-rc2, compiler commit
  3dc1a088b6d2d8eafe25a7cd7ec7b58d731bd7cc; Lake 5.0.0-src+3dc1a08.
- Mathlib: 5450b53e5ddc75d46418fabb605edbf36bd0beb6; its standard imports
  are used directly, with no separately ported external theorem.
- The unchanged engine lake-manifest.json pins all transitive packages;
  a byte-identical copy accompanies this document. No dependency update was run.
- Python for workflow: 3.14.4 on WSL Ubuntu. Python verification: 3.13 on Windows.

The existing Windows AppliedModelingLib checkout had unrelated changes, so a
separate detached temporary clone was used. No pull/merge or revision update
was performed. The initial Windows-filesystem scaffold attempt timed out;
the Linux-native retry used the same pinned Mathlib revision and succeeded.
The course's prescribed GPT-5.6 Sol/xhigh agent configuration was not reproduced
by this current Codex session; no claim about that configuration is made.

## Exact commands

From a Linux AppliedModelingLib checkout at the engine commit:

```sh
export LEAN_NUM_THREADS=1
export PYTHONPATH="$PWD"
python3 scripts/paper_contribution.py doctor
python3 scripts/paper_contribution.py new \
  https://github.com/carlosgomezp28/ai-project/blob/cf37d3f402c04a73c832cce41f559e32348f8941/paper/paper.pdf \
  --folder Gomez26EligibilityBuffers \
  --title 'Required Reserves, Public-Support Eligibility, and Voluntary Buffers' \
  --authors 'Carlos Gómez Puicán' \
  --version cf37d3f402c04a73c832cce41f559e32348f8941 --no-download
```

For reproduction, generate in a new destination then replace the generated
paper-folder contents with the complete ai-project/lean/ contents. Retain
the generated `papers/Gomez26EligibilityBuffers.lean` root:

```lean
import Gomez26EligibilityBuffers.ProofInterface
```

The generator adds this Lake entry, which must remain present:

```toml
[[lean_lib]]
name = "Gomez26EligibilityBuffers"
srcDir = "papers"
```

Required checks:

```sh
lake build +Gomez26EligibilityBuffers.BufferCore
lake build +Gomez26EligibilityBuffers.FiniteCompanion
lake build +Gomez26EligibilityBuffers
python3 scripts/paper_contribution.py check Gomez26EligibilityBuffers --fast
```

The course fast check builds the PaperInterface and checks paper import
isolation. It does not issue a full v11 source-present closeout. The separate
forced root build checks ProofInterface as well. All paper modules are checked
in one forced module transaction at final validation; the current dependency
modules were already separately forced after their final edits.

Do not call full Proposition 1 or 2 Lean-verified on this evidence. Probability and IFT bridges and complete proposition proofs remain mathematical
work beyond the current partial formalization. No public publication, PR or push was performed.

## Course-compliance cleanup

The course accepts honest partial formalization and requires the --fast check,
the generated-folder copy, and explicit reporting of every numbered result.
Non-fast/canonical acceptance, an AML registration commit, engine-ledger work,
an accepted obligation graph and a final closure receipt are not required for
this term-project deliverable and are not being pursued.

The successful Phase 3A run used
/var/tmp/ai-project-phase3a-aml/papers/Gomez26EligibilityBuffers/ at engine commit
2db7d108cd3a2cb10148974bb2a77856e7d87428, with paper cf37d3f pinned.
That source folder was subsequently modified during canonical-closeout work.
No untouched original snapshot was located. The user explicitly selected
cleanup of lean/ only, leaving the AML source folder unchanged and the
remaining mismatch disclosed. This cleaned folder is NOT asserted to be an
exact copy of the current AML folder or a byte-exact historical restoration.

The added pending map/bootstrap/helper, non-fast/planner/receipt diagnostics,
canonical repair reports and post-commit instructions were removed locally.
The source-map preparation scaffold was restored from the pinned generator's
empty template. All six Lean modules, genuine generated template artifacts,
31 theorem mappings and accepted bounded semantic review were retained.
Generic upstream workflow instructions in generated FORMALIZATION_NOTES.md
are preserved artifacts, not additional term-project requirements.

See COURSE_CLEANUP.json for byte-level changes and the remaining AML mismatch,
and COURSE_GIT_STATUS.txt for every current modified/untracked repository path.
