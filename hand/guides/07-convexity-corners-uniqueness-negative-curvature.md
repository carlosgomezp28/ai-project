# 07 - Global convexity, corners, uniqueness and negative curvature

**Typed preparation guide, not handwriting or proof of student verification.** This expands the current paper; it changes no proposition, assumption or parameter. Check every step personally before producing genuine handwritten pages. Joint thesis provenance and the individual course contribution remain as stated in guide 06.

**Paper references:** Section 4.1, Proposition 1 (`prop:choice`), equations (8)-(13), especially `eq:convexdecomposition`; Section 4.2, the full-coverage counterexample; Section 6, Table 1 reference primitives. Use guide 06 for the moment derivatives and existence proof.

## 1. Global convexity without a global density assumption

**Target:** a_j >= b_j in every positive-weight state is sufficient for convexity.

Assume the finite-state, integrability, compact-domain and frozen-schedule conditions of Proposition 1. Add a_j - b_j >= 0 for every j with w_j > 0. This is a sufficient restriction, not a necessary characterization.

For t in [0,1] and feasible u,v, the maximum of affine functions is convex, so pointwise

$$
(-\omega-[tu+(1-t)v])^+
\le t(-\omega-u)^++(1-t)(-\omega-v)^+.
$$

Taking E_j, which preserves inequalities for integrable variables, gives

$$
L_j(tu+(1-t)v)\le tL_j(u)+(1-t)L_j(v).
$$

By equation (8), M_j = L_j + E_j[omega] + u. Substitute into J and distribute coefficients:

$$
\begin{aligned}
J(u)&=ru+\sum_jw_j\{a_jL_j-b_j[L_j+E_j\omega+u]\}\\
&=\left(r-\sum_jw_jb_j\right)u
+\sum_jw_j(a_j-b_j)L_j(u)-\sum_jw_jb_jE_j\omega.
\end{aligned}
$$

The first and last terms are affine/constant. Every weight w_j(a_j-b_j) in the middle is nonnegative, so summing the preceding convexity inequalities proves global convexity. No density at a support knot is required. A negative coefficient invalidates this sufficient argument but does not alone prove that the total J is nonconvex: other states can offset its curvature.

## 2. Supporting inequality and constrained optimality

**Target:** the iff corner/interior statements in Proposition 1.

Now assume J is differentiable and convex on [0,ubar]. For x,y feasible and 0 < t <= 1, convexity gives

$$
J(x+t(y-x))\le(1-t)J(x)+tJ(y).
$$

Subtract J(x), divide by positive t, and take t down to zero, using the feasible directional derivative:

$$
J'(x)(y-x)\le J(y)-J(x).
$$

Thus the variational inequality J'(x)(y-x) >= 0 for all feasible y is sufficient for global minimality. For necessity at a local minimum, J(x+t(y-x))-J(x) >= 0 for sufficiently small positive t; division by t and the limit give the same variational inequality. This necessity does not require convexity.

At x = 0, y-x >= 0. The variational inequality holds iff J'(0) >= 0: sufficiency follows by multiplication; necessity follows by choosing any y > 0. At x = ubar, y-x <= 0, so it holds iff J'(ubar) <= 0. At an interior x there are both positive and negative feasible directions, forcing J'(x) = 0. Conversely zero derivative satisfies the variational inequality.

Therefore, **under convexity**, these are necessary and sufficient global conditions. Without convexity they are only necessary first-order conditions. The upper-corner test is at **ubar**, not at zero.

## 3. Uniqueness: what additional information proves it

**Target:** the two uniqueness claims in Proposition 1.

If J'(0) > 0, then for y > 0 the supporting inequality yields J(y) >= J(0)+J'(0)y > J(0), so zero is the unique global minimizer. If J'(ubar) < 0 and y < ubar, then J'(ubar)(y-ubar) > 0, giving J(y) > J(ubar). Weak endpoint inequalities alone allow flat minima and do not prove uniqueness.

For the interior claim assume convexity, J'(u*) = 0 and J''(u*) > 0 exists. Stationarity already proves global optimality. Suppose another minimizer v != u* exists. For every t in [0,1], convexity and global minimality imply

$$
\min J\le J((1-t)u*+tv)
\le(1-t)J(u*)+tJ(v)=\min J.
$$

Hence J is constant on the segment between the two minimizers. Its derivative is zero on the segment's interior, so approaching u* from that side gives a second-derivative difference quotient zero, contradicting J''(u*) > 0. Thus u* is unique. Do not replace the convexity premise with positive curvature at one point; a different remote well is possible without convexity.

## 4. Negative curvature: exact admissible counterexample

**Target:** Section 4.2 refutes automatic convexity even when kappa > i.

Use the existing constructed reference parameters, not new estimates: states A = -0.4 and 0 with weights 0.4 and 0.6; uniform eps on [-0.5,0.5]; type 1 beta = 0.8, d = 1, tau = 0.65; type 2 beta = 1.2, d = 1.6, tau = 0.8; masses 0.6 and 0.4; reference buffers 0.1. Use i = 0.015, kappa = 0.25, ubar = 0.8, and set capacity F = 10 for this existing counterexample. Freeze the reference schedules.

Guide 08's moment formulas give adverse-state reference normalized surpluses 0.0392 and 0.0072 and deficits 0.2592 and 0.3872. Include deposits when constructing amounts:

$$
P=0.6(0.65)(1)(0.0392)+0.4(0.8)(1.6)(0.0072)
=0.015288+0.0036864=0.0189744,
$$
$$
Q=0.6(0.65)(1)(0.2592)+0.4(0.8)(1.6)(0.3872)
=0.101088+0.1982464=0.2993344.
$$

Since 0 < P < Q, equation (3) yields

$$
\psi_1=0.65\frac{0.0189744}{0.2993344}\approx0.041202615,
\qquad \ell_1=0.65.
$$

The two reference Delta values in Section 6 are 0.3843536 and 0.02704, both below 10. Thus varphi_j = 1 in both states. By equation (9), a_j-b_j = i(psi_j-ell_j).

At u = 0.65, type 1's adverse omega support is [-0.82,0.18], because beta A = -0.32. The threshold -u = -0.65 is strictly inside this interval, so its density is 1/(2 sigma) = 1. In the normal state omega lies in [-0.5,0.5], so the same threshold is strictly outside and its density is zero. Neither threshold is a support knot. Therefore equation (12) gives the exact expression

$$
J''(0.65)=0.4(0.015)
\left(0.65\frac{0.0189744}{0.2993344}-0.65\right)
\approx-0.0036527843<0.
$$

Negativity follows exactly from P/Q < 1; it does not rely on rounding. Here 0.65 is feasible and interior, and kappa > i >= 0 remains satisfied. This counterexample concerns another capacity scenario, not convexity of the baseline F = 0.015. No claim about the location of its optimizer follows from evaluating curvature at 0.65.

## 5. Minimal correction to genuine manuscript 03

**Location:** page 2, immediately after the displayed full-coverage equality a_k-b_k = i(psi_k-ell_k), in the sentence beginning “If i > 0 and psi_k < ell_k in a positive probability state...”.

The student should add, in genuine handwriting:

> At the evaluated buffer u, also require f_{omega_k|A}(-u | A) > 0. That state's curvature contribution is w_A i(psi_k-ell_k) f_{omega_k|A}(-u | A) < 0. This alone does not determine the sign of the sum over states.

If the density is zero the contribution is zero; at a support knot the displayed density need not represent an existing second derivative. Preserve the original scan; supply a corrected student page or clearly identified handwritten addendum. Do not digitally alter the scan or describe this typed instruction as the correction already made.

## 6. Limits and student completion

Existence comes from guide 06 and requires no convexity. This guide supplies sufficient global conditions and a counterexample to automatic convexity. Guide 08 supplies the exhaustive optimizer when convexity fails, including flat minimizing intervals. A small grid residual is not a global proof.

Before scanning, explicitly mark which statements require global convexity and which are merely necessary without it. Correction, independent student verdict and new handwritten evidence: **pending**.
