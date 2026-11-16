import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Tactic

/-! Current post-Marco accounting, equations (1)-(6), (8), (15).
Final source: post-Marco paper 5b2959633962f46fc59d963b92f756e06da2ff00; no historical November-4 proof credit.
Joint architecture: Carlos Gómez Puicán and Fabián Méndez Suárez under Marco Ortiz.
Individual course closure: Carlos Gómez Puicán. -/
namespace Gomez26LiquidityBuffers
open scoped BigOperators

noncomputable def pos (x : ℝ) : ℝ := max x 0

theorem pos_nonneg (x : ℝ) : 0 ≤ pos x := le_max_right _ _

theorem pos_sub_neg (x : ℝ) : pos x - pos (-x) = x := by
  unfold pos
  by_cases h : 0 ≤ x
  · rw [max_eq_left h, max_eq_right (neg_nonpos.mpr h)]; ring
  · have hx : x ≤ 0 := le_of_not_ge h
    rw [max_eq_right hx, max_eq_left (neg_nonneg.mpr hx)]; ring

theorem pos_scale {d : ℝ} (hd : 0 ≤ d) (x : ℝ) : pos (d*x) = d*pos x := by
  unfold pos
  by_cases h : 0 ≤ x
  · rw [max_eq_left h, max_eq_left (mul_nonneg hd h)]
  · have hx : x ≤ 0 := le_of_not_ge h
    rw [max_eq_right hx, max_eq_right (mul_nonpos_of_nonneg_of_nonpos hd hx), mul_zero]

theorem amount_ratio {d : ℝ} (hd : 0 < d) (x : ℝ) : pos (d*x)/d = pos x := by
  rw [pos_scale hd.le]; field_simp

theorem signed_moment_pointwise (ω u : ℝ) : pos (ω+u)-pos (-ω-u) = ω+u := by
  have h : -ω-u = -(ω+u) := by ring
  rw [h]; exact pos_sub_neg (ω+u)

noncomputable def borrowFraction (τ P Q : ℝ) : ℝ :=
  if P = 0 ∨ Q = 0 then 0 else τ * min 1 (P/Q)
noncomputable def lendFraction (τ P Q : ℝ) : ℝ :=
  if P = 0 ∨ Q = 0 then 0 else τ * min 1 (Q/P)

theorem zero_trade (τ P Q : ℝ) (h : P=0 ∨ Q=0) :
    borrowFraction τ P Q = 0 ∧ lendFraction τ P Q = 0 := by
  simp [borrowFraction, lendFraction, h]

theorem short_side {P Q : ℝ} (hQ : 0 < Q) : min 1 (P/Q)*Q = min P Q := by
  by_cases h : P ≤ Q
  · rw [min_eq_right ((div_le_one hQ).mpr h), min_eq_left h]
    field_simp
  · have h' : Q ≤ P := le_of_not_ge h
    rw [min_eq_left ((one_le_div hQ).mpr h'), min_eq_right h', one_mul]

noncomputable def volume {n : ℕ} (μ τ x : Fin n → ℝ) : ℝ := ∑ k, μ k*τ k*x k

theorem borrowing_conservation {n : ℕ} (μ τ D X : Fin n → ℝ)
    (hP : 0 < volume μ τ X) (hQ : 0 < volume μ τ D) :
    (∑ k, μ k * borrowFraction (τ k) (volume μ τ X) (volume μ τ D) * D k) =
      min (volume μ τ X) (volume μ τ D) := by
  have hz : ¬(volume μ τ X = 0 ∨ volume μ τ D = 0) := by
    rcases eq_or_ne (volume μ τ X) 0 with h | h
    · linarith
    · simp [h, ne_of_gt hQ]
  simp only [borrowFraction, if_neg hz]
  calc
    _ = (∑ k, μ k*τ k*D k) * min 1 (volume μ τ X / volume μ τ D) := by
      rw [Finset.sum_mul]; apply Finset.sum_congr rfl; intro k _; ring
    _ = _ := by simpa [volume, mul_comm] using short_side hQ (P := volume μ τ X)

theorem lending_conservation {n : ℕ} (μ τ D X : Fin n → ℝ)
    (hP : 0 < volume μ τ X) (hQ : 0 < volume μ τ D) :
    (∑ k, μ k * lendFraction (τ k) (volume μ τ X) (volume μ τ D) * X k) =
      min (volume μ τ X) (volume μ τ D) := by
  have hz : ¬(volume μ τ X = 0 ∨ volume μ τ D = 0) := by simp [ne_of_gt hP, ne_of_gt hQ]
  simp only [lendFraction, if_neg hz]
  calc
    _ = (∑ k, μ k*τ k*X k) * min 1 (volume μ τ D / volume μ τ X) := by
      rw [Finset.sum_mul]; apply Finset.sum_congr rfl; intro k _; ring
    _ = _ := by simpa [volume, mul_comm, min_comm] using short_side hP (P := volume μ τ D)

noncomputable def coverage (F Δ : ℝ) : ℝ := if 0 < Δ then min 1 (F/Δ) else 0

theorem zero_demand_coverage (F : ℝ) : coverage F 0 = 0 := by simp [coverage]

theorem coverage_bounds {F Δ : ℝ} (hF : 0 ≤ F) : 0 ≤ coverage F Δ ∧ coverage F Δ ≤ 1 := by
  by_cases h : 0 < Δ
  · simp only [coverage, if_pos h]
    exact ⟨le_min (by norm_num) (div_nonneg hF h.le), min_le_left _ _⟩
  · simp [coverage, h]

theorem fund_feasible {F Δ : ℝ} (hF : 0 ≤ F) (hΔ : 0 ≤ Δ) :
    coverage F Δ * Δ = min F Δ := by
  by_cases h : 0 < Δ
  · simp only [coverage, if_pos h]; exact short_side h
  · have hz : Δ=0 := le_antisymm (le_of_not_gt h) hΔ
    simp [hz, zero_demand_coverage, min_eq_right hF]

noncomputable def aggregate {n : ℕ} (μ x : Fin n → ℝ) : ℝ := ∑ k, μ k*x k
noncomputable def relative (C d Cbar D : ℝ) : ℝ := (C/d)/(Cbar/D)

theorem weighted_incidence {n : ℕ} (μ d C : Fin n → ℝ)
    (hd : ∀ k, 0 < d k) (hD : aggregate μ d ≠ 0) (hC : aggregate μ C ≠ 0) :
    (∑ k, (μ k*d k/aggregate μ d) *
      relative (C k) (d k) (aggregate μ C) (aggregate μ d)) = 1 := by
  calc
    _ = ∑ k, μ k*C k/aggregate μ C := by
      apply Finset.sum_congr rfl; intro k _
      unfold relative; field_simp [ne_of_gt (hd k), hD, hC]
    _ = (∑ k, μ k*C k)/aggregate μ C := by rw [Finset.sum_div]
    _ = 1 := div_self hC

theorem relative_scaling {F p D d C : ℝ} (hF : F ≠ 0) :
    relative (F*C) d (F*p) D = relative C d p D := by
  unfold relative; field_simp

/-- Finite-state version of Cbar = F*p_B. Zero-demand states are explicitly excluded. -/
theorem fixed_capacity_scaling {n : ℕ} (w Δ : Fin n → ℝ) (F : ℝ)
    (hr : ∀ j, 0 < Δ j → F < Δ j) :
    (∑ j, coverage F (Δ j) * Δ j * w j) =
      F * ∑ j, if 0 < Δ j then w j else 0 := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl; intro j _
  by_cases h : 0 < Δ j
  · rw [if_pos h, coverage, if_pos h,
      min_eq_right ((div_le_one h).mpr (hr j h).le)]
    field_simp
  · simp [coverage, h]


 theorem interbank_conservation_all {n : ℕ} (μ τ D X : Fin n → ℝ)
    (hP : 0 ≤ volume μ τ X) (hQ : 0 ≤ volume μ τ D) :
    (∑ k, μ k * borrowFraction (τ k) (volume μ τ X) (volume μ τ D) * D k) =
      min (volume μ τ X) (volume μ τ D) ∧
    (∑ k, μ k * lendFraction (τ k) (volume μ τ X) (volume μ τ D) * X k) =
      min (volume μ τ X) (volume μ τ D) := by
  by_cases hp : volume μ τ X = 0
  · simp [borrowFraction, lendFraction, hp, min_eq_left hQ]
  · by_cases hq : volume μ τ D = 0
    · simp [borrowFraction, lendFraction, hq, min_eq_right hP]
    · exact ⟨borrowing_conservation μ τ D X (lt_of_le_of_ne hP (Ne.symm hp)) (lt_of_le_of_ne hQ (Ne.symm hq)),
        lending_conservation μ τ D X (lt_of_le_of_ne hP (Ne.symm hp)) (lt_of_le_of_ne hQ (Ne.symm hq))⟩

/-- The economic index is undefined unless its denominators and coverage are positive. -/
noncomputable def sourceRelative (C d Cbar D : ℝ) : Option ℝ :=
  if 0 < d ∧ 0 < Cbar ∧ 0 < D then some (relative C d Cbar D) else none

 theorem sourceRelative_defined {C d Cbar D : ℝ} (hd : 0 < d) (hC : 0 < Cbar) (hD : 0 < D) :
    sourceRelative C d Cbar D = some (relative C d Cbar D) := by
  simp [sourceRelative, hd, hC, hD]

 theorem sourceRelative_zero_coverage (C d D : ℝ) : sourceRelative C d 0 D = none := by
  simp [sourceRelative]

 theorem type_coverage_scaling {m : ℕ} (w Δ N : Fin m → ℝ) (F : ℝ)
    (hr : ∀ j, 0 < Δ j → F < Δ j) :
    (∑ j, w j * coverage F (Δ j) * N j) =
      F * ∑ j, if 0 < Δ j then w j*N j/Δ j else 0 := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl; intro j _
  by_cases h : 0 < Δ j
  · rw [if_pos h, coverage, if_pos h,
      min_eq_right ((div_le_one h).mpr (hr j h).le)]
    ring
  · simp [coverage, h]

 theorem aggregate_state_coverage {n : ℕ} (μ N : Fin n → ℝ) {F : ℝ}
    (hF : 0 ≤ F) (hΔ : 0 ≤ aggregate μ N) :
    (∑ k, μ k*(coverage F (aggregate μ N)*N k)) = min F (aggregate μ N) := by
  calc
    _ = coverage F (aggregate μ N) * aggregate μ N := by
      rw [aggregate, Finset.mul_sum]
      apply Finset.sum_congr rfl; intro k _; ring
    _ = _ := fund_feasible hF hΔ

end Gomez26LiquidityBuffers
