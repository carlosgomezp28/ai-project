# Voluntary Liquidity Buffers under Finite Common Coverage

**Carlos Gómez Puicán · AI & Economic Modeling · Universidad del Pacífico · Track B: thesis model**

**Question and provenance.** How does finite common coverage affect an individual bank's optimal voluntary liquidity buffer under prescribed interbank allocation? The thesis architecture is joint work by **Carlos Gómez Puicán and Fabián Méndez Suárez**, supervised by **Marco Ortiz**, incorporating his benchmark note. Carlos's individual course contribution is the private buffer-choice closure, proofs, verification and constructed simulations. Prescribed participation and added course restrictions are maintained assumptions, not claims of advisor approval.

**Current model.** The post-Marco seven-equation benchmark covers (1) signed liquidity flows and buffer positions, (2) deficit/surplus amounts, (3) prescribed interbank allocations, (4) conservation, (5) finite common capacity and proportional rationing, (6) relative coverage incidence, and (7) individual buffer optimization. It has one currency interpreted as USD, two bank types, ex ante voluntary buffers, and NU required reserves (no personal reuse). Positive flows improve liquidity. Capacity is $F=\nu_F\rho D+R$. At a reference population profile, schedules are formed and then frozen for a measure-zero bank's deviation.

**Results and conditions.** With normalized deficit $L=D_k/d_k$, surplus $M=X_k/d_k$, $a=i\psi+\kappa(1-\varphi)(1-\psi)$, and $b=i\ell$, private cost is $J(u)=ru+\mathbb E[aL-bM]$. The interior FOC is $r=\mathbb E[a\pi^-+b\pi^+]$; lending income prevents automatic convexity. Proposition 1 gives sufficient convexity/corner conditions, a nonconvexity counterexample and exhaustive finite-uniform global optimization.

Proposition 2 gives $du^*/dF\le0$ locally for a **unique global interior optimum with positive curvature**, $F>0$, continuous local conditional densities, no coverage kink $F=\Delta(A)>0$, and fixed prices, shock laws, domain and population schedules $P,Q,\psi,\ell,\Delta$. The maintained environment has integrable atomless flows, finite aggregate states, a compact buffer interval, $r\ge0$, and $\kappa>i\ge0$. Strict negativity requires a positive-probability state with $0<F<\Delta$, $\psi<1$, and positive deficit probability. Corners/nonunique optima are excluded. This is a conditional best response, **not general equilibrium**; participation, aggregate consistency, calibration and welfare remain open.

| Current deliverable | Status |
|---|---|
| [Final paper](paper/paper.pdf) · [source](paper/paper.tex) | Current mathematical draft; 18 pages (12 body); full ordinary proofs of both propositions |
| [Final presentation](slides/final.pdf) · [source](slides/final.tex) | Built and inspected: 13 main slides, 9 backups, one divider |
| [Computational audit](code/POST_MARCO_AUDIT.md) · [outputs](code/output/post_marco/) | Constructed examples, not Peruvian estimates |
| [Lean record](lean/README.md) | 31 historical supporting closures pinned to November-4 paper `cf37d3f`; new post-Marco propositions open in Lean |
| [Hand evidence and checklist](hand/README.md) | Four genuine PDFs (8 pages) incorporated; explicit human unit verdict present; corrected corners, local IFT branch and zero-state accounting reconciled |
| [Raw AI collaboration log](prompts.md) | October record preserved; recovered later exchanges distinguish AI claims, student verdicts and outstanding verification |

**Student handwritten evidence:** [02](hand/02-post-marco-shortfall-surplus.pdf): signed flows and the −0.48 versus −0.30 unit verdict; [03](hand/03-post-marco-buffer-optimality.pdf): FOC/curvature and corrected corners; [04](hand/04-post-marco-capacity-response.pdf): conditional capacity calculation; [05](hand/05-post-marco-conservation-incidence.pdf): conservation and zero-deficit incidence. Original scans are unchanged; see the [page-level review](hand/README.md).

**Current figures:** [cost and optima](code/figures/post_marco/cost_and_optima.png), [capacity response](code/figures/post_marco/capacity_response.png), [exposure response](code/figures/post_marco/exposure_response.png).

**Reproduce.** From the repository root, install `python -m pip install -r code/requirements.txt`, then run `python code/verify.py`. It runs **28 October + 38 November-4 + 33 post-Marco = 99 checks** and regenerates outputs/figures in their separate model directories. Only 33 checks concern the current benchmark; finite tests and historical Lean support are not proofs of its new economic propositions. Build PDFs from their own directories with `latexmk -pdf paper.tex` or `latexmk -pdf final.tex`.

**Historical provenance:** [October proposal](proposal/proposal.pdf), [topic deck](slides/topic.pdf), [October manuscript](hand/Hand_derivation.pdf), [November-4 typed guide](hand/FINAL_DERIVATION_GUIDE.md), older code/outputs, and the paper at Git commit `cf37d3f` remain historical. The local `.private/` provenance source is excluded from Git. [Course requirements: Issue #7](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7).
