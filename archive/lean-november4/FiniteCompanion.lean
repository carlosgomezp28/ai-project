import Gomez26EligibilityBuffers.BufferCore

/-! Explicit finite-uniform function companion, not a probability bridge.
Paper: Appendix A (23)--(25), objective (11), derivative (12).
Mean j stands for beta*A_j, held fixed across the buffer comparison.
-/
namespace Gomez26EligibilityBuffers
open scoped BigOperators

noncomputable def finiteLoss {n : ℕ} (w sigma mean : Fin n → ℝ) (t : ℝ) : ℝ :=
  ∑ j, w j * ell (sigma j) (t-mean j)

noncomputable def finiteTail {n : ℕ} (w sigma mean : Fin n → ℝ) (t : ℝ) : ℝ :=
  ∑ j, w j * piTail (sigma j) (t-mean j)

noncomputable def finiteObjective {n : ℕ} (w sigma mean : Fin n → ℝ)
    (c p g phi chi U r u : ℝ) : ℝ :=
  c*(r+u) + p*finiteLoss w sigma mean (u+phi*r) +
    (g-p)*finiteLoss w sigma mean (phi*r+chi*U+(1-chi)*u)

theorem finiteLoss_derivative {n : ℕ} {w sigma mean : Fin n → ℝ} {t : ℝ}
    (hs : ∀ j, 0 < sigma j)
    (hl : ∀ j, t-mean j ≠ -sigma j) (hu : ∀ j, t-mean j ≠ sigma j) :
    HasDerivAt (finiteLoss w sigma mean) (-finiteTail w sigma mean t) t := by
  have hd : HasDerivAt (fun x => ∑ j, w j*ell (sigma j) (x-mean j))
      (∑ j, w j * (-piTail (sigma j) (t-mean j)*1)) t := by
    apply HasDerivAt.fun_sum
    intro j _
    have hj : HasDerivAt (ell (sigma j)) (-piTail (sigma j) (t-mean j))
        (t-mean j) := ell_derivative (hs j) (hl j) (hu j)
    exact (hj.comp t ((hasDerivAt_id t).sub_const (mean j))).const_mul (w j)
  convert hd using 1
  simp [finiteTail, Finset.sum_neg_distrib]

theorem finiteObjective_derivative {n : ℕ} {w sigma mean : Fin n → ℝ}
    {c p g phi chi U r u : ℝ} (hs : ∀ j, 0 < sigma j)
    (h1l : ∀ j, u+phi*r-mean j ≠ -sigma j)
    (h1u : ∀ j, u+phi*r-mean j ≠ sigma j)
    (h2l : ∀ j, phi*r+chi*U+(1-chi)*u-mean j ≠ -sigma j)
    (h2u : ∀ j, phi*r+chi*U+(1-chi)*u-mean j ≠ sigma j) :
    HasDerivAt (finiteObjective w sigma mean c p g phi chi U r)
      (c-p*finiteTail w sigma mean (u+phi*r) -
        (g-p)*(1-chi)*finiteTail w sigma mean (phi*r+chi*U+(1-chi)*u)) u := by
  have h1 := ((finiteLoss_derivative (w := w) hs h1l h1u).comp u
    ((hasDerivAt_id u).add_const (phi*r))).const_mul p
  have h2 := ((finiteLoss_derivative (w := w) hs h2l h2u).comp u
    (((hasDerivAt_id u).const_mul (1-chi)).const_add (phi*r+chi*U))).const_mul (g-p)
  have hc := ((hasDerivAt_id u).const_add r).const_mul c
  convert (hc.add h1).add h2 using 1; ring

theorem finite_foc_iff {n : ℕ} (w sigma mean : Fin n → ℝ) (c p g phi chi U r u : ℝ) :
    c-p*finiteTail w sigma mean (u+phi*r) -
      (g-p)*(1-chi)*finiteTail w sigma mean (phi*r+chi*U+(1-chi)*u) = 0 ↔
    c = p*finiteTail w sigma mean (u+phi*r) +
      (g-p)*(1-chi)*finiteTail w sigma mean (phi*r+chi*U+(1-chi)*u) := by
  constructor <;> intro h <;> linarith

-- This is the nonnegativity of the displayed density FORMULA, not its
-- probabilistic interpretation or an identification with the objective's J''.
noncomputable def finiteDensity {n : ℕ} (w sigma mean : Fin n → ℝ) (t : ℝ) : ℝ :=
  ∑ j, if |t-mean j| < sigma j then w j/(2*sigma j) else 0

theorem finiteDensity_nonneg {n : ℕ} {w sigma mean : Fin n → ℝ} (t : ℝ)
    (hw : ∀ j, 0 ≤ w j) (hs : ∀ j, 0 < sigma j) :
    0 ≤ finiteDensity w sigma mean t := by
  apply Finset.sum_nonneg
  intro j _
  split_ifs
  · exact div_nonneg (hw j) (mul_nonneg (by norm_num) (le_of_lt (hs j)))
  · exact le_rfl

theorem finite_curvature_formula_nonneg {n : ℕ} {w sigma mean : Fin n → ℝ}
    {p g chi t1 t2 : ℝ} (hw : ∀ j, 0 ≤ w j) (hs : ∀ j, 0 < sigma j)
    (hp : 0 ≤ p) (hgp : p ≤ g) :
    0 ≤ curvature p g chi (finiteDensity w sigma mean t1) (finiteDensity w sigma mean t2) := by
  exact curvature_nonneg hp hgp (finiteDensity_nonneg t1 hw hs) (finiteDensity_nonneg t2 hw hs)

end Gomez26EligibilityBuffers
