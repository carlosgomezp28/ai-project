import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Analysis.Calculus.LocalExtr.Basic
import Mathlib.Tactic

/-! Current Appendix A finite-uniform FUNCTION realization.
The integral/probability interpretation is a separate open obligation.
Proof pattern for regional differentiation adapted from the author's historical
BufferCore.lean, while all definitions and the objective below are current-model ones. -/
namespace Gomez26LiquidityBuffers
open Filter
open scoped Topology BigOperators

noncomputable def uniformPositive (σ z : ℝ) : ℝ :=
  if z ≤ -σ then 0 else if z < σ then (σ+z)^2/(4*σ) else z
noncomputable def uniformSurplusProb (σ z : ℝ) : ℝ :=
  if z ≤ -σ then 0 else if z < σ then (σ+z)/(2*σ) else 1

 theorem uniform_lower_value {σ : ℝ} (hσ : 0 < σ) : uniformPositive σ (-σ) = 0 := by
  simp [uniformPositive]
 theorem uniform_upper_value {σ : ℝ} (hσ : 0 < σ) : uniformPositive σ σ = σ := by
  simp [uniformPositive, show ¬σ ≤ -σ by linarith]

 theorem uniform_derivative_below {σ z : ℝ} (hz : z < -σ) :
    HasDerivAt (uniformPositive σ) 0 z := by
  apply (hasDerivAt_const z (0 : ℝ)).congr_of_eventuallyEq
  filter_upwards [eventually_lt_nhds hz] with x hx
  simp [uniformPositive, le_of_lt hx]

 theorem uniform_derivative_inside {σ z : ℝ} (hσ : 0 < σ)
    (hl : -σ < z) (hu : z < σ) :
    HasDerivAt (uniformPositive σ) ((σ+z)/(2*σ)) z := by
  have hd := (((hasDerivAt_const z σ).add (hasDerivAt_id z)).pow 2).div_const (4*σ)
  have hd' : HasDerivAt (fun x : ℝ => (σ+x)^2/(4*σ)) ((σ+z)/(2*σ)) z := by
    convert hd using 1
    dsimp
    field_simp
    ring
  apply hd'.congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hl, eventually_lt_nhds hu] with x hx1 hx2
  simp [uniformPositive, not_le.mpr hx1, hx2]

 theorem uniform_derivative_above {σ z : ℝ} (hσ : 0 < σ) (hz : σ < z) :
    HasDerivAt (uniformPositive σ) 1 z := by
  apply (hasDerivAt_id z).congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hz] with x hx
  simp [uniformPositive, show ¬x ≤ -σ by linarith, not_lt.mpr hx.le]

 theorem uniform_derivative {σ z : ℝ} (hσ : 0 < σ)
    (hl : z ≠ -σ) (hu : z ≠ σ) :
    HasDerivAt (uniformPositive σ) (uniformSurplusProb σ z) z := by
  by_cases h1 : z ≤ -σ
  · simpa [uniformSurplusProb, h1] using uniform_derivative_below (lt_of_le_of_ne h1 hl)
  · by_cases h2 : z < σ
    · simpa [uniformSurplusProb, h1, h2] using uniform_derivative_inside hσ (lt_of_not_ge h1) h2
    · simpa [uniformSurplusProb, h1, h2] using
        uniform_derivative_above hσ (lt_of_le_of_ne (le_of_not_gt h2) hu.symm)

 theorem uniform_reflection_identity {σ : ℝ} (hσ : 0 < σ) (z : ℝ) :
    uniformPositive σ z - uniformPositive σ (-z) = z := by
  by_cases hl : z ≤ -σ
  · have hn : σ ≤ -z := by linarith
    simp [uniformPositive, hl, show ¬ -z ≤ -σ by linarith, not_lt.mpr hn]
  · by_cases hu : z < σ
    · have h1 : ¬ -z ≤ -σ := by linarith
      have h2 : -z < σ := by linarith
      simp only [uniformPositive, if_neg hl, if_pos hu, if_neg h1, if_pos h2]
      field_simp; ring
    · have hz : σ ≤ z := le_of_not_gt hu
      simp [uniformPositive, hl, hu, show -z ≤ -σ by linarith]

noncomputable def uniformObjective {n : ℕ} (w σ mean a b : Fin n → ℝ) (r u : ℝ) : ℝ :=
  r*u + ∑ j, w j * (a j*uniformPositive (σ j) (-(mean j+u)) -
    b j*uniformPositive (σ j) (mean j+u))
noncomputable def uniformMarginal {n : ℕ} (w σ mean a b : Fin n → ℝ) (r u : ℝ) : ℝ :=
  r - ∑ j, w j * (a j*uniformSurplusProb (σ j) (-(mean j+u)) +
    b j*uniformSurplusProb (σ j) (mean j+u))

 theorem uniform_objective_derivative {n : ℕ} (w σ mean a b : Fin n → ℝ) (r u : ℝ)
    (hσ : ∀ j, 0 < σ j)
    (hl : ∀ j, mean j+u ≠ -σ j) (hu : ∀ j, mean j+u ≠ σ j) :
    HasDerivAt (uniformObjective w σ mean a b r) (uniformMarginal w σ mean a b r u) u := by
  have hd : HasDerivAt (fun x => ∑ j, w j *
      (a j*uniformPositive (σ j) (-(mean j+x)) - b j*uniformPositive (σ j) (mean j+x)))
      (∑ j, w j * (a j*(uniformSurplusProb (σ j) (-(mean j+u)) * (-1)) -
        b j*(uniformSurplusProb (σ j) (mean j+u)*1))) u := by
    apply HasDerivAt.fun_sum
    intro j _
    have hm := (hasDerivAt_id u).const_add (mean j)
    have hn := uniform_derivative (hσ j)
      (show -(mean j+u) ≠ -σ j by intro h; apply hu j; linarith)
      (show -(mean j+u) ≠ σ j by intro h; apply hl j; linarith)
    have hp := uniform_derivative (hσ j) (hl j) (hu j)
    exact (((hn.comp u hm.neg).const_mul (a j)).sub
      ((hp.comp u hm).const_mul (b j))).const_mul (w j)
  have hr := (hasDerivAt_id u).const_mul r
  convert hr.add hd using 1
  unfold uniformMarginal
  simp only [mul_one]
  rw [sub_eq_add_neg, ← Finset.sum_neg_distrib]
  congr 1; apply Finset.sum_congr rfl; intro j _; ring

/-- Actual objective differentiation plus Fermat; no assumed FOC equation. -/
 theorem uniform_interior_foc {n : ℕ} (w σ mean a b : Fin n → ℝ) (r u : ℝ)
    (hσ : ∀ j, 0 < σ j)
    (hl : ∀ j, mean j+u ≠ -σ j) (hu : ∀ j, mean j+u ≠ σ j)
    (hmin : IsLocalMin (uniformObjective w σ mean a b r) u) :
    uniformMarginal w σ mean a b r u = 0 := by
  exact hmin.hasDerivAt_eq_zero (uniform_objective_derivative w σ mean a b r u hσ hl hu)

end Gomez26LiquidityBuffers
