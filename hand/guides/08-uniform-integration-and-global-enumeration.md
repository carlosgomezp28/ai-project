# 08 - Uniform integration and complete global enumeration

**Typed mathematical preparation, not simulated handwriting.** The student must independently verify and write these steps. No new numerical experiment, parameter, economic assumption or theorem target is introduced. Finite conditional uniforms are the existing course specialization, not a restriction on the general Proposition 1.

**Paper references:** Appendix A (`app:uniform`); Section 4.2 global solution; Proposition 1, equations (10)-(13); Section 6 constructed parameters and optima; Appendix B (`app:verification`). Implementation references are `moments`, `breakpoints`, `optimum` and `convexity_certificate` in `code/post_marco_model.py`; independent checks are in `code/verify_post_marco.py`.

## 1. Integrate the positive part in every region

**Target:** Appendix A's T_sigma(z) formula.

Assume sigma > 0, eps conditional on A is uniform on [-sigma,sigma], and z is real. The probability density is 1/(2 sigma) on that interval and zero outside. Width positivity is essential to divide by 2 sigma. Define

$$
T_\sigma(z)=E[(z+\epsilon)^+]
=\frac1{2\sigma}\int_{-\sigma}^{\sigma}\max(z+e,0)\,de.
$$

If z <= -sigma, then z+e <= z+sigma <= 0 throughout the interval; the integrand is zero, so T_sigma(z) = 0.

If -sigma < z < sigma, then -sigma < -z < sigma. The integrand is zero for e <= -z and z+e for e > -z. Hence

$$
\begin{aligned}
T_\sigma(z)&=\frac1{2\sigma}\int_{-z}^{\sigma}(z+e)\,de\\
&=\frac1{2\sigma}\left[ze+\frac{e^2}{2}\right]_{-z}^{\sigma}\\
&=\frac1{2\sigma}\left[z\sigma+\frac{\sigma^2}{2}
-\left(-z^2+\frac{z^2}{2}\right)\right]\\
&=\frac{z^2+2z\sigma+\sigma^2}{4\sigma}
=\frac{(\sigma+z)^2}{4\sigma}.
\end{aligned}
$$

If z >= sigma, then z+e >= z-sigma >= 0 throughout. Therefore

$$
T_\sigma(z)=\frac1{2\sigma}\int_{-\sigma}^{\sigma}(z+e)\,de
=\frac{2\sigma z+0}{2\sigma}=z.
$$

At z = -sigma the middle expression equals zero, agreeing with the lower branch. At z = sigma it equals sigma, agreeing with the upper branch. These endpoint calculations justify continuity; zero probability at individual endpoints means their density convention does not change the integral.

## 2. Reflection and the actual conditional moments

**Target:** L_j = T_sigma_j(-z_j), M_j = T_sigma_j(z_j).

For each state define z_j = beta A_j + u. By normalization in guide 06,

$$
M_j=\frac1{2\sigma_j}\int_{-\sigma_j}^{\sigma_j}(z_j+e)^+de
=T_{\sigma_j}(z_j).
$$

For the deficit, substitute t = -e, de = -dt, and reverse bounds:

$$
\begin{aligned}
L_j&=\frac1{2\sigma_j}\int_{-\sigma_j}^{\sigma_j}(-z_j-e)^+de\\
&=\frac1{2\sigma_j}\int_{\sigma_j}^{-\sigma_j}(-z_j+t)^+(-dt)\\
&=\frac1{2\sigma_j}\int_{-\sigma_j}^{\sigma_j}(-z_j+t)^+dt
=T_{\sigma_j}(-z_j).
\end{aligned}
$$

Reflection uses symmetry of this centered uniform distribution. It is not valid for an arbitrary asymmetric law without changing that law. Expanding gives

$$
L_j=\begin{cases}-z_j,&z_j\le-\sigma_j,\\
(\sigma_j-z_j)^2/(4\sigma_j),&|z_j|<\sigma_j,\\
0,&z_j\ge\sigma_j,
\end{cases}
\quad
M_j=\begin{cases}0,&z_j\le-\sigma_j,\\
(\sigma_j+z_j)^2/(4\sigma_j),&|z_j|<\sigma_j,\\
z_j,&z_j\ge\sigma_j.
\end{cases}
$$

Check the moment identity directly in the middle region:

$$
M_j-L_j=\frac{(\sigma_j+z_j)^2-(\sigma_j-z_j)^2}{4\sigma_j}
=\frac{4\sigma_jz_j}{4\sigma_j}=z_j.
$$

The two outer regions give z_j as well. This agrees with equation (8), since the centered uniform has E_j[eps] = 0.

## 3. Tail probabilities, first derivatives and joins

**Target:** Appendix A's clipped probability formula and Proposition 1's derivative identities.

The deficit event is eps < -z. If z <= -sigma its probability is one; if z >= sigma it is zero. In the interior its interval length is sigma-z, so

$$
\pi^-(z)=\begin{cases}1,&z\le-\sigma,\\
(\sigma-z)/(2\sigma),&|z|<\sigma,\\
0,&z\ge\sigma,
\end{cases}
=\max\{0,\min\{1,(\sigma-z)/(2\sigma)\}\}.
$$

No atom is present at eps = -z, including endpoints, so pi^+ = 1-pi^-. Directly differentiating T away from the joins yields 0, (sigma+z)/(2 sigma), and 1 in the three regions. The interior derivative tends to zero at -sigma and to one at sigma. To prove differentiability at a join, compute the difference quotients from both sides. At -sigma the lower-side quotient is zero and the upper-side quotient is h/(4 sigma), tending to zero. At sigma the upper-side quotient is one and the lower-side quotient is 1+h/(4 sigma), tending to one. Therefore T is C^1 across both joins.

Since dz_j/du = 1, the chain rule gives L'_j = -pi^-_j and M'_j = pi^+_j, including joins. Multiplying by d_j gives the amount derivatives. In each strict interior support region, both L'' and M'' equal 1/(2 sigma); outside they equal zero. At a join the one-sided second derivatives differ, so there is no ordinary second derivative for the moment there. Cancellation in a particular J could remove a kink in its derivative, but the density convention alone does not prove that cancellation.

The conditional omega density at -u is 1/(2 sigma_j) when |beta A_j+u| < sigma_j, and zero strictly outside. A density's assigned value at a single endpoint is irrelevant to probabilities and is not a substitute for a second-derivative proof.

## 4. Finite partition of the entire feasible interval

**Target:** Appendix A's exhaustive support partition.

Assume a finite number of aggregate states, fixed sigma_j > 0, fixed beta, fixed a_j,b_j and feasible [0,ubar]. A moment changes its polynomial expression only when

$$
\beta A_j+u=\pm\sigma_j
\quad\Longleftrightarrow\quad u=-\beta A_j\pm\sigma_j.
$$

Collect 0, ubar and every such knot strictly inside the feasible interval. Delete duplicate knots and sort into 0 = t_0 < t_1 < ... < t_N = ubar. Knots outside the interval do not create feasible regions. A knot coinciding with an endpoint is already retained.

On each open interval (t_i,t_{i+1}), every state remains in one uniform branch. Thus L_j and M_j are polynomials of degree at most two there. Their finite weighted combination J has the form

$$
q_i(u)=\tfrac12\alpha_i u^2+\gamma_i u+\eta_i,
\qquad q'_i(u)=\alpha_i u+\gamma_i.
$$

Continuity proved above means that the same polynomial extension agrees with J at both adjacent interval endpoints. This fact permits minimizing each closed interval separately and taking the smallest value over the finite union.

## 5. Why the candidate list is complete

**Target:** global minimization even when J is nonconvex.

On one closed interval [l,h], with l < h:

1. If alpha != 0, an interior minimizer must satisfy q'(u) = 0 by Fermat's theorem, giving u_s = -gamma/alpha. Retain it only if l < u_s < h. Otherwise a minimum must be at an endpoint. If alpha < 0 the stationary point is a maximum, but including it in a candidate list is harmless when all values are compared. If alpha > 0 the feasible stationary point is the unique interval minimum.
2. If alpha = 0 and gamma > 0, q(h)-q(l) = gamma(h-l) > 0, so the minimum is at l. If gamma < 0 it is at h.
3. If alpha = gamma = 0, q is constant and every point of [l,h] minimizes on that interval. Record the whole interval, not merely a selected endpoint.

A global minimum exists by guide 06. It belongs to one of these closed intervals and must minimize J there; otherwise a lower point in that interval would contradict global minimality. Therefore it is an interval endpoint, feasible stationary point, or point of a constant interval. Conversely, every listed point or interval whose value equals the smallest candidate value is globally minimizing, since every feasible point belongs to an interval whose minimum was considered. This proves completeness and retains ties.

A root at a boundary is already an endpoint candidate. Do not clip an infeasible root and claim that it solves a nonconvex problem. Do not infer global minimality from a small FOC residual. Corners and all support knots are explicitly evaluated.

## 6. Midpoint construction and exact versus numerical claims

**Target:** connect the structural proof to the existing algorithm without claiming a floating-point theorem.

In a region choose its midpoint m. Since q' is affine and q'' = alpha is constant,

$$
q'(u)=q'(m)+\alpha(u-m),
\qquad u_s=m-q'(m)/\alpha\quad(\alpha\ne0).
$$

This is the stationary-point calculation in `optimum`. If alpha is exactly zero, distinguish a nonzero constant slope from a flat interval. The implementation instead uses documented thresholds: 10^-13 for nearly zero curvature, 10^-12 for a flat slope, and 2*10^-12 for tied costs. Those tolerances can merge nearby numerical cases; reported numerical uniqueness is not exact uniqueness for arbitrary real inputs.

`convexity_certificate` checks the constant curvature on every strict interval. For the exact C^1 piecewise-quadratic objective, nonnegative curvature in every interval implies nondecreasing J' within each interval and, by continuity of J', across joins. Hence J is convex. This condition can hold even if some a_j-b_j < 0 because state contributions offset. Its implemented tolerance is numerical evidence, not a replacement for the exact argument.

Selected optimizer fixtures use a 40,001-point independent grid. Exported optimum rows use the default 16,001-point grid. Exported curve ordinates are recomputed directly. Grids and integration check implementation consistency; they do not prove the exhaustive partition argument. The student must derive that argument, rather than write “the grid proves global optimality.”

## 7. Completion checklist

Handwrite all integration limits and antiderivative evaluations; the reflection substitution with reversed bounds; tail interval lengths; both one-sided derivative checks at each join; knot construction; all three polynomial cases; the global exhaustion argument; and the tolerance limitation. Reference the paper's existing flat and corner fixtures without inventing additional numerical results. Genuine new scan and student verdict: **pending**.
