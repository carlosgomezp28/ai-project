import Gomez26LiquidityBuffers.Accounting
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Tactic

/-! Current capacity derivatives: phi means common coverage, not old reserve usability.
The FOC probabilities are frozen when taking the partial derivative with respect to F.
No differentiable optimizer is assumed or proved by the scalar sign lemmas. -/
namespace Gomez26LiquidityBuffers
open Filter
open scoped Topology BigOperators

noncomputable def coverageSlope (F Δ : ℝ) : ℝ :=
  if 0 < Δ ∧ F < Δ then 1/Δ else 0

 theorem coverageSlope_nonneg (F Δ : ℝ) : 0 ≤ coverageSlope F Δ := by
  unfold coverageSlope; split_ifs with h
  · exact div_nonneg (by norm_num) h.1.le
  · exact le_rfl

 theorem coverageSlope_pos_iff (F Δ : ℝ) :
    0 < coverageSlope F Δ ↔ 0 < Δ ∧ F < Δ := by
  unfold coverageSlope; split_ifs with h
  · simp [h]
  · simp [h]

 theorem coverage_derivative_rationed {F Δ : ℝ} (hΔ : 0 < Δ) (hF : F < Δ) :
    HasDerivAt (fun x => coverage x Δ) (1/Δ) F := by
  apply ((hasDerivAt_id F).div_const Δ).congr_of_eventuallyEq
  filter_upwards [eventually_lt_nhds hF] with x hx
  simp [coverage, hΔ, min_eq_right ((div_le_one hΔ).mpr hx.le)]

 theorem coverage_derivative_saturated {F Δ : ℝ} (hΔ : 0 < Δ) (hF : Δ < F) :
    HasDerivAt (fun x => coverage x Δ) 0 F := by
  apply (hasDerivAt_const F (1 : ℝ)).congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hF] with x hx
  simp [coverage, hΔ, min_eq_left ((one_le_div hΔ).mpr hx.le)]

 theorem coverage_derivative {F Δ : ℝ} (hreg : 0 < Δ → F ≠ Δ) :
    HasDerivAt (fun x => coverage x Δ) (coverageSlope F Δ) F := by
  by_cases hΔ : 0 < Δ
  · by_cases hF : F < Δ
    · simpa [coverageSlope, hΔ, hF] using coverage_derivative_rationed hΔ hF
    · have hx : Δ < F := lt_of_le_of_ne (le_of_not_gt hF) (hreg hΔ).symm
      simpa [coverageSlope, hΔ, hF] using coverage_derivative_saturated hΔ hx
  · simpa [coverage, coverageSlope, hΔ] using hasDerivAt_const F (0 : ℝ)

noncomputable def deficitCoefficient (i κ ψ Δ F : ℝ) : ℝ :=
  i*ψ + κ*(1-coverage F Δ)*(1-ψ)

 theorem deficitCoefficient_derivative (i κ ψ Δ F : ℝ) (hreg : 0 < Δ → F ≠ Δ) :
    HasDerivAt (deficitCoefficient i κ ψ Δ) (-κ*(1-ψ)*coverageSlope F Δ) F := by
  have h := (((hasDerivAt_const F 1).sub (coverage_derivative hreg)).const_mul κ).mul_const (1-ψ)
  have hh := (hasDerivAt_const F (i*ψ)).add h
  convert hh using 1
  dsimp
  ring

noncomputable def frozenMarginal {n : ℕ} (w ψ ℓ Δ πminus πplus : Fin n → ℝ)
    (r i κ F : ℝ) : ℝ :=
  r - ∑ j, w j*(deficitCoefficient i κ (ψ j) (Δ j) F * πminus j + i*ℓ j*πplus j)
noncomputable def capacityNumerator {n : ℕ} (w ψ Δ πminus : Fin n → ℝ) (κ F : ℝ) : ℝ :=
  κ * ∑ j, w j*(1-ψ j)*πminus j*coverageSlope F (Δ j)

 theorem frozenMarginal_capacity_derivative {n : ℕ} (w ψ ℓ Δ πminus πplus : Fin n → ℝ)
    (r i κ F : ℝ) (hreg : ∀ j, 0 < Δ j → F ≠ Δ j) :
    HasDerivAt (frozenMarginal w ψ ℓ Δ πminus πplus r i κ)
      (capacityNumerator w ψ Δ πminus κ F) F := by
  have hsum : HasDerivAt (fun x => ∑ j, w j*
      (deficitCoefficient i κ (ψ j) (Δ j) x * πminus j + i*ℓ j*πplus j))
      (∑ j, w j*((-κ*(1-ψ j)*coverageSlope F (Δ j))*πminus j)) F := by
    apply HasDerivAt.fun_sum
    intro j _
    simpa using (((deficitCoefficient_derivative i κ (ψ j) (Δ j) F (hreg j)).mul_const
      (πminus j)).add_const (i*ℓ j*πplus j)).const_mul (w j)
  have h := (hasDerivAt_const F r).sub hsum
  convert h using 1
  unfold capacityNumerator
  rw [Finset.mul_sum]
  simp only [zero_sub]
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl; intro j _; ring

 theorem capacityNumerator_nonneg {n : ℕ} (w ψ Δ πminus : Fin n → ℝ) {κ F : ℝ}
    (hκ : 0 ≤ κ) (hw : ∀ j, 0 ≤ w j) (hψ : ∀ j, ψ j ≤ 1)
    (hπ : ∀ j, 0 ≤ πminus j) : 0 ≤ capacityNumerator w ψ Δ πminus κ F := by
  apply mul_nonneg hκ
  apply Finset.sum_nonneg
  intro j _
  exact mul_nonneg (mul_nonneg (mul_nonneg (hw j) (sub_nonneg.mpr (hψ j))) (hπ j))
    (coverageSlope_nonneg F (Δ j))

 theorem capacity_response_nonpos {N H : ℝ} (hN : 0 ≤ N) (hH : 0 < H) : -N/H ≤ 0 := by
  exact div_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hN) hH.le

 theorem capacity_response_strict {N H : ℝ} (hH : 0 < H) : -N/H < 0 ↔ 0 < N := by
  rw [div_lt_iff₀ hH]
  constructor <;> intro h <;> nlinarith


 theorem capacityNumerator_positive_iff {n : ℕ} (w ψ Δ πminus : Fin n → ℝ) {κ F : ℝ}
    (hκ : 0 < κ) (hw : ∀ j, 0 < w j) (hψ : ∀ j, ψ j ≤ 1) (hπ : ∀ j, 0 ≤ πminus j) :
    0 < capacityNumerator w ψ Δ πminus κ F ↔
      ∃ j, 0 < Δ j ∧ F < Δ j ∧ ψ j < 1 ∧ 0 < πminus j := by
  let term := fun j => w j*(1-ψ j)*πminus j*coverageSlope F (Δ j)
  have ht : ∀ j, 0 ≤ term j := fun j =>
    mul_nonneg (mul_nonneg (mul_nonneg (hw j).le (sub_nonneg.mpr (hψ j))) (hπ j))
      (coverageSlope_nonneg F (Δ j))
  change 0 < κ*(∑ j, term j) ↔ _
  rw [mul_pos_iff_of_pos_left hκ, Finset.sum_pos_iff_of_nonneg (fun j _ => ht j)]
  constructor
  · rintro ⟨j, _, hj⟩
    have hψ' : ψ j < 1 := by
      by_contra h
      have he : ψ j=1 := le_antisymm (hψ j) (le_of_not_gt h)
      simp [term, he] at hj
    have hπ' : 0 < πminus j := by
      by_contra h
      have he : πminus j=0 := le_antisymm (le_of_not_gt h) (hπ j)
      simp [term, he] at hj
    have hs : 0 < coverageSlope F (Δ j) := by
      by_contra h
      have he : coverageSlope F (Δ j)=0 :=
        le_antisymm (le_of_not_gt h) (coverageSlope_nonneg F (Δ j))
      simp [term, he] at hj
    have hd := (coverageSlope_pos_iff F (Δ j)).mp hs
    exact ⟨j, hd.1, hd.2, hψ', hπ'⟩
  · rintro ⟨j, hΔ, hF, hψ', hπ'⟩
    exact ⟨j, Finset.mem_univ j, mul_pos (mul_pos (mul_pos (hw j) (sub_pos.mpr hψ')) hπ')
      ((coverageSlope_pos_iff F (Δ j)).mpr ⟨hΔ,hF⟩)⟩

end Gomez26LiquidityBuffers
