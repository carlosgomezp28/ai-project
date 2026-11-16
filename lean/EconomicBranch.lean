import Gomez26LiquidityBuffers.DensityCurvature
import Gomez26LiquidityBuffers.SourceInstance
import Gomez26LiquidityBuffers.StationaryBranch

namespace Gomez26LiquidityBuffers
open Filter MeasureTheory Set
open scoped Topology BigOperators

theorem coverage_C1_at {F Δ : ℝ} (hreg : 0 < Δ → F ≠ Δ) :
    ContDiffAt ℝ 1 (fun x => coverage x Δ) F := by
  by_cases hΔ : 0 < Δ
  · by_cases hF : F < Δ
    · apply (contDiffAt_id.div_const Δ).congr_of_eventuallyEq
      filter_upwards [eventually_lt_nhds hF] with x hx
      simp [coverage, hΔ, min_eq_right ((div_le_one hΔ).mpr hx.le)]
    · have hx : Δ < F := lt_of_le_of_ne (le_of_not_gt hF) (hreg hΔ).symm
      apply (contDiffAt_const (c := (1 : ℝ))).congr_of_eventuallyEq
      filter_upwards [eventually_gt_nhds hx] with x hy
      simp [coverage, hΔ, min_eq_left ((one_le_div hΔ).mpr hy.le)]
  · simpa [coverage,hΔ] using (contDiffAt_const (c := (0 : ℝ)) :
      ContDiffAt ℝ 1 (fun _ : ℝ => (0 : ℝ)) F)

theorem deficitCoefficient_C1_at (i κ ψ Δ F : ℝ) (hreg : 0 < Δ → F ≠ Δ) :
    ContDiffAt ℝ 1 (deficitCoefficient i κ ψ Δ) F := by
  exact contDiffAt_const.add ((contDiffAt_const.mul (contDiffAt_const.sub (coverage_C1_at hreg))).mul contDiffAt_const)

/-- Joint smoothness is derived from the actual probabilities and actual coverage rules. -/
theorem current_marginal_joint_C1 {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (f : Fin n → ℝ → ℝ)
    (hμ : ∀ j, law j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ)
    (hc : ∀ j, ContinuousAt (f j) (-u))
    (hloc : ∀ j, ∀ᶠ v in 𝓝 u, ContinuousAt (f j) (-v))
    (hreg : ∀ j, 0 < Δ j → F ≠ Δ j) :
    ContDiffAt ℝ 1 (fun z : ℝ×ℝ => currentMarginal law w ψ ℓ Δ r i κ z.1 z.2) (F,u) := by
  apply contDiffAt_const.sub
  apply ContDiffAt.sum
  intro j _
  have ha := (deficitCoefficient_C1_at i κ (ψ j) (Δ j) F (hreg j)).comp (F,u) contDiffAt_fst
  have hm := (shortfall_probability_C1_at (law j) (f j) (hμ j) (hf j) (hn j) u (hc j) (hloc j)).comp (F,u) contDiffAt_snd
  have hp := (surplus_probability_C1_at (law j) (f j) (hμ j) (hf j) (hn j) u (hc j) (hloc j)).comp (F,u) contDiffAt_snd
  exact contDiffAt_const.mul ((ha.mul hm).add (contDiffAt_const.mul hp))

/-- A scalar IFT helper. The branch is constructed, not supplied as a hypothesis. -/
theorem scalar_stationary_branch (G : ℝ×ℝ → ℝ) (F u N H : ℝ)
    (hz : G (F,u) = 0) (hc : ContDiffAt ℝ 1 G (F,u))
    (hF : HasDerivAt (fun x => G (x,u)) N F)
    (hu : HasDerivAt (fun x => G (F,x)) H u) (hH : 0 < H) :
    ∃ b : ℝ → ℝ, b F = u ∧ ContDiffAt ℝ 1 b F ∧
      (∀ᶠ x in 𝓝 F, G (x,b x)=0) ∧ HasDerivAt b (-N/H) F := by
  let L := fderiv ℝ G (F,u)
  let V := L.comp (ContinuousLinearMap.inr ℝ ℝ ℝ)
  let K := L.comp (ContinuousLinearMap.inl ℝ ℝ ℝ)
  have hv : V = H • ContinuousLinearMap.id ℝ ℝ := by
    have hh := hc.differentiableAt (by norm_num) |>.hasFDerivAt
    have emb : HasFDerivAt (fun x : ℝ => (F,x)) (ContinuousLinearMap.inr ℝ ℝ ℝ) u := by
      convert (hasFDerivAt_const F u).prodMk (hasFDerivAt_id u) using 1
    have hvv := hh.comp u emb
    have hh' : HasFDerivAt (fun x => G (F,x)) V u := by simpa [V,L] using hvv
    convert hh'.unique hu.hasFDerivAt using 1 <;> ext <;> simp
  have hk : K = N • ContinuousLinearMap.id ℝ ℝ := by
    have hh := hc.differentiableAt (by norm_num) |>.hasFDerivAt
    have emb : HasFDerivAt (fun x : ℝ => (x,u)) (ContinuousLinearMap.inl ℝ ℝ ℝ) F := by
      convert (hasFDerivAt_id F).prodMk (hasFDerivAt_const u F) using 1
    have hkk := hh.comp F emb
    have hh' : HasFDerivAt (fun x => G (x,u)) K F := by simpa [K,L] using hkk
    convert hh'.unique hF.hasFDerivAt using 1 <;> ext <;> simp
  let inv : ℝ →L[ℝ] ℝ := (1/H) • ContinuousLinearMap.id ℝ ℝ
  have hr : V.comp inv = ContinuousLinearMap.id ℝ ℝ := by
    rw [hv]; ext; simp [inv]; field_simp [hH.ne']
  have hl : inv.comp V = ContinuousLinearMap.id ℝ ℝ := by
    rw [hv]; ext; simp [inv]; field_simp [hH.ne']
  have hi : V.IsInvertible := ContinuousLinearMap.IsInvertible.of_inverse hr hl
  obtain ⟨b,hb,hbc,hbz,hbd⟩ := stationary_branch_from_C1 G F u hz hc hi
  refine ⟨b,hb,hbc,hbz,?_⟩
  have he : ((-V.inverse).comp K) = (-N/H) • ContinuousLinearMap.id ℝ ℝ := by
    rw [ContinuousLinearMap.inverse_eq hr hl,hk]
    ext; simp [inv]; ring
  have hh : HasFDerivAt b ((-N/H) • ContinuousLinearMap.id ℝ ℝ) F := by
    simpa only [← he] using hbd
  convert hh.hasDerivAt using 1 <;> simp

/-- The IFT and scalar response for the current economic marginal. This theorem
constructs a stationary branch; it does not assert global optimizer continuation. -/
theorem current_stationary_branch {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (f : Fin n → ℝ → ℝ)
    (hμ : ∀ j, law j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ)
    (hc : ∀ j, ContinuousAt (f j) (-u))
    (hloc : ∀ j, ∀ᶠ v in 𝓝 u, ContinuousAt (f j) (-v))
    (hreg : ∀ j, 0 < Δ j → F ≠ Δ j)
    (hz : currentMarginal law w ψ ℓ Δ r i κ F u = 0)
    (hH : 0 < currentCurvature w ψ ℓ Δ f i κ F u) :
    ∃ b : ℝ → ℝ, b F = u ∧ ContDiffAt ℝ 1 b F ∧
      (∀ᶠ x in 𝓝 F, currentMarginal law w ψ ℓ Δ r i κ x (b x)=0) ∧
      HasDerivAt b (-capacityNumerator w ψ Δ (fun j => shortfallProbability (law j) u) κ F /
        currentCurvature w ψ ℓ Δ f i κ F u) F := by
  apply scalar_stationary_branch (fun z : ℝ×ℝ => currentMarginal law w ψ ℓ Δ r i κ z.1 z.2)
    F u _ _ hz (current_marginal_joint_C1 law f hμ hf hn w ψ ℓ Δ r i κ F u hc hloc hreg)
  · exact frozenMarginal_capacity_derivative w ψ ℓ Δ
      (fun j => shortfallProbability (law j) u) (fun j => surplusProbability (law j) u) r i κ F hreg
  · exact current_marginal_density_derivative law f hμ hf hn w ψ ℓ Δ r i κ F u hc
  · exact hH

end Gomez26LiquidityBuffers
