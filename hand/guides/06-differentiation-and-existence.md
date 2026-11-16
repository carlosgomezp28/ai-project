# 06 - Differentiation and existence

**Typed preparation guide, not handwritten evidence.** Prepared with AI assistance for the student to check, derive personally and scan. Reading or copying this guide does not establish a human verdict. Existing genuine manuscripts 02-05 remain unchanged. The architecture is joint work by Carlos Gómez Puicán and Fabián Méndez Suárez under Marco Ortiz; the optimization closure is Carlos's individual course contribution.

## Paper map and notation

Controlling source: `paper/paper.tex`, Assumptions 1-5 (`ass:units` through `ass:frozen`), Section 3, equations (1)-(7); Section 4.1, Proposition 1 (`prop:choice`), equations (8)-(13). Equation labels remain the reliable references if pagination changes. This guide supports, and does not change, those statements.

Fix one bank and one aggregate state A_j. Write d > 0, u in [0, ubar], ubar > 0, omega = beta A_j + eps, x^+ = max(x,0), and E_j for conditional expectation given A_j. The conditional law is atomless and E_j|omega| < infinity. There are finitely many states with w_j > 0 and sum_j w_j = 1. Prices and allocation/coverage schedules are frozen during this derivative.

## 1. Amounts, ratios and the moment identity

**Target:** equations (2) and (8), including the deposit factors.

For d > 0 and any real x, split into x >= 0 and x < 0 to obtain (dx)^+ = d x^+. Thus, using equation (1),

$$
D_j(u)=E_j[(-d(\omega+u))^+]=dE_j[(-\omega-u)^+]=dL_j(u),
$$
$$
X_j(u)=E_j[(d(\omega+u))^+]=dE_j[(\omega+u)^+]=dM_j(u).
$$

Division by d is legitimate because d > 0. L, M and u are per-deposit ratios; D and X are currency amounts per bank. Differentiation with respect to a ratio does not remove the factor d from amount derivatives.

For any real x, x^+ - (-x)^+ = x: verify separately for x >= 0 and x < 0. Substitute x = omega + u and take the conditional expectation:

$$
M_j-L_j=E_j[(\omega+u)^+-(-\omega-u)^+]
=E_j[\omega+u]=E_j[\omega]+u.
$$

Linearity is applicable because both positive parts are integrable: each is bounded by |omega| + |u|. No symmetry or zero mean is needed for this identity. E_j[omega] = beta A_j only in the centered-uniform specialization of Appendix A.

## 2. Pointwise derivatives and dominated convergence

**Target:** equation (10), L'_j = -pi^-_j and M'_j = pi^+_j.

The maximum map is 1-Lipschitz:

$$
|x^+-y^+|\le |x-y|.
$$

For example, if x >= 0 >= y then |x^+ - y^+| = x <= x-y; the other sign cases give the same bound. Consequently, for any nonzero h,

$$
\left|\frac{(-\omega-u-h)^+-(-\omega-u)^+}{h}\right|\le1,
\quad
\left|\frac{(\omega+u+h)^+-(\omega+u)^+}{h}\right|\le1.
$$

If omega + u < 0, the first quotient tends to -1 and the second to 0. If omega + u > 0, the limits are 0 and 1. At omega + u = 0 the pointwise two-sided derivative need not exist. Atomlessness gives Pr_j(omega = -u) = 0, so this exceptional event has zero conditional probability.

The dominating function is the constant 1, whose conditional expectation equals 1. The dominated convergence theorem therefore permits passing the limit through E_j for each difference quotient:

$$
L'_j(u)=E_j[-1_{\{\omega+u<0\}}]=-\Pr_j(\omega+u<0)=-\pi^-_j(u),
$$
$$
M'_j(u)=E_j[1_{\{\omega+u>0\}}]=\Pr_j(\omega+u>0)=\pi^+_j(u).
$$

This argument uses no density. Atomlessness is sufficient, not a claim that it is logically necessary at every possible u. An atom at the threshold can instead produce distinct one-sided derivatives.

At u = 0 or u = ubar, take feasible one-sided increments. The frozen formulas also define an extension to all real u, so the same derivative values supply the one-sided constrained derivatives. A constrained endpoint optimum need not have derivative zero.

## 3. Continuity, finite cost and existence

**Target:** the first sentence of Proposition 1.

The Lipschitz bound also yields |L_j(u)-L_j(v)| <= |u-v| and the same bound for M_j. Hence both moments are continuous and finite. If u_n -> u, the deficit and surplus indicators converge except at omega = -u. Dominated convergence with bound 1 shows pi^-_j(u_n) -> pi^-_j(u), and similarly for pi^+_j. Also pi^-_j + pi^+_j = 1 by atomlessness.

From equation (9), a_j = i psi_j + kappa(1-varphi_j)(1-psi_j) and b_j = i ell_j are finite and nonnegative under Assumptions 3-5. Their difference need not be nonnegative. With finite m,

$$
J(u)=ru+\sum_{j=1}^m w_j[a_jL_j(u)-b_jM_j(u)]
$$

is a finite continuous function, and the derivative obtained below is continuous. The nonempty feasible set [0,ubar] is compact. The extreme-value theorem supplies at least one global minimizer. It does not supply convexity, uniqueness or an interior solution. Negative net cost is possible because lending income is subtracted.

## 4. Frozen-schedule derivative and the lender term

**Target:** equations (10)-(11), Proposition 1.

All w_j, a_j and b_j are constants with respect to this individual u. Differentiate the finite sum term by term:

$$
J'=r+\sum_jw_j(a_jL'_j-b_jM'_j)
=r-\sum_jw_j(a_j\pi^-_j+b_j\pi^+_j).
$$

For an interior local minimum, Fermat's necessary condition J' = 0 gives equation (11). The second term inside the sum has a plus sign in the marginal benefit: -b_j M_j is income subtracted from cost. This FOC alone is not sufficient without the additional optimization conditions in guide 07.

The schedules depend on the reference population profile, not on the deviating measure-zero bank's u. Recomputing P, Q, psi, ell or Delta when taking this derivative would be another problem and require additional terms. Two bank classes do not mean that the bank controls an entire positive-mass class.

## 5. Density-based second derivative

**Target:** equation (12), a local statement.

If the conditional distribution has density f_j continuous near -u, its CDF F_j obeys F'_j(x) = f_j(x) there. Since the law is atomless,

$$
\pi^-_j(u)=F_j(-u),\quad
(\pi^-_j)'(u)=-f_j(-u),\quad
(\pi^+_j)'(u)=f_j(-u).
$$

The chain rule contributes the minus sign in the first derivative. Therefore

$$
J''=-\sum_jw_j[a_j(-f_j(-u))+b_j f_j(-u)]
=\sum_jw_j(a_j-b_j)f_j(-u).
$$

This does not assert existence of J'' at uniform-support knots. Guide 08 checks first derivatives at those joins explicitly. Endpoint constrained conditions use J', not an unsupported second derivative at a support boundary.

## 6. Human unit check and completion record

**Target:** the genuine check in manuscript 02, p. 2; Appendix D.

At d = 1.6 and pi^- = 0.30,

$$
L_u=-0.30,\qquad D_u=dL_u=1.6(-0.30)=-0.48.
$$

Thus -0.30 is not the amount derivative when d = 1.6. State this verdict in your own words and identify the factor introduced by positive homogeneity. Existing manuscript 02 already records this check; the new pages must supply the missing analytic justifications above, not pretend the check was new.

Before scanning, mark where each assumption is used: d > 0 for normalization; finite moments for finite expectations; atomlessness for threshold exceptions and continuous probabilities; finite states and frozen schedules for differentiation of J; compactness for existence. Student verification and new scan: **pending**.
