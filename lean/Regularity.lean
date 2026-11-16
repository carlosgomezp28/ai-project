import Gomez26LiquidityBuffers.CurrentModel
import Mathlib.Analysis.Calculus.ContDiff.Deriv

/-! Proposition 1: continuous probabilities and continuous first differentiability
from atomlessness, not an assumed continuous marginal. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Filter Set
open scoped Topology BigOperators

 theorem surplus_probability_integral (μ : Measure ℝ) [IsProbabilityMeasure μ] (u : ℝ) :
    surplusProbability μ u = ∫ ω : ℝ, (if 0 < ω+u then (1 : ℝ) else 0) ∂μ := by
  have hm : MeasurableSet {ω : ℝ | 0 < ω+u} :=
    measurableSet_lt measurable_const (measurable_id.add_const u)
  symm
  simpa [surplusProbability, Set.indicator] using (integral_indicator_one (μ := μ) hm)

 theorem surplus_probability_continuous (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ] :
    Continuous (surplusProbability μ) := by
  apply continuous_iff_continuousAt.mpr
  intro u
  let H : ℝ → ℝ → ℝ := fun x ω => if 0 < ω+x then 1 else 0
  have hm : ∀ᶠ x in 𝓝 u, AEStronglyMeasurable (H x) μ := by
    filter_upwards [] with x
    exact (Measurable.ite (measurableSet_lt measurable_const (measurable_id.add_const x))
      measurable_const measurable_const).aestronglyMeasurable
  have hb : ∀ᶠ x in 𝓝 u, ∀ᵐ ω ∂μ, ‖H x ω‖ ≤ (1 : ℝ) := by
    filter_upwards [] with x
    filter_upwards [] with ω
    dsimp [H]; split_ifs <;> norm_num
  have hae : ∀ᵐ ω : ℝ ∂μ, ω ≠ -u := ae_iff.mpr (by simp)
  have hc : ∀ᵐ ω ∂μ, ContinuousAt (fun x => H x ω) u := by
    filter_upwards [hae] with ω hn
    by_cases h : 0 < ω+u
    · apply (continuousAt_const : ContinuousAt (fun _ : ℝ => (1 : ℝ)) u).congr_of_eventuallyEq
      filter_upwards [eventually_gt_nhds (show -ω < u by linarith)] with x hx
      simp [H, show 0 < ω+x by linarith]
    · have hs : ω+u < 0 := lt_of_le_of_ne (le_of_not_gt h) (by intro he; apply hn; linarith)
      apply (continuousAt_const : ContinuousAt (fun _ : ℝ => (0 : ℝ)) u).congr_of_eventuallyEq
      filter_upwards [eventually_lt_nhds (show u < -ω by linarith)] with x hx
      simp [H, show ¬0 < ω+x by linarith]
  have h := continuousAt_of_dominated (μ := μ) (F := H) hm hb (integrable_const 1) hc
  have he : surplusProbability μ = fun x => ∫ ω, H x ω ∂μ :=
    funext fun x => surplus_probability_integral μ x
  rw [he]; exact h

 theorem shortfall_probability_continuous (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ] :
    Continuous (shortfallProbability μ) := by
  have he : shortfallProbability μ = fun u => 1-surplusProbability μ u := by
    funext u; linarith [probability_partition μ u]
  rw [he]; exact continuous_const.sub (surplus_probability_continuous μ)

 theorem current_marginal_continuous {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F : ℝ) :
    Continuous (currentMarginal law w ψ ℓ Δ r i κ F) := by
  unfold currentMarginal bankMarginal
  apply Continuous.sub continuous_const
  apply continuous_finset_sum
  intro j _
  exact continuous_const.mul ((continuous_const.mul (shortfall_probability_continuous (law j))).add
    (continuous_const.mul (surplus_probability_continuous (law j))))

 theorem current_cost_C1 {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F : ℝ) : ContDiff ℝ 1 (currentCost law w ψ ℓ Δ r i κ F) := by
  apply contDiff_one_iff_deriv.mpr
  refine ⟨fun u => (current_cost_derivative law hω w ψ ℓ Δ r i κ F u).differentiableAt, ?_⟩
  have he : deriv (currentCost law w ψ ℓ Δ r i κ F) = currentMarginal law w ψ ℓ Δ r i κ F :=
    funext fun u => (current_cost_derivative law hω w ψ ℓ Δ r i κ F u).deriv
  rw [he]; exact current_marginal_continuous law w ψ ℓ Δ r i κ F

end Gomez26LiquidityBuffers
