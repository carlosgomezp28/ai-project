import Mathlib.Analysis.Convex.Deriv
import Mathlib.Topology.Order.Compact
import Mathlib.Tactic

/-! Proposition 1 optimization support. These generic calculus facts are not
claimed to establish the still-open moment-integrability and convexity bridges. -/
namespace Gomez26LiquidityBuffers
open Set

 theorem compact_buffer_minimum {J : ℝ → ℝ} {U : ℝ} (hU : 0 ≤ U)
    (hJ : ContinuousOn J (Icc 0 U)) : ∃ u ∈ Icc 0 U, IsMinOn J (Icc 0 U) u := by
  exact isCompact_Icc.exists_isMinOn (nonempty_Icc.mpr hU) hJ

 theorem convex_supporting_line {J : ℝ → ℝ} {S : Set ℝ} {x y d : ℝ}
    (hJ : ConvexOn ℝ S J) (hx : x ∈ S) (hy : y ∈ S) (hd : HasDerivAt J d x) :
    J x + d*(y-x) ≤ J y := by
  rcases lt_trichotomy x y with hxy | hxy | hyx
  · have h := hJ.le_slope_of_hasDerivAt hx hy hxy hd
    rw [slope_def_field] at h
    have hh := (le_div_iff₀ (sub_pos.mpr hxy)).mp h
    linarith
  · subst y; simp
  · have h := hJ.slope_le_of_hasDerivAt hy hx hyx hd
    rw [slope_def_field] at h
    have hh := (div_le_iff₀ (sub_pos.mpr hyx)).mp h
    nlinarith

 theorem convex_lower_corner {J : ℝ → ℝ} {U d : ℝ} (hU : 0 ≤ U)
    (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d 0) (hs : 0 ≤ d) :
    IsMinOn J (Icc 0 U) 0 := by
  intro y hy
  have h := convex_supporting_line hJ ⟨le_rfl,hU⟩ hy hd
  have hp : 0 ≤ d*y := mul_nonneg hs hy.1
  change J 0 ≤ J y
  nlinarith

 theorem convex_upper_corner {J : ℝ → ℝ} {U d : ℝ} (hU : 0 ≤ U)
    (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d U) (hs : d ≤ 0) :
    IsMinOn J (Icc 0 U) U := by
  intro y hy
  have h := convex_supporting_line hJ ⟨hU,le_rfl⟩ hy hd
  have hp : 0 ≤ d*(y-U) := mul_nonneg_of_nonpos_of_nonpos hs (sub_nonpos.mpr hy.2)
  change J U ≤ J y
  linarith

 theorem convex_stationary_global {J : ℝ → ℝ} {S : Set ℝ} {u : ℝ}
    (hJ : ConvexOn ℝ S J) (hu : u ∈ S) (hd : HasDerivAt J 0 u) :
    IsMinOn J S u := by
  intro y hy
  simpa using convex_supporting_line hJ hu hy hd

 theorem strict_lower_unique {J : ℝ → ℝ} {U d : ℝ} (hU : 0 ≤ U)
    (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d 0) (hs : 0 < d) :
    ∀ y ∈ Icc 0 U, J y = J 0 → y = 0 := by
  intro y hy he
  have h := convex_supporting_line hJ ⟨le_rfl,hU⟩ hy hd
  have hh : d*y ≤ 0 := by nlinarith
  have : y ≤ 0 := by
    by_contra hn
    have hp := mul_pos hs (lt_of_not_ge hn)
    linarith
  exact le_antisymm this hy.1

 theorem strict_upper_unique {J : ℝ → ℝ} {U d : ℝ} (hU : 0 ≤ U)
    (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d U) (hs : d < 0) :
    ∀ y ∈ Icc 0 U, J y = J U → y = U := by
  intro y hy he
  have h := convex_supporting_line hJ ⟨hU,le_rfl⟩ hy hd
  have hh : d*(y-U) ≤ 0 := by linarith
  have : 0 ≤ y-U := by
    by_contra hn
    have hp := mul_pos_of_neg_of_neg hs (lt_of_not_ge hn)
    linarith
  exact le_antisymm hy.2 (by linarith)

noncomputable def quadratic (a b c x : ℝ) : ℝ := a*x^2/2+b*x+c

 theorem quadratic_stationary_difference {a b c x s : ℝ} (hs : a*s+b=0) :
    quadratic a b c x - quadratic a b c s = a*(x-s)^2/2 := by
  unfold quadratic
  have hb : b = -a*s := by linarith
  rw [hb]; ring

 theorem quadratic_convex_stationary_min {a b c s : ℝ} (ha : 0 ≤ a) (hs : a*s+b=0) :
    ∀ x, quadratic a b c s ≤ quadratic a b c x := by
  intro x
  have h := quadratic_stationary_difference (c := c) (x := x) hs
  have hp := mul_nonneg ha (sq_nonneg (x-s))
  linarith

 theorem quadratic_flat (c x y : ℝ) : quadratic 0 0 c x = quadratic 0 0 c y := by
  simp [quadratic]


 theorem lower_corner_necessary {J : ℝ → ℝ} {U d : ℝ} (hU : 0 < U)
    (hd : HasDerivAt J d 0) (hmin : IsMinOn J (Icc 0 U) 0) : 0 ≤ d := by
  have ht : U-0 ∈ posTangentConeAt (Icc 0 U) 0 :=
    sub_mem_posTangentConeAt_of_segment_subset
      ((convex_Icc (0 : ℝ) U).segment_subset ⟨le_rfl,hU.le⟩ ⟨hU.le,le_rfl⟩)
  have hn := hmin.localize.hasFDerivWithinAt_nonneg hd.hasFDerivAt.hasFDerivWithinAt ht
  have hp : 0 ≤ U*d := by simpa using hn
  by_contra h
  have hneg := mul_neg_of_pos_of_neg hU (lt_of_not_ge h)
  linarith

 theorem upper_corner_necessary {J : ℝ → ℝ} {U d : ℝ} (hU : 0 < U)
    (hd : HasDerivAt J d U) (hmin : IsMinOn J (Icc 0 U) U) : d ≤ 0 := by
  have ht : 0-U ∈ posTangentConeAt (Icc 0 U) U :=
    sub_mem_posTangentConeAt_of_segment_subset
      ((convex_Icc (0 : ℝ) U).segment_subset ⟨hU.le,le_rfl⟩ ⟨le_rfl,hU.le⟩)
  have hn := hmin.localize.hasFDerivWithinAt_nonneg hd.hasFDerivAt.hasFDerivWithinAt ht
  have hp : 0 ≤ (0-U)*d := by simpa using hn
  by_contra h
  have hneg := mul_neg_of_neg_of_pos (show 0-U < 0 by linarith) (lt_of_not_ge h)
  linarith

 theorem convex_lower_corner_iff {J : ℝ → ℝ} {U d : ℝ} (hU : 0 < U)
    (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d 0) :
    IsMinOn J (Icc 0 U) 0 ↔ 0 ≤ d :=
  ⟨lower_corner_necessary hU hd, convex_lower_corner hU.le hJ hd⟩

 theorem convex_upper_corner_iff {J : ℝ → ℝ} {U d : ℝ} (hU : 0 < U)
    (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d U) :
    IsMinOn J (Icc 0 U) U ↔ d ≤ 0 :=
  ⟨upper_corner_necessary hU hd, convex_upper_corner hU.le hJ hd⟩

 theorem convex_interior_iff {J : ℝ → ℝ} {U u d : ℝ}
    (hu : 0 < u ∧ u < U) (hJ : ConvexOn ℝ (Icc 0 U) J) (hd : HasDerivAt J d u) :
    IsMinOn J (Icc 0 U) u ↔ d = 0 := by
  constructor
  · intro h
    exact (h.isLocalMin (Icc_mem_nhds hu.1 hu.2)).hasDerivAt_eq_zero hd
  · intro h
    subst d
    exact convex_stationary_global hJ ⟨hu.1.le,hu.2.le⟩ hd

end Gomez26LiquidityBuffers
