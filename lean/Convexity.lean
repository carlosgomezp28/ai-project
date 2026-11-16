import Gomez26LiquidityBuffers.Moments
import Gomez26LiquidityBuffers.Optimization

/-! Genuine expectation convexity and the current sufficient convexity condition.
No moment-convexity certificate is taken as an assumption. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Set
open scoped BigOperators

 theorem shortfall_convex (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) : ConvexOn ℝ univ (shortfallMoment μ) := by
  refine ⟨convex_univ, ?_⟩
  intro x _ y _ α β hα hβ hab
  simp only [smul_eq_mul]
  have hp : ∀ ω : ℝ, max (-ω-(α*x+β*y)) 0 ≤ α*max (-ω-x) 0+β*max (-ω-y) 0 := by
    intro ω
    apply max_le
    · have h1 := mul_le_mul_of_nonneg_left (le_max_left (-ω-x) 0) hα
      have h2 := mul_le_mul_of_nonneg_left (le_max_left (-ω-y) 0) hβ
      have he : -ω-(α*x+β*y)=α*(-ω-x)+β*(-ω-y) := by
        nlinarith [congrArg (fun t : ℝ => t*ω) hab]
      rw [he]; exact add_le_add h1 h2
    · exact add_nonneg (mul_nonneg hα (le_max_right _ _)) (mul_nonneg hβ (le_max_right _ _))
  unfold shortfallMoment
  calc
    _ ≤ ∫ ω, α*max (-ω-x) 0+β*max (-ω-y) 0 ∂μ :=
      integral_mono (shortfall_integrable μ hω _) (((shortfall_integrable μ hω x).const_mul α).add
        ((shortfall_integrable μ hω y).const_mul β)) hp
    _ = _ := by
      rw [integral_add ((shortfall_integrable μ hω x).const_mul α)
        ((shortfall_integrable μ hω y).const_mul β), integral_const_mul, integral_const_mul]

 theorem bank_decomposition {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w a b : Fin n → ℝ) (r u : ℝ) :
    bankObjective law w a b r u =
      (r-∑ j, w j*b j)*u + ∑ j, w j*(a j-b j)*shortfallMoment (law j) u -
        ∑ j, w j*b j*(∫ ω : ℝ, ω ∂law j) := by
  have hm : ∀ j, surplusMoment (law j) u = shortfallMoment (law j) u + (∫ ω : ℝ, ω ∂law j)+u := by
    intro j
    linarith [expected_moment_identity (law j) (hω j) u]
  unfold bankObjective
  simp_rw [hm]
  rw [sub_mul, Finset.sum_mul]
  have he : (∑ j, w j*(a j*shortfallMoment (law j) u-
      b j*(shortfallMoment (law j) u+(∫ ω : ℝ, ω ∂law j)+u))) =
      (∑ j, w j*(a j-b j)*shortfallMoment (law j) u) -
      (∑ j, w j*b j*(∫ ω : ℝ, ω ∂law j)) - (∑ j, w j*b j*u) := by
    rw [← Finset.sum_sub_distrib, ← Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl; intro j _; ring
  rw [he]; ring

 theorem bank_sufficient_convexity {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w a b : Fin n → ℝ) (r : ℝ)
    (hw : ∀ j, 0 ≤ w j) (hab : ∀ j, b j ≤ a j) :
    ConvexOn ℝ univ (bankObjective law w a b r) := by
  refine ⟨convex_univ, ?_⟩
  intro x _ y _ α β hα hβ hsum
  simp only [smul_eq_mul]
  simp_rw [bank_decomposition law hω w a b r]
  have hi : (∑ j, w j*(a j-b j)*shortfallMoment (law j) (α*x+β*y)) ≤
      α*(∑ j, w j*(a j-b j)*shortfallMoment (law j) x) +
      β*(∑ j, w j*(a j-b j)*shortfallMoment (law j) y) := by
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    apply Finset.sum_le_sum
    intro j _
    have h := (shortfall_convex (law j) (hω j)).2 (mem_univ x) (mem_univ y) hα hβ hsum
    simp only [smul_eq_mul] at h
    have hmul := mul_le_mul_of_nonneg_left h (mul_nonneg (hw j) (sub_nonneg.mpr (hab j)))
    nlinarith
  nlinarith [congrArg (fun t : ℝ => t*(∑ j, w j*b j*(∫ ω : ℝ, ω ∂law j))) hsum]

 theorem bank_global_exists {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w a b : Fin n → ℝ) (r U : ℝ)
    (hU : 0 ≤ U) : ∃ u ∈ Icc 0 U, IsMinOn (bankObjective law w a b r) (Icc 0 U) u := by
  apply compact_buffer_minimum hU
  have hc : Continuous (bankObjective law w a b r) :=
    continuous_iff_continuousAt.mpr fun u => (bank_objective_derivative law hω w a b r u).continuousAt
  exact hc.continuousOn

end Gomez26LiquidityBuffers
