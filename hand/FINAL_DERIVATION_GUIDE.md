# Final-model derivation guide

**Typed guide only. This is not Carlos's handwritten appendix and is not a
substitute for his handwritten derivations.** Status: all five final-model
blocks still need to be handwritten, explained, and scanned by Carlos.

The proposed V5.1 architecture is joint work by Carlos Gómez Puicán and Fabián
Méndez Suárez under Marco Ortiz. Explicitly open architecture choices remain
pending advisor validation. The direct-support restriction and course closure
are Carlos's individual contribution. OTC/search/matching/Nash are not solved
by these derivations.

Use the numbered assumptions in `paper/paper.tex`. In every block write the
units, what is fixed, why each derivative exists, and whether the result is
global, local, or conditional. Use u for voluntary buffers, v for deferral,
phi for usability, chi for eligibility, and p for a cost, not a probability.

## Block 1 - continuation solution

Planned scan: `02-final-continuation.pdf`.

1. Write d>0, r=R(d)/d, U=1+epsilon_E-r>0, and 0<=u<=U.
2. Derive b/d=U-u and H=chi(U-u)>=0. Define q=(e-u-phi*r)^+>=0.
3. Write W+v=q, 0<=W<=min(q,H), and v>=0. Show the feasible interval is nonempty.
4. Substitute v=q-W into pW+gv to obtain gq-(g-p)W.
5. Use g>p to show strict decrease in W; derive W*=min(q,H) uniquely.
6. Derive v*=q-min(q,H)=(q-H)^+. Check q=0, H=0, q<H, q=H, and q>H.
7. Explain that principal remains payable. This is incremental cost minimization,
   not a claim that assistance is a gift or deferral eliminates an obligation.

## Block 2 - positive-part representation and J

Planned scan: `03-final-positive-part.pdf`.

1. Prove (a^+-H)^+=(a-H)^+ for H>=0 by splitting a<=0 and a>0.
2. Put a=e-u-phi*r. Expand a-H one term at a time:
   e-u-phi*r-chi(U-u)=e-phi*r-chi*U-(1-chi)u.
3. Define t1=u+phi*r and t2=phi*r+chi*U+(1-chi)u=t1+H.
4. Derive q=(e-t1)^+, v*=(e-t2)^+, and W*=q-v*.
5. Derive pW*+gv*=p(q-v*)+gv*=pq+(g-p)v*.
6. Add c(r+u) and take expectations to obtain J. Explain why c*r is constant
   for buffer choice but matters for comparisons of private-cost levels.
7. State that the criterion is maintained, not derived from a full terminal
   profit or welfare account. Do not assert principal cancels without a ledger.

## Block 3 - Proposition 1

Planned scan: `04-final-buffer-optimality.pdf`.

1. For L(t)=E[(e-t)^+], use (e-t)^+<=|e|+|t| to prove finiteness.
2. Prove the positive-part Lipschitz inequality; infer continuity of L and J.
3. Show that each realized positive part of an affine function is convex;
   expectations and nonnegative weights preserve convexity.
4. Apply the extreme-value theorem on [0,U]. Explain why the minimizer set is
   closed and convex, hence a nonempty compact interval, possibly a singleton.
5. Write the threshold difference quotient. Bound it by one. Its almost-sure
   limit is -1{e>t}; continuity of the CDF gives P(e=t)=0. Justify dominated
   convergence and obtain L'(t)=-P(e>t). Continuity of the CDF gives a continuous
   first derivative. Uniformity is not needed for this argument.
6. Use t1_u=1 and t2_u=1-chi to derive the entire J'(u) formula.
7. Under local continuous-density regularity, differentiate again to obtain
   J''=p*f(t1)+(g-p)*(1-chi)^2*f(t2)>=0. State why support knots are excluded
   from this calculation, even though the first derivative remains continuous.
8. Derive the exact variational inequality J'(u*)(z-u*)>=0 for all feasible z.
   Prove both necessity and sufficiency. Obtain lower, interior, and upper signs.
9. Write J'-mu0+muU=0, nonnegative multipliers, mu0*u=0 and muU*(U-u)=0.
   Check endpoint signs explicitly. Endpoint membership in the minimizer set
   does not assert that all minimizers equal that endpoint.
10. Prove sufficient uniqueness: two minima of a convex function force a flat
    connecting segment; positive local curvature at an interior stationary point
    excludes it. Strict endpoint derivative inequalities also imply uniqueness.
11. Explain why zero endpoint slope alone decides neither uniqueness nor
    nonuniqueness. Give a certain-deficit affine region with positive deficit
    probability but zero curvature. Distinguish it from an actual flat minimum.
12. Explain the two FOC probabilities. In a deferral state, derive q_u=-1,
    H_u=-chi, v_u=-(1-chi), W_u=-chi, and saving p*chi+g*(1-chi).

## Block 4 - Proposition 2

Planned scan: `05-final-reserve-response.pdf`.

1. State every local condition: interior admissible r0, U>0, interior FOC root,
   local continuous density at both thresholds, positive curvature, and fixed
   costs, equity, usability, eligibility coefficient, exposure and shock law.
2. Derive U_r=-1; t1_r=phi; t2_r=phi+chi*U_r=phi-chi.
3. Derive t1_u=1 and t2_u=1-chi.
4. Define G=J_u and the equation G(u*(r),r)=0.
5. Derive G_u=p*f(t1)+(g-p)*(1-chi)^2*f(t2)>0.
6. Derive G_r=p*phi*f(t1)+(g-p)*(1-chi)*(phi-chi)*f(t2).
   Explain why fixed c contributes no additional mixed derivative.
7. State the implicit-function theorem and check its hypotheses. Explain why
   the branch remains feasible and is the unique global minimizer locally:
   shrink the neighborhood and use Proposition 1's convexity/uniqueness.
8. Differentiate 0=G(u*(r),r) to obtain 0=G_u*u_r+G_r, then divide by G_u>0.
9. Prove the weak negative sign for phi>=chi and the exact positive-numerator
   condition for strictness. Explain why phi=chi need not give zero.
10. For phi<chi, write the numerator as a nonnegative term minus a nonnegative
    term. State the dominance condition for each sign and for zero.
11. List excluded cases: corners, nonunique minima, zero curvature, support or
    density boundaries, changing shock law, and OTC/search/matching/pricing
    feedback. A Base derivative needs a separate chain rule and treatment of
    B=d. This is not the historical R_D result or an optimal-policy theorem.

## Block 5 - uniform expectations and finite mixtures

Planned scan: `06-final-uniform-mixture.pdf`.

1. Normalize the conditional uniform density to 1/(2*sigma), sigma>0.
2. For ell_sigma(z)=E[(eps-z)^+], derive all three branches:
   - z<=-sigma: E[eps-z]=-z;
   - -sigma<z<sigma: integrate (eps-z)/(2*sigma) from z to sigma;
   - z>=sigma: zero.
3. Evaluate the interior antiderivative eps^2/2-z*eps at both endpoints to
   obtain (sigma-z)^2/(4*sigma). Do not skip the lower endpoint term.
4. Derive Pi_sigma(z)=P(eps>z): 1, (sigma-z)/(2*sigma), or 0.
5. Check values and first derivatives at +/-sigma. Explain C1 versus C2.
6. Form the mixture with z_ij=t_i-beta*A_j, nonnegative weights summing to one.
   Sum the expected positive parts and probabilities; sum active-state
   densities w_j/(2*sigma_j) away from positive-weight support endpoints.
7. Derive both formulas for buffer support breakpoints and restrict them to
   [0,U]. Explain piecewise-affine FOC root calculation, corners and flat roots.
8. Reproduce one baseline FOC and one regular reserve derivative from existing
   output values. Numerical agreement checks the derivation; it is not its proof.

## Final self-check

Every analytical derivation used in the paper must have a legible handwritten
counterpart. Identify added course assumptions versus proposed joint objects.
Do not claim a general probabilistic theorem if the work only checks a uniform
polynomial. Do not claim Lean verification, empirical calibration, advisor
approval, or a solved OTC extension. Preserve the October scan unchanged.
