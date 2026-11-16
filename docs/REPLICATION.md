# Replication and research navigation

[Back to the research overview](../README.md)

## Start with the current model

| Material | Location | Scope |
|---|---|---|
| Research paper | [PDF](../paper/paper.pdf) · [LaTeX](../paper/paper.tex) · [bibliography](../paper/references.bib) | Current post-Marco final paper, with final-source Lean scope documented in Appendix C. |
| Final presentation | [PDF](../slides/final.pdf) · [LaTeX](../slides/final.tex) | Delivered November 13 presentation: 13 main slides, 9 backups and one divider. |
| Economic implementation | [post_marco_model.py](../code/post_marco_model.py) | Signed-flow moments, prescribed allocations, common capacity and individual optimization. |
| Simulation construction | [simulate_post_marco.py](../code/simulate_post_marco.py) | Deterministic constructed experiments and plotting functions, called by verification. |
| Verification | [verify.py](../code/verify.py) · [current checks](../code/verify_post_marco.py) | Single executable entry point; 99 historical-plus-current checks, including 33 post-Marco checks. |
| Parameters and results | [parameters.json](../code/output/post_marco/parameters.json) · [CSV/JSON directory](../code/output/post_marco/) | Constructed parameters and exported observations, not empirical Peruvian estimates. |
| Current figures | [post_marco/](../code/figures/post_marco/) | The three verified previews used in the README and final presentation. |
| Human evidence | [hand/README.md](../hand/README.md) | Genuine scans 02–09: 23 pages, with full final-paper derivations and the 07 p. 3 qualification to unchanged 03 p. 2. |
| AI collaboration | [prompts.md](../prompts.md) | Raw available exchanges, documented student checks and recorded evidence gaps. |

## Reproduce the Python results

Run commands from the repository root. Use **Python 3.12** to match the [CI configuration](../.github/workflows/build.yml). Dependencies are listed in [code/requirements.txt](../code/requirements.txt); their versions are not pinned, so this is not a locked environment.

### Windows PowerShell

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r code/requirements.txt
.\.venv\Scripts\python.exe code/verify.py
```

### macOS or Linux

```sh
python3 -m venv .venv
.venv/bin/python -m pip install -r code/requirements.txt
.venv/bin/python code/verify.py
```

The entry point runs **28 October + 38 November-4 + 33 post-Marco = 99 checks**. It also regenerates model outputs, reports and figures, including historical outputs. Run it in a working copy where those writes are intended. It is not a read-only audit command.

The current results are under [code/output/post_marco/](../code/output/post_marco/) and [code/figures/post_marco/](../code/figures/post_marco/). The [current verification report](../code/output/post_marco/verification.json) records check labels and numerical diagnostics. Deterministic conditional moments, integration comparisons and finite candidate/grid checks support the numerical examples; the check count is not a count of mathematical proofs. No primary Monte Carlo calculation or empirical calibration is claimed.

For implementation assumptions, experiment design and interpretation, read [POST_MARCO_AUDIT.md](../code/POST_MARCO_AUDIT.md) alongside the current paper. The three README figures illustrate buffer choice, a capacity sweep and an individual exposure sweep. The baseline types differ in both exposure and access; their level difference does not isolate either effect. The exposure experiment varies one individual's exposure with the population schedules fixed.

## Build the current PDFs

With a LaTeX installation providing `latexmk` and the packages used by the sources:

```sh
cd paper
latexmk -pdf paper.tex
cd ../slides
latexmk -pdf final.tex
cd ..
```

These commands write PDFs and compilation intermediates. CI also compiles the historical proposal and topic presentation. The final paper PDF includes updated formalization documentation; delivered slides and all economic statements are preserved.

## Economic conditions and proof scope

The current model is the post-Marco seven-equation benchmark: one USD currency, two bank types, ex ante voluntary buffers, signed liquidity flows, prescribed interbank borrowing/lending, finite common capacity and NU reserves. Positive flows improve liquidity. Conditional laws are atomless with finite first moments; aggregate states are finite with positive probabilities. Buffers lie in a fixed compact interval, and costs satisfy `r >= 0` and `kappa > i >= 0`.

Proposition 1 establishes the moment/objective derivatives, lender-inclusive FOC, existence, conditional curvature and the convex corner/uniqueness results. First-order conditions alone do not identify global minima in nonconvex cases. The paper's counterexample and finite-uniform global enumeration are supporting analysis, not additional numbered propositions.

For Proposition 2, the base capacity is positive, the stationary buffer is interior and curvature is positive. Conditional densities are continuous near the liquidity threshold. Every positive-demand state avoids a coverage kink. Prices, conditional laws, probabilities, the feasible domain and reference schedules remain fixed across the capacity comparison. The IFT constructs a branch of strict local minima before it is differentiated.

Along that regular branch, the capacity response is weakly negative. Strict negativity requires a positive-probability state jointly exhibiting rationing, incomplete interbank coverage and positive individual deficit probability. Otherwise the response is zero. Continuation as a unique global best response additionally requires a unique global minimizer at the base. The regular two-sided formula does not cover zero capacity, coverage kinks, corners or nonunique optima.

These are atomistic conditional responses. The displayed buffers are not fed back into reference population schedules. Aggregate consistency, endogenous participation/search/bargaining, welfare and calibration remain outside the current contribution. Prescribed allocations and course restrictions are maintained assumptions, not an advisor-approval record.

### Lean: integrated current-model contribution

The complete generated `papers/Gomez26LiquidityBuffers/` contribution is copied directly into [lean/](../lean/README.md), including the generated `.gitignore`. Its immutable mathematical source is [paper commit 5b2959633962f46fc59d963b92f756e06da2ff00](https://github.com/carlosgomezp28/ai-project/blob/5b2959633962f46fc59d963b92f756e06da2ff00/paper/paper.pdf). The course paper's later changes concern formalization/evidence documentation only.

- **Proposition 1 PROVED:** `proposition1 : proposition1Spec`, under the original economic assumptions. Density-dependent clauses require explicit nonnegative integrable PDF representations and local continuity; these are not derived from atomlessness.
- **Proposition 2 PARTIAL:** `proposition2LocalSupport : proposition2LocalSupportSpec` proves the economic IFT, base-point derivative/sign and persistence of strict interior local minima. The full `proposition2Spec` has no proof. The global-continuation compact-gap/localization argument, neighborhood-wide derivative formula and exported local branch uniqueness remain open.
- Final-source full compilation, native interface validation, recursive axiom audit and official `--fast` check pass. This is honest partial course formalization, not canonical source-semantic acceptance.

Follow [Lean reproduction](../lean/docs/REPRODUCE.md) from the official AppliedModelingLib root, with the recorded Lean/Mathlib/engine pins. This folder is an engine contribution, not a standalone Lake project. See [correspondence and hypotheses](../lean/docs/PAPER_TO_LEAN.md), [source reference](../lean/SOURCE_REFERENCE.json) and [actual validation outputs](../lean/docs/validation/).

The historical November-4 contribution, including its 31 supporting closures, is preserved byte-for-byte at [archive/lean-november4/](../archive/lean-november4/README.md). Its old paths and status text are historical records, not current reproduction instructions. Handwritten, numerical and Lean verification remain distinct evidence.

## Preserved historical milestones

| Stage | Preserved material | How to read it |
|---|---|---|
| October topic milestone | [Proposal](../proposal/proposal.pdf) · [topic slides](../slides/topic.pdf) · [original handwritten derivation](../hand/Hand_derivation.pdf) | Earlier joint-baseline public-dollar-backing model; historical context, not the current benchmark. |
| November-4 course model | [buffer_model.py](../code/buffer_model.py) · [simulate_buffers.py](../code/simulate_buffers.py) · [derivation guide](../hand/FINAL_DERIVATION_GUIDE.md) · [Lean archive](../archive/lean-november4/README.md) | Direct-support eligibility/deferral model; historical paper reference `cf37d3f`. Its 38 checks and Lean scope remain distinct. |
| Current post-Marco model | [Paper](../paper/paper.pdf) · [final slides](../slides/final.pdf) · [implementation audit](../code/POST_MARCO_AUDIT.md) | Current analytical and computational course contribution. |

Paths and historical files are preserved. No historical model should be silently reinterpreted as the current model. The local `.private/` provenance source is excluded from Git and is not a replication input.

The broader thesis architecture is joint work by Carlos Gómez Puicán and Fabián Méndez Suárez under Marco Ortiz. The individual course closure, proofs, verification and simulations are Carlos's contribution. See [Issue #7](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7) for course requirements.
