# Public Dollar Backing and Voluntary Bank Buffers

**Carlos Gómez Puicán · AI & Economic Modeling · Universidad del Pacífico · Track B: thesis model**

**Provenance and contribution.** The baseline is joint IE1 work by Carlos Gómez Puicán and Fabián Méndez Suárez, supervised by Marco Ortiz, used with Fabián's permission. It already anticipates endogenous buffers and a future fixed point. This individual project completes the private optimization closure, introduces reduced-form private costs, derives the FOC, and characterizes a conditional backing response.

**Question and inherited model.** How does public dollar backing affect a representative bank's voluntary dollar buffer, conditional on aggregate liquidity conditions? The static framework has two classes $k\in\{L,S\}$, soles/dollars $c\in\{s,u\}$, fixed deposit composition, uniform idiosyncratic shocks, interbank coverage, and finite dollar capacity. In NU required reserves back a collective fund; in U they are usable by the bank and their principal is not counted again in the fund.

**Individual problem.** Write $v_k^c:=u_k^c$ in the joint IE1 notation. Both $v_k^c$ and $\rho^c$ are ratios to deposits. Inherited $S_k^{c-}$ is an expected deficit amount; define $L_k^c(v,A):=S_k^{c-}(v,A)/d_k^c$. Conditional on coverage schedules, minimize cost per unit of deposits:

$$
\min_{0\le v_k^c\le\bar v_k^c}V_k^c(v_k^c)
=\kappa_k^c v_k^c+\mathbb E_{A^c}[h_k^c(A^c)L_k^c(v_k^c,A^c)],
$$
$$
h_k^c(A)=\Psi_k^{-,c}(A)q_I^c+[1-\Psi_k^{-,c}(A)]
\{\phi^c(A)q_F^c+[1-\phi^c(A)]\ell^c\}.
$$

Here $\phi^u$ is dollar public coverage and $\phi^s=1$ is the elastic soles benchmark; $\kappa$ is marginal buffer cost and $q_I,q_F,\ell$ are unit costs of interbank funding, public funding, and uncovered deficits. The **new** nonnegative-credit restriction on the inherited balance sheet gives $\bar v_k^c=1+E_k^c/d_k^c-\rho^c$, maintained positive. Since $L_v=-\pi_k^{c-}$, the interior FOC is

$$
\kappa_k^c=\mathbb E_{A^c}[h_k^c(A^c)\pi_k^{c-}(v_k^{c,*},A^c)].
$$

**Candidate result and limits.** $dv_k^{u,*}/dR_D<0$ is a conditional individual best response at a regular interior optimum with positive curvature, $\ell^u>q_F^u$, and a positive-probability state combining positive deficit probability, incomplete interbank coverage, and rationed public coverage responsive to $R_D$. State-dependent $P^u(A),Q^u(A),\Delta^u(A)$ remain fixed across backing scenarios, as do other primitives and the shock law. This is not a general-equilibrium theorem; corners or saturated coverage can remove the strict effect. Public-support/liquidity-incentive mechanisms already exist; external novelty remains uncertain.

| Component | Current status |
|---|---|
| [Proposal](proposal/proposal.pdf) | Revised topic document; source in proposal/ |
| Topic/final slides; final paper | Template material; pending revision |
| Symbolic verification | 28 checks manually passed before this revision; conditional algebra, not equilibrium existence |
| [Hand derivation](hand/Hand_derivation.pdf) | Present: normalized-deficit derivative, FOC, conditional backing sign |
| Literature positioning | Initial comparison; detailed result/version review in progress |
| Aggregate fixed point | In progress; not established by the conditional result |
| Lean and AI log | Pending; current placeholders |

Verification: <code>python3 code/verify.py</code>. [Operative requirements: Issue #7](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/7).
