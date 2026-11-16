import Gomez26LiquidityBuffers.EconomicBranch
import Gomez26LiquidityBuffers.PrincipalOptimization

namespace Gomez26LiquidityBuffers
open Filter MeasureTheory Set
open scoped Topology BigOperators

/-- Strict local optimality from locally positive second derivatives; the explicit
punctured-neighborhood conclusion avoids conflating weak and strict minima. -/
theorem strict_local_minimum_from_curvature {J H : ℝ → ℝ} {u : ℝ}
    (hJ : Continuous J) (hd : ∀ x, HasDerivAt J (deriv J x) x)
    (hz : deriv J u = 0) (hc : ContinuousAt H u) (hp : 0 < H u)
    (hder : ∀ᶠ x in 𝓝 u, HasDerivAt (deriv J) (H x) x) :
    ∃ δ > 0, ∀ x ∈ Ioo (u-δ) (u+δ), x ≠ u → J u < J x := by
  have hpos : ∀ᶠ x in 𝓝 u, 0 < H x := hc.eventually (eventually_gt_nhds hp)
  obtain ⟨δ,hδ,hball⟩ := Metric.eventually_nhds_iff.mp (hpos.and hder)
  let S := Ioo (u-δ) (u+δ)
  have hu : u ∈ S := ⟨by linarith, by linarith⟩
  have hh : ∀ x ∈ S, 0 < deriv (deriv J) x := by
    intro x hx
    have hx' : dist x u < δ := by rw [Real.dist_eq]; exact abs_lt.mpr ⟨by linarith [hx.1],by linarith [hx.2]⟩
    have hh := hball hx'
    rw [hh.2.deriv]; exact hh.1
  have hsc : StrictConvexOn ℝ S J := strictConvexOn_of_deriv2_pos (convex_Ioo _ _)
    hJ.continuousOn (fun x hx => hh x (interior_subset hx))
  have hm : IsMinOn J S u := convex_stationary_global hsc.convexOn hu (hz ▸ hd u)
  refine ⟨δ,hδ,?_⟩
  intro x hx hne
  have hle := hm hx
  apply lt_of_le_of_ne hle
  intro he
  have hmx : IsMinOn J S x := fun y hy => he ▸ hm hy
  exact hne (hsc.eq_of_isMinOn hmx hm hx hu)

theorem current_curvature_continuousAt {n : ℕ} (w ψ ℓ Δ : Fin n → ℝ)
    (f : Fin n → ℝ → ℝ) (i κ F u : ℝ) (hc : ∀ j, ContinuousAt (f j) (-u)) :
    ContinuousAt (currentCurvature w ψ ℓ Δ f i κ F) u := by
  unfold currentCurvature
  apply tendsto_finset_sum
  intro j _
  exact continuousAt_const.mul ((hc j).comp continuousAt_id.neg)

theorem current_strict_local_minimum {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j))
    (f : Fin n → ℝ → ℝ)
    (hμ : ∀ j, law j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ)
    (hc : ∀ j, ContinuousAt (f j) (-u))
    (hloc : ∀ j, ∀ᶠ v in 𝓝 u, ContinuousAt (f j) (-v))
    (hz : currentMarginal law w ψ ℓ Δ r i κ F u = 0)
    (hp : 0 < currentCurvature w ψ ℓ Δ f i κ F u) :
    ∃ δ > 0, ∀ x ∈ Ioo (u-δ) (u+δ), x ≠ u →
      currentCost law w ψ ℓ Δ r i κ F u < currentCost law w ψ ℓ Δ r i κ F x := by
  have he : deriv (currentCost law w ψ ℓ Δ r i κ F) = currentMarginal law w ψ ℓ Δ r i κ F :=
    funext fun x => (current_cost_derivative law hω w ψ ℓ Δ r i κ F x).deriv
  apply strict_local_minimum_from_curvature
  · exact (current_cost_C1 law hω w ψ ℓ Δ r i κ F).continuous
  · intro x; exact (current_cost_derivative law hω w ψ ℓ Δ r i κ F x).deriv.symm ▸
      current_cost_derivative law hω w ψ ℓ Δ r i κ F x
  · simpa only [he] using hz
  · exact current_curvature_continuousAt w ψ ℓ Δ f i κ F u hc
  · exact hp
  · have hall : ∀ᶠ v in 𝓝 u, ∀ j, ContinuousAt (f j) (-v) := eventually_all.mpr hloc
    filter_upwards [hall] with v hv
    rw [he]
    exact current_marginal_density_derivative law f hμ hf hn w ψ ℓ Δ r i κ F v hv

end Gomez26LiquidityBuffers
