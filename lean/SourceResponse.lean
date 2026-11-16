import Gomez26LiquidityBuffers.LocalMinimum

namespace Gomez26LiquidityBuffers
open Filter MeasureTheory Set
open scoped Topology BigOperators

theorem current_curvature_joint_continuousAt {n : ℕ} (w ψ ℓ Δ : Fin n → ℝ)
    (f : Fin n → ℝ → ℝ) (i κ F u : ℝ) (hc : ∀ j, ContinuousAt (f j) (-u))
    (hreg : ∀ j, 0 < Δ j → F ≠ Δ j) :
    ContinuousAt (fun z : ℝ×ℝ => currentCurvature w ψ ℓ Δ f i κ z.1 z.2) (F,u) := by
  unfold currentCurvature
  apply tendsto_finset_sum
  intro j _
  have ha : ContinuousAt (fun z : ℝ×ℝ => deficitCoefficient i κ (ψ j) (Δ j) z.1) (F,u) :=
    ContinuousAt.comp (f := fun z : ℝ×ℝ => z.1) (g := deficitCoefficient i κ (ψ j) (Δ j))
      (deficitCoefficient_C1_at i κ (ψ j) (Δ j) F (hreg j)).continuousAt continuousAt_fst
  exact (continuousAt_const.mul (ha.sub continuousAt_const)).mul ((hc j).comp (f := fun z : ℝ×ℝ => -z.2) continuousAt_snd.neg)

namespace SourceInstance
variable {m : ℕ} (s : SourceInstance m)

/-- Current economic IFT, base-point response/sign, and persistence of strict interior
local minima. Compact-gap global continuation is deliberately absent. -/
theorem capacity_branch (k : Fin 2) (F u : ℝ) (f : Fin m → ℝ → ℝ)
    (hμ : ∀ j, s.law k j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (hc : ∀ j, ContinuousAt (f j) (-u))
    (hloc : ∀ j, ∀ᶠ v in 𝓝 u, ContinuousAt (f j) (-v))
    (hreg : ∀ j, 0 < s.Δ j → F ≠ s.Δ j) (hF : 0 < F)
    (hu : 0 < u ∧ u < s.U k) (hz : s.marginal k F u = 0)
    (hH : 0 < currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u) :
    ∃ b : ℝ → ℝ, b F = u ∧ ContDiffAt ℝ 1 b F ∧
      (∀ᶠ x in 𝓝 F, s.marginal k x (b x)=0) ∧
      HasDerivAt b (-capacityNumerator s.w (s.ψ k) s.Δ
        (fun j => shortfallProbability (s.law k j) u) s.κ F /
        currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u) F ∧
      deriv b F ≤ 0 ∧
      (deriv b F < 0 ↔ ∃ j, 0 < F ∧ F < s.Δ j ∧ s.ψ k j < 1 ∧
        0 < shortfallProbability (s.law k j) u) ∧
      (∀ᶠ x in 𝓝 F, 0 < b x ∧ b x < s.U k ∧
        ∃ δ > 0, ∀ v ∈ Ioo (b x-δ) (b x+δ), v ≠ b x →
          s.objective k x (b x) < s.objective k x v) := by
  obtain ⟨b,hb,hbc,hbz,hbd⟩ := current_stationary_branch (s.law k) f hμ hf hn
    s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u hc hloc hreg hz hH
  have hκ : 0 < s.κ := lt_of_le_of_lt s.i_nonneg s.κ_gt_i
  have hπ : ∀ j, 0 ≤ shortfallProbability (s.law k j) u := fun j => ENNReal.toReal_nonneg
  have hN := capacityNumerator_nonneg (F := F) s.w (s.ψ k) s.Δ _ hκ.le
    (fun j => (s.w_pos j).le) (fun j => (s.ψ_bounds k j).2) hπ
  refine ⟨b,hb,hbc,hbz,hbd,?_,?_,?_⟩
  · rw [hbd.deriv]; exact capacity_response_nonpos hN hH
  · rw [hbd.deriv, capacity_response_strict hH,
      capacityNumerator_positive_iff (F := F) s.w (s.ψ k) s.Δ _ hκ s.w_pos (fun j => (s.ψ_bounds k j).2) hπ]
    constructor
    · rintro ⟨j,_,hj,hψ,hπ⟩; exact ⟨j,hF,hj,hψ,hπ⟩
    · rintro ⟨j,_,hj,hψ,hπ⟩; exact ⟨j,lt_trans hF hj,hj,hψ,hπ⟩
  · have hbu : ContinuousAt b F := hbc.continuousAt
    have hevu : ∀ᶠ x in 𝓝 F, b x ∈ Ioo 0 (s.U k) :=
      hbu.eventually (by rw [hb]; exact Ioo_mem_nhds hu.1 hu.2)
    let T := {v : ℝ | ∀ j, ContinuousAt (f j) (-v)}
    have hTu : T ∈ 𝓝 u := eventually_all.mpr hloc
    have huT : u ∈ interior T := mem_interior_iff_mem_nhds.mpr hTu
    have hevT : ∀ᶠ x in 𝓝 F, b x ∈ interior T :=
      hbu.eventually (by rw [hb]; exact isOpen_interior.mem_nhds huT)
    have hcur : ContinuousAt (fun x => currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ x (b x)) F := by
      have hh := current_curvature_joint_continuousAt s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u hc hreg
      have hc' : ContinuousAt (fun x => (x,b x)) F := continuousAt_id.prodMk hbu
      have hh' : ContinuousAt (fun z : ℝ×ℝ => currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ z.1 z.2) (F,b F) := by
        simpa only [hb] using hh
      exact ContinuousAt.comp (f := fun x : ℝ => (x,b x))
        (g := fun z : ℝ×ℝ => currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ z.1 z.2) hh' hc'
    have hevH : ∀ᶠ x in 𝓝 F, 0 < currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ x (b x) :=
      hcur.eventually (eventually_gt_nhds (by simpa only [hb] using hH))
    filter_upwards [hevu,hevT,hevH,hbz] with x hx hT hpos hzero
    refine ⟨hx.1,hx.2,?_⟩
    have hc' : ∀ j, ContinuousAt (f j) (-(b x)) := interior_subset hT
    have hl' : ∀ j, ∀ᶠ v in 𝓝 (b x), ContinuousAt (f j) (-v) := by
      intro j
      have ht : ∀ᶠ v in 𝓝 (b x), ∀ j, ContinuousAt (f j) (-v) := mem_interior_iff_mem_nhds.mp hT
      exact ht.mono (fun v hv => hv j)
    exact current_strict_local_minimum (s.law k) (s.law_first_moment k) f hμ hf hn
      s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ x (b x) hc' hl' hzero hpos

end SourceInstance
end Gomez26LiquidityBuffers
