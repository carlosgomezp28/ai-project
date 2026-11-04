import Mathlib.Analysis.Calculus.Deriv.Pow
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.Deriv.Comp
import Mathlib.Tactic

/-!
Scalar and finite-function companions for paper commit
cf37d3f402c04a73c832cce41f559e32348f8941.
Joint V5.1 architecture: Carlos Gómez Puicán and Fabián Méndez Suárez,
supervised by Marco Ortiz. Individual course closure: Carlos Gómez Puicán.
These are subclaims, not proofs of the complete probabilistic propositions.
-/
namespace Gomez26EligibilityBuffers
open Filter
open scoped Topology BigOperators

def feasible (q H W v : ℝ) : Prop :=
  W + v = q ∧ 0 ≤ W ∧ W ≤ min q H ∧ 0 ≤ v

def continuationCost (p g W v : ℝ) : ℝ := p * W + g * v

theorem min_add_shortfall (q H : ℝ) : min q H + max (q-H) 0 = q := by
  by_cases h : q ≤ H
  · rw [min_eq_left h, max_eq_right (by linarith : q-H ≤ 0)]
    ring
  · rw [min_eq_right (le_of_not_ge h), max_eq_left (by linarith : 0 ≤ q-H)]
    ring

theorem continuation_feasible {q H : ℝ} (hq : 0 ≤ q) (hH : 0 ≤ H) :
    feasible q H (min q H) (max (q-H) 0) := by
  exact ⟨min_add_shortfall q H, le_min hq hH, le_rfl, le_max_right _ _⟩

theorem continuation_cost_gap {q H p g W v : ℝ}
    (hf : feasible q H W v) :
    continuationCost p g W v -
      continuationCost p g (min q H) (max (q-H) 0) =
      (g-p) * (min q H-W) := by
  have hm := min_add_shortfall q H
  unfold continuationCost
  linear_combination g*hf.1 - g*hm

theorem continuation_optimal {q H p g W v : ℝ} (hgp : p < g)
    (hf : feasible q H W v) :
    continuationCost p g (min q H) (max (q-H) 0) ≤ continuationCost p g W v := by
  have hn := mul_nonneg (le_of_lt (sub_pos.mpr hgp)) (sub_nonneg.mpr hf.2.2.1)
  have hg := continuation_cost_gap (p := p) (g := g) hf
  linarith

theorem continuation_unique {q H p g W v : ℝ} (hgp : p < g)
    (hf : feasible q H W v)
    (hc : continuationCost p g W v ≤
      continuationCost p g (min q H) (max (q-H) 0)) :
    W = min q H ∧ v = max (q-H) 0 := by
  have hg := continuation_cost_gap (p := p) (g := g) hf
  have hW : W = min q H := by
    by_contra hn
    have hs : W < min q H := lt_of_le_of_ne hf.2.2.1 hn
    have hp := mul_pos (sub_pos.mpr hgp) (sub_pos.mpr hs)
    linarith
  have hm := min_add_shortfall q H
  exact ⟨hW, by linarith [hf.1]⟩

theorem continuation_solution {q H p g : ℝ} (hq : 0 ≤ q) (hH : 0 ≤ H)
    (_hp : 0 ≤ p) (hgp : p < g) :
    feasible q H (min q H) (max (q-H) 0) ∧
    (∀ W v, feasible q H W v →
      continuationCost p g (min q H) (max (q-H) 0) ≤ continuationCost p g W v) ∧
    (∀ W v, feasible q H W v →
      continuationCost p g W v ≤ continuationCost p g (min q H) (max (q-H) 0) →
      W = min q H ∧ v = max (q-H) 0) := by
  exact ⟨continuation_feasible hq hH,
    fun _ _ hf => continuation_optimal hgp hf,
    fun _ _ hf hc => continuation_unique hgp hf hc⟩

theorem positive_part_reduction {a H : ℝ} (hH : 0 ≤ H) :
    max (max a 0-H) 0 = max (a-H) 0 := by
  by_cases ha : 0 ≤ a
  · rw [max_eq_left ha]
  · rw [max_eq_right (le_of_not_ge ha)]
    rw [max_eq_right (by linarith : 0-H ≤ 0), max_eq_right (by linarith : a-H ≤ 0)]

theorem optimized_cost_identity (q H p g : ℝ) :
    continuationCost p g (min q H) (max (q-H) 0) =
      p*q + (g-p)*max (q-H) 0 := by
  have h := min_add_shortfall q H
  unfold continuationCost
  linear_combination p*h

theorem deferral_threshold {e u phi r chi U : ℝ} (hH : 0 ≤ chi*(U-u)) :
    max (max (e-u-phi*r) 0-chi*(U-u)) 0 =
      max (e-(phi*r+chi*U+(1-chi)*u)) 0 := by
  rw [positive_part_reduction hH]
  congr 1
  ring

noncomputable def ell (sigma z : ℝ) : ℝ :=
  if z ≤ -sigma then -z else if z < sigma then (sigma-z)^2/(4*sigma) else 0

noncomputable def piTail (sigma z : ℝ) : ℝ :=
  if z ≤ -sigma then 1 else if z < sigma then (sigma-z)/(2*sigma) else 0

theorem ell_lower {sigma : ℝ} (_hs : 0 < sigma) : ell sigma (-sigma) = sigma := by
  simp [ell]

theorem ell_upper {sigma : ℝ} (hs : 0 < sigma) : ell sigma sigma = 0 := by
  simp [ell, show ¬ sigma ≤ -sigma by linarith]

theorem pi_lower (sigma : ℝ) : piTail sigma (-sigma) = 1 := by simp [piTail]

theorem pi_upper {sigma : ℝ} (hs : 0 < sigma) : piTail sigma sigma = 0 := by
  simp [piTail, show ¬ sigma ≤ -sigma by linarith]

theorem uniform_joins {sigma : ℝ} (hs : 0 < sigma) :
    (sigma-(-sigma))^2/(4*sigma) = sigma ∧
    (sigma-sigma)^2/(4*sigma) = 0 ∧
    -(sigma-(-sigma))/(2*sigma) = -1 ∧
    -(sigma-sigma)/(2*sigma) = 0 := by
  have hn : sigma ≠ 0 := ne_of_gt hs
  constructor
  · field_simp
    ring
  constructor
  · simp
  constructor
  · field_simp
    ring
  · simp

theorem ell_derivative_below {sigma z : ℝ} (hz : z < -sigma) :
    HasDerivAt (ell sigma) (-1) z := by
  apply (hasDerivAt_id z).neg.congr_of_eventuallyEq
  filter_upwards [eventually_lt_nhds hz] with x hx
  simp [ell, le_of_lt hx]

theorem ell_derivative_inside {sigma z : ℝ} (hs : 0 < sigma)
    (hl : -sigma < z) (hu : z < sigma) :
    HasDerivAt (ell sigma) (-(sigma-z)/(2*sigma)) z := by
  have hd := (((hasDerivAt_const z sigma).sub (hasDerivAt_id z)).pow 2).div_const (4*sigma)
  have he : (2*(sigma-z)^(2-1)*(0-1))/(4*sigma) = -(sigma-z)/(2*sigma) := by
    field_simp
    ring
  have hd' : HasDerivAt (fun x : ℝ => (sigma-x)^2/(4*sigma))
      (-(sigma-z)/(2*sigma)) z := by convert hd using 1; simpa using he.symm
  apply hd'.congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hl, eventually_lt_nhds hu] with x hx1 hx2
  simp [ell, not_le.mpr hx1, hx2]

theorem ell_derivative_above {sigma z : ℝ} (hs : 0 < sigma) (hz : sigma < z) :
    HasDerivAt (ell sigma) 0 z := by
  apply (hasDerivAt_const z (0 : ℝ)).congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hz] with x hx
  have hn : ¬ x ≤ -sigma := by linarith
  simp [ell, hn, not_lt.mpr (le_of_lt hx)]

theorem ell_derivative {sigma z : ℝ} (hs : 0 < sigma)
    (hnl : z ≠ -sigma) (hnu : z ≠ sigma) :
    HasDerivAt (ell sigma) (-piTail sigma z) z := by
  by_cases hl : z ≤ -sigma
  · simpa [piTail, hl] using ell_derivative_below (lt_of_le_of_ne hl hnl)
  · by_cases hu : z < sigma
    · simp only [piTail, if_neg hl, if_pos hu]
      convert ell_derivative_inside hs (lt_of_not_ge hl) hu using 1; ring
    · simpa [piTail, hl, hu] using
        ell_derivative_above hs (lt_of_le_of_ne (le_of_not_gt hu) hnu.symm)

theorem ell_second_inside {sigma z : ℝ} (hs : 0 < sigma)
    (hl : -sigma < z) (hu : z < sigma) :
    HasDerivAt (deriv (ell sigma)) (1/(2*sigma)) z := by
  have hd := (((hasDerivAt_const z sigma).sub (hasDerivAt_id z)).neg).div_const (2*sigma)
  have hd' : HasDerivAt (fun x : ℝ => -(sigma-x)/(2*sigma)) (1/(2*sigma)) z := by
    simpa using hd
  apply hd'.congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hl, eventually_lt_nhds hu] with x hx1 hx2
  exact (ell_derivative_inside hs hx1 hx2).deriv

theorem ell_second_below {sigma z : ℝ} (hz : z < -sigma) :
    HasDerivAt (deriv (ell sigma)) 0 z := by
  apply (hasDerivAt_const z (-1 : ℝ)).congr_of_eventuallyEq
  filter_upwards [eventually_lt_nhds hz] with x hx
  exact (ell_derivative_below hx).deriv

theorem ell_second_above {sigma z : ℝ} (hs : 0 < sigma) (hz : sigma < z) :
    HasDerivAt (deriv (ell sigma)) 0 z := by
  apply (hasDerivAt_const z (0 : ℝ)).congr_of_eventuallyEq
  filter_upwards [eventually_gt_nhds hz] with x hx
  exact (ell_derivative_above hs hx).deriv

theorem uniform_curvature_nonneg {sigma : ℝ} (hs : 0 < sigma) :
    0 ≤ 1/(2*sigma) := by positivity

-- Algebraic companion only: the differentiated FOC is an explicit premise.
theorem implicit_response {Gu Gr response : ℝ} (hu : Gu ≠ 0)
    (hchain : Gu*response+Gr=0) : response = -Gr/Gu := by
  apply (eq_div_iff hu).mpr
  nlinarith

noncomputable def curvature (p g chi f1 f2 : ℝ) : ℝ :=
  p*f1+(g-p)*(1-chi)^2*f2

noncomputable def reserveNumerator (p g phi chi f1 f2 : ℝ) : ℝ :=
  p*phi*f1+(g-p)*(1-chi)*(phi-chi)*f2

theorem curvature_nonneg {p g chi f1 f2 : ℝ} (hp : 0 ≤ p) (hgp : p ≤ g)
    (hf1 : 0 ≤ f1) (hf2 : 0 ≤ f2) : 0 ≤ curvature p g chi f1 f2 := by
  unfold curvature
  exact add_nonneg (mul_nonneg hp hf1)
    (mul_nonneg (mul_nonneg (sub_nonneg.mpr hgp) (sq_nonneg (1-chi))) hf2)

theorem reserve_response_nonpos {p g phi chi f1 f2 response : ℝ}
    (hp : 0 ≤ p) (hgp : p < g) (hc0 : 0 ≤ chi) (hc1 : chi < 1)
    (hphi : chi ≤ phi) (hf1 : 0 ≤ f1) (hf2 : 0 ≤ f2)
    (hGu : 0 < curvature p g chi f1 f2)
    (hchain : curvature p g chi f1 f2*response + reserveNumerator p g phi chi f1 f2=0) :
    response ≤ 0 := by
  have hp0 : 0 ≤ phi := le_trans hc0 hphi
  have hn : 0 ≤ reserveNumerator p g phi chi f1 f2 := by
    unfold reserveNumerator
    exact add_nonneg (mul_nonneg (mul_nonneg hp hp0) hf1)
      (mul_nonneg (mul_nonneg (mul_nonneg (sub_nonneg.mpr (le_of_lt hgp))
        (sub_nonneg.mpr (le_of_lt hc1))) (sub_nonneg.mpr hphi)) hf2)
  have hr := implicit_response (ne_of_gt hGu) hchain
  rw [hr]
  exact div_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hn) (le_of_lt hGu)

end Gomez26EligibilityBuffers
