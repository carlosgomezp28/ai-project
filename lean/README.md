<!-- BEGIN GENERATED PAPER FOLDER README -->
# Required Reserves, Public-Support Eligibility, and Voluntary Buffers

| Field | Value |
|---|---|
| Final status | Partially formalized |
| Paper reference | Required Reserves, Public-Support Eligibility, and Voluntary Buffers by Carlos Gómez Puicán; Publication details not listed. |
| Lines of Code | 443 |

## Key Links

- Final validation report: [FINAL_VALIDATION_REPORT.md](FINAL_VALIDATION_REPORT.md)
- Dependency DAG: not tracked in this folder.
- Compact Lean interface: [PaperInterface.lean](PaperInterface.lean)
- Source/status JSON: [status.json](status.json).
- Additional documentation: [FORMALIZATION_NOTES.md](docs/FORMALIZATION_NOTES.md)
<!-- END GENERATED PAPER FOLDER README -->

## Course deliverable scope

31 theorem closures are checked. Complete Proposition 1 and Proposition 2
remain open; their proved supporting subclaims and explicit added restrictions
are listed in docs/PAPER_TO_LEAN.md and FINAL_VALIDATION_REPORT.md.

This is a locally cleaned partial-formalization folder. The AML source folder
was later modified; no untouched original snapshot was found. At the user's
direction, cleanup was confined to lean/, so byte-for-byte equality with that
AML folder is not claimed. See docs/COURSE_CLEANUP.json.

The required course check is paper_contribution.py check
Gomez26EligibilityBuffers --fast. Canonical closeout is not required and is
not being pursued. Generic generated workflow scaffolds are retained.
