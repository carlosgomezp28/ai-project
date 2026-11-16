import Gomez26LiquidityBuffers.SourceInstance
import Gomez26LiquidityBuffers.DensityCurvature

namespace Gomez26LiquidityBuffers
open Set MeasureTheory
open scoped BigOperators

/-- Global convexity plus positive curvature at an interior stationary point implies
uniqueness. Global strict convexity is not assumed. -/
theorem convex_positive_curvature_unique {J : ℝ → ℝ} {U u H : ℝ}
    (hu : 0 < u ∧ u < U) (hcv : ConvexOn ℝ (Icc 0 U) J)
    (hd : ∀ x, HasDerivAt J (deriv J x) x) (hzero : deriv J u = 0)
    (hH : HasDerivAt (deriv J) H u) (hpos : 0 < H) :
    ∀ y ∈ Icc 0 U, J y = J u → y = u := by
  have hmin := convex_stationary_global hcv ⟨hu.1.le,hu.2.le⟩ (hzero ▸ hd u)
  let T := {x : ℝ | x ∈ Ioo 0 U ∧ J x ≤ J u}
  have hT : Convex ℝ T := by
    have he : T = Ioo 0 U ∩ {x ∈ Icc 0 U | J x ≤ J u} := by
      ext x; simp only [T, mem_setOf_eq, mem_inter_iff, mem_Ioo, mem_Icc]
      constructor
      · rintro ⟨hx,hj⟩; exact ⟨hx,⟨hx.1.le,hx.2.le⟩,hj⟩
      · rintro ⟨hx,_,hj⟩; exact ⟨hx,hj⟩
    rw [he]; exact (convex_Ioo (0 : ℝ) U).inter (hcv.convex_le _)
  have huT : u ∈ T := ⟨hu,le_rfl⟩
  have hz : ∀ x ∈ T, deriv J x = 0 := by
    intro x hx
    have hm : IsMinOn J (Icc 0 U) x := fun y hy => (hx.2).trans (hmin hy)
    exact (hm.isLocalMin (Icc_mem_nhds hx.1.1 hx.1.2)).hasDerivAt_eq_zero (hd x)
  intro y hy he
  let z := (u+y)/2
  have hzT : z ∈ T := by
    refine ⟨⟨by dsimp [z]; linarith [hy.1], by dsimp [z]; linarith [hy.2]⟩, ?_⟩
    have hh := hcv.2 ⟨hu.1.le,hu.2.le⟩ hy (by norm_num : (0:ℝ) ≤ 1/2)
      (by norm_num : (0:ℝ) ≤ 1/2) (by norm_num : (1:ℝ)/2+1/2=1)
    simp only [smul_eq_mul, he] at hh
    have hez : (1:ℝ)/2*u+1/2*y=z := by dsimp [z]; ring
    rw [hez] at hh
    linarith
  have ht : z-u ∈ posTangentConeAt T u :=
    sub_mem_posTangentConeAt_of_segment_subset (hT.segment_subset huT hzT)
  have hm : IsMinOn (deriv J) T u := by
    intro x hx
    change deriv J u ≤ deriv J x
    rw [hzero,hz x hx]
  have hM : IsMaxOn (deriv J) T u := by
    intro x hx
    change deriv J x ≤ deriv J u
    rw [hzero,hz x hx]
  have hn := hm.localize.hasFDerivWithinAt_nonneg hH.hasFDerivAt.hasFDerivWithinAt ht
  have hp := hM.localize.hasFDerivWithinAt_nonpos hH.hasFDerivAt.hasFDerivWithinAt ht
  have heq : (z-u)*H = 0 := by
    apply le_antisymm
    · simpa using hp
    · simpa using hn
  have hzu : z-u=0 := (mul_eq_zero.mp heq).resolve_right hpos.ne'
  dsimp [z] at hzu; linarith

namespace SourceInstance
variable {m : ℕ} (s : SourceInstance m)

theorem objective_convex (k : Fin 2) (F : ℝ) (hc : ∀ j, s.b k j ≤ s.a k j F) :
    ConvexOn ℝ Set.univ (s.objective k F) :=
  current_sufficient_convexity (s.law k) (s.law_first_moment k) s.w
    (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F (fun j => (s.w_pos j).le) hc

theorem lower_corner_iff (k : Fin 2) (F : ℝ)
    (hc : ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F)) :
    IsMinOn (s.objective k F) (Icc 0 (s.U k)) 0 ↔ 0 ≤ s.marginal k F 0 :=
  convex_lower_corner_iff (s.U_pos k) hc (s.objective_derivative k F 0)

theorem upper_corner_iff (k : Fin 2) (F : ℝ)
    (hc : ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F)) :
    IsMinOn (s.objective k F) (Icc 0 (s.U k)) (s.U k) ↔ s.marginal k F (s.U k) ≤ 0 :=
  convex_upper_corner_iff (s.U_pos k) hc (s.objective_derivative k F (s.U k))

theorem interior_iff (k : Fin 2) (F u : ℝ) (hu : 0 < u ∧ u < s.U k)
    (hc : ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F)) :
    IsMinOn (s.objective k F) (Icc 0 (s.U k)) u ↔ s.marginal k F u = 0 :=
  convex_interior_iff hu hc (s.objective_derivative k F u)

theorem density_curvature (k : Fin 2) (F u : ℝ) (f : Fin m → ℝ → ℝ)
    (hμ : ∀ j, s.law k j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (hc : ∀ j, ContinuousAt (f j) (-u)) :
    deriv (deriv (s.objective k F)) u =
      currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u :=
  current_cost_density_curvature (s.law k) (s.law_first_moment k) f hμ hf hn
    s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u hc

theorem positive_curvature_unique (k : Fin 2) (F u : ℝ) (f : Fin m → ℝ → ℝ)
    (hμ : ∀ j, s.law k j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (hc : ∀ j, ContinuousAt (f j) (-u)) (hu : 0 < u ∧ u < s.U k)
    (hcv : ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F))
    (hz : s.marginal k F u = 0)
    (hpos : 0 < currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u) :
    IsMinOn (s.objective k F) (Icc 0 (s.U k)) u ∧
      ∀ y ∈ Icc 0 (s.U k), s.objective k F y = s.objective k F u → y = u := by
  have he : deriv (s.objective k F) = s.marginal k F :=
    funext fun x => (s.objective_derivative k F x).deriv
  refine ⟨(s.interior_iff k F u hu hcv).mpr hz, ?_⟩
  apply convex_positive_curvature_unique hu hcv
  · intro x; simpa only [he] using s.objective_derivative k F x
  · simpa only [he] using hz
  · rw [he]
    exact current_marginal_density_derivative (s.law k) f hμ hf hn
      s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u hc
  · exact hpos

theorem strict_lower_unique (k : Fin 2) (F : ℝ)
    (hc : ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F)) (hp : 0 < s.marginal k F 0) :
    ∀ y ∈ Icc 0 (s.U k), s.objective k F y = s.objective k F 0 → y = 0 :=
  Gomez26LiquidityBuffers.strict_lower_unique (s.U_pos k).le hc (s.objective_derivative k F 0) hp

theorem strict_upper_unique (k : Fin 2) (F : ℝ)
    (hc : ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F)) (hp : s.marginal k F (s.U k) < 0) :
    ∀ y ∈ Icc 0 (s.U k), s.objective k F y = s.objective k F (s.U k) → y = s.U k :=
  Gomez26LiquidityBuffers.strict_upper_unique (s.U_pos k).le hc (s.objective_derivative k F (s.U k)) hp

end SourceInstance
end Gomez26LiquidityBuffers
