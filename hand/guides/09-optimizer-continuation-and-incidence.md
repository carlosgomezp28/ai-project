# 09 - Local/global optimizer continuation and incidence cancellation

**Typed guide only.** This fills proof details for the student to verify and handwrite. It is not a handwritten appendix, advisor approval or completed student verdict. It preserves the current atomistic benchmark and the provenance stated in the paper.

**Paper references:** Assumption 6 (`ass:regular`), Section 5, Proposition 2 (`prop:capacity`), equation (14) (`eq:capacityderivative`); Section 3, equations (3)-(6); Section 7, equation (15) (`eq:fixedincidence`); Appendix D's bounded evidence assessment. Guides 06-08 supply moment derivatives, optimization and uniform-support details.

## 1. A common neighborhood with fixed coverage regimes

**Target:** justify regularity before applying the IFT.

Use Assumptions 1-5 and the additional local conditions in Assumption 6. At (u_0,F_0), F_0 > 0, 0 < u_0 < ubar, G(u_0,F_0) = J_u(u_0,F_0) = 0, and G_u(u_0,F_0) = J_uu(u_0,F_0) > 0. Every conditional density is continuous near -u_0. Conditional laws, costs, probabilities, schedules psi_j, ell_j, Delta_j and domain are fixed.

For each Delta_j > 0 require F_0 != Delta_j. There are only finitely many states. Choose a positive capacity radius smaller than F_0 and than every positive distance |F_0-Delta_j| (for example, half the minimum of this finite set). Then F remains positive and every state's rationed/saturated status stays fixed. If no Delta_j > 0, the only restriction is positivity of F; in that case G_F = 0, though the other assumptions still have to hold.

Choose an open u-neighborhood inside (0,ubar) small enough that each density is continuous near all thresholds -u in it. Finiteness permits a common neighborhood. In the uniform specialization this excludes support knots whenever they would destroy the needed regularity.

For Delta_j > 0,

$$
\varphi_j(F)=\begin{cases}F/\Delta_j,&0<F<\Delta_j,\\1,&F>\Delta_j,\end{cases}
\quad
\varphi_{j,F}=\begin{cases}1/\Delta_j,&0<F<\Delta_j,\\0,&F>\Delta_j.\end{cases}
$$

For Delta_j = 0, the benchmark defines varphi_j(F) = 0 identically and its derivative is zero. Define the derivative contribution by this case; never evaluate 0/0 inside an indicator formula. At F = Delta_j > 0 the one-sided coverage derivatives differ and this neighborhood construction is unavailable.

## 2. Establish G in C^1 and compute its partial derivatives

**Target:** the hypotheses actually used in Proposition 2's IFT.

By guide 06, pi^-_j is continuously differentiable locally, with derivative -f_j(-u), and pi^+_j has derivative f_j(-u). The locally affine/constant varphi_j makes a_j(F) continuously differentiable; b_j is constant. Consequently the finite sum

$$
G(u,F)=r-\sum_jw_j[a_j(F)\pi^-_j(u)+b_j\pi^+_j(u)]
$$

is C^1 jointly in (u,F). In this rectangle,

$$
G_u=\sum_jw_j[a_j(F)-b_j]f_j(-u)=J_{uu},
$$
$$
a_{j,F}=-\kappa(1-\psi_j)\varphi_{j,F},
\quad
G_F=-\sum_jw_j a_{j,F}\pi^-_j
=\kappa\sum_{\{j:0<F<\Delta_j\}}
\frac{w_j(1-\psi_j)\pi^-_j(u)}{\Delta_j}.
$$

The last sum is restricted to strictly positive Delta_j. There is no singular summand from a zero-demand state. By kappa > i >= 0, kappa is positive; w_j > 0, 0 <= psi_j <= 1 and pi^-_j >= 0. Hence G_F >= 0.

## 3. Construct the branch, then differentiate

**Target:** local stationary branch and equation (14).

The implicit function theorem applies because G is C^1 on an open rectangle, G(u_0,F_0) = 0 and the scalar derivative G_u(u_0,F_0) is nonzero. It produces an open interval around F_0 and a unique local C^1 function u(F), with u(F_0) = u_0 and G(u(F),F) = 0. This construction precedes differentiation; assuming the differentiated FOC would not establish the theorem.

Since u_0 is strictly interior and u(F) is continuous, shrink the interval so 0 < u(F) < ubar. Continuity of G_u and G_u(u_0,F_0) > 0 permit a smaller rectangle where G_u remains strictly positive. At each point on the branch the first derivative is zero and second derivative positive, so the second-order sufficient condition makes it a strict local minimum. No global conclusion has yet been proved.

Apply the chain rule to the constructed identity:

$$
0=\frac{d}{dF}G(u(F),F)=G_u(u(F),F)u_F+G_F(u(F),F).
$$

Division is justified by the strictly positive denominator:

$$
u_F=-G_F/G_u
=-\frac{\kappa\sum_{0<F<\Delta_j}w_j(1-\psi_j)\pi^-_j(u)/\Delta_j}
{J_{uu}(u,F)}\le0.
$$

In a finite sum of nonnegative terms, positivity is equivalent to at least one strictly positive term. Since kappa, w_j and the included Delta_j are positive, u_F < 0 iff some included state also has psi_j < 1 and pi^-_j(u) > 0. If none does, u_F = 0. Positive probability of a state alone does not establish positive deficit exposure in that state.

## 4. Prove local continuation of the unique global optimum

**Target:** the last substantive assertion of Proposition 2. This is not supplied by the IFT alone.

Add the paper's hypothesis that u_0 is the unique global minimizer at F_0. Do not replace the proof with an assumed “no global minimum switch.” The feasible compact interval remains fixed across F.

Choose eta > 0 such that K = [u_0-eta,u_0+eta] lies strictly inside (0,ubar), the branch lies in its interior for nearby F, and J_uu > 0 on K in a small closed capacity neighborhood. This follows by continuity of G_u at the base point, choosing K small enough, and then continuity of the branch. On K the derivative is strictly increasing, so J is strictly convex for every such F.

Let E = [0,ubar] minus the interior of K. This is compact and excludes u_0. By continuity, J(v,F_0)-J(u_0,F_0) attains a minimum on E. Uniqueness of u_0 makes that minimum a strictly positive number delta:

$$
J(v,F_0)\ge J(u_0,F_0)+\delta\quad(v\in E),\qquad\delta>0.
$$

Joint continuity of J on the full feasible interval times a small closed capacity interval gives uniform continuity. This is valid even if J lacks second derivatives outside K: the moments are continuous, and coverage is continuous in F, including saturated states and the constant zero-demand convention. Shrink the capacity interval so

$$
\sup_{v\in[0,\bar u]}|J(v,F)-J(v,F_0)|<\delta/3.
$$

Then for every v in E,

$$
J(v,F)\ge J(u_0,F_0)+2\delta/3
>J(u_0,F_0)+\delta/3>J(u_0,F).
$$

The last inequality uses the same uniform bound (and may be replaced by <= if a non-strict bound was chosen; the preceding strict separation persists). Therefore no global minimizer at F lies in E. A minimizer exists by compactness, so it lies inside K. The stationary branch is the unique minimizer on K by strict convexity; hence that global minimizer equals u(F), uniquely. This establishes local continuation without assuming global convexity or aggregate consistency.

Ties at F_0 remove the positive-gap argument. Corners remove the interior IFT setup. Coverage kinks and relevant support knots remove the asserted C^1 neighborhood. The proposition does not supply a two-sided formula in those cases.

## 5. Backing versus capacity and aggregate feedback

**Target:** the scope immediately around Proposition 2.

F = nu_F rho D + R, so dF/dR = 1 only with nu_F, rho and D fixed. The chain rule then gives du/dR = du/dF along the same conditional branch. At the policy boundary R = 0, only feasible one-sided backing changes are economically admissible, even if the mathematical capacity neighborhood is two-sided. A change in rho or population buffers can change other primitives and is not covered by this identity.

For a positive-mass population adjustment, psi, ell and Delta generally vary. Their omitted derivatives would enter G_F or the relevant total derivative. Neither the sign above nor the IFT proves an equilibrium fixed point, existence of voluntary participation or welfare effects.

## 6. Conservation, including all zero-volume cases

**Target:** equations (3)-(5), completing manuscript 05's bookkeeping.

Fix a feasible reference population profile. Deficit/surplus amounts D_kj,X_kj are nonnegative. With mu_k > 0 and tau_k in [0,1], P_j = sum_k mu_k tau_k X_kj and Q_j = sum_k mu_k tau_k D_kj are nonnegative.

When P_j,Q_j > 0, substitute the prescribed fractions, which share the same minimum factor across types:

$$
\sum_k\mu_k\psi_{kj}D_{kj}
=\min(1,P_j/Q_j)\sum_k\mu_k\tau_kD_{kj}
=\min(1,P_j/Q_j)Q_j=\min(P_j,Q_j),
$$
$$
\sum_k\mu_k\ell_{kj}X_{kj}
=\min(1,Q_j/P_j)P_j=\min(P_j,Q_j).
$$

The final equalities follow by splitting P_j <= Q_j and P_j > Q_j. If P_j = 0 or Q_j = 0, the benchmark sets both fractions to zero for every type. Both traded totals and min(P_j,Q_j) are zero; no ratio with zero denominator is evaluated. This is expected-amount conservation, not a proof of realized bilateral matching.

Define N_kj = (1-psi_kj)D_kj as a temporary abbreviation. It is nonnegative and Delta_j = sum_k mu_k N_kj. If Delta_j = 0, positivity of mu_k and nonnegativity of N_kj imply N_kj = 0 for every k: any positive term would make the sum positive. Thus zero-demand states contribute zero coverage, consistently with varphi_j = 0. If Delta_j > 0,

$$
\sum_k\mu_k\varphi_jN_{kj}
=\min(1,F/\Delta_j)\Delta_j=\min(F,\Delta_j)\le F.
$$

For Delta_j = 0 both sides are zero. F is nonnegative; these are feasibility identities, not participation conditions.

## 7. Weighted incidence and zero-demand cancellation

**Target:** equations (6) and (15), every intermediate sum.

Let C_k = sum_j w_j varphi_j N_kj, Cbar = sum_k mu_k C_k and D = sum_k mu_k d_k > 0. Define I_k only when Cbar > 0. Using d_k > 0,

$$
\sum_k\frac{\mu_kd_k}{D}I_k
=\sum_k\frac{\mu_kd_k}{D}\frac{C_k/d_k}{\bar C/D}
=\frac{\sum_k\mu_k C_k}{\bar C}=1.
$$

Now freeze buffers and allocations. Define B = {j: Delta_j > 0} and p_B = sum_{j in B}w_j = Pr(Delta > 0) > 0. Assume 0 < F < min_{j in B} Delta_j, so every positive-demand state is rationed. The minimum exists because B is finite and nonempty. Zero-demand states have N_kj = 0. Therefore

$$
C_k(F)=\sum_{j\in B}w_j\frac{F}{\Delta_j}N_{kj}
=F\sum_{j\in B}w_j\frac{N_{kj}}{\Delta_j},
$$
$$
\begin{aligned}
\bar C(F)&=\sum_k\mu_k F\sum_{j\in B}w_j\frac{N_{kj}}{\Delta_j}\\
&=F\sum_{j\in B}w_j\frac{\sum_k\mu_k N_{kj}}{\Delta_j}
=F\sum_{j\in B}w_j\frac{\Delta_j}{\Delta_j}
=Fp_B>0.
\end{aligned}
$$

Finite sums may be interchanged. Every denominator in the restricted sum is strictly positive. Consequently

$$
I_k(F)=\frac{F\sum_{j\in B}w_jN_{kj}/(d_k\Delta_j)}{Fp_B/D}
=\frac{D}{d_kp_B}\sum_{j\in B}w_j\frac{N_{kj}}{\Delta_j},
$$

which is independent of F under these fixed-profile restrictions. If p_B = 1, Cbar = F; if p_B < 1, writing Cbar = F is incorrect. If B is empty, Cbar = 0 and the relative index is undefined. At F = 0 it is also undefined. Saturation can invalidate the common scaling; endogenous buffer adjustments invalidate the fixed-profile premise. None of these ratios is a subsidy or welfare measure.

## 8. Student completion

Handwrite the primitive-to-C^1 justification, neighborhood construction, IFT invocation, local-minimum argument, strict-sign iff proof, full compact-gap chain and all restricted incidence sums. Retain the genuine manuscript 04's correct order (branch before differentiation) and manuscript 05's p_B definition. New handwritten pages and an explicit student assessment of these additional steps: **pending**.
