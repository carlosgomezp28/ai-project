import Gomez26LiquidityBuffers.Accounting
import Mathlib.Analysis.Calculus.ParametricIntegral
import Mathlib.MeasureTheory.Measure.Typeclasses.NoAtoms
import Mathlib.Tactic

/-! Actual probability moments for the current model, equations (2), (8), (10).
These are integrals against a probability law on signed liquidity flows. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Filter Set
open scoped Topology

noncomputable def surplusMoment (μ : Measure ℝ) (u : ℝ) : ℝ := ∫ ω, max (ω+u) 0 ∂μ
noncomputable def shortfallMoment (μ : Measure ℝ) (u : ℝ) : ℝ := ∫ ω, max (-ω-u) 0 ∂μ
noncomputable def surplusProbability (μ : Measure ℝ) (u : ℝ) : ℝ := μ.real {ω | 0 < ω+u}

 theorem surplus_integrable (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) (u : ℝ) :
    Integrable (fun ω => max (ω+u) 0) μ := by
  exact (hω.add (integrable_const u)).pos_part

 theorem shortfall_integrable (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) (u : ℝ) :
    Integrable (fun ω => max (-ω-u) 0) μ := by
  exact (hω.neg.sub (integrable_const u)).pos_part

 theorem expected_moment_identity (μ : Measure ℝ) [IsProbabilityMeasure μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) (u : ℝ) :
    surplusMoment μ u - shortfallMoment μ u = (∫ ω : ℝ, ω ∂μ) + u := by
  unfold surplusMoment shortfallMoment
  rw [← integral_sub (surplus_integrable μ hω u) (shortfall_integrable μ hω u)]
  have he : (fun ω : ℝ => max (ω+u) 0 - max (-ω-u) 0) = (fun ω => ω+u) := by
    funext ω
    by_cases h : 0 ≤ ω+u
    · rw [max_eq_left h, max_eq_right (by linarith : -ω-u ≤ 0)]; ring
    · rw [max_eq_right (le_of_not_ge h), max_eq_left (by linarith : 0 ≤ -ω-u)]; ring
  rw [he, integral_add hω (integrable_const u)]
  simp

 theorem positive_part_derivative (ω u : ℝ) (hn : ω+u ≠ 0) :
    HasDerivAt (fun x => max (ω+x) 0) (if 0 < ω+u then 1 else 0) u := by
  by_cases h : 0 < ω+u
  · simp only [if_pos h]
    apply ((hasDerivAt_id u).const_add ω).congr_of_eventuallyEq
    filter_upwards [eventually_gt_nhds (show -ω < u by linarith)] with x hx
    simp [max_eq_left (show 0 ≤ ω+x by linarith)]
  · simp only [if_neg h]
    have hs : ω+u < 0 := lt_of_le_of_ne (le_of_not_gt h) hn
    apply (hasDerivAt_const u (0 : ℝ)).congr_of_eventuallyEq
    filter_upwards [eventually_lt_nhds (show u < -ω by linarith)] with x hx
    simp [max_eq_right (show ω+x ≤ 0 by linarith)]

 theorem surplus_moment_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) (u : ℝ) :
    HasDerivAt (surplusMoment μ) (surplusProbability μ u) u := by
  let F : ℝ → ℝ → ℝ := fun x ω => max (ω+x) 0
  let F' : ℝ → ℝ := fun ω => if 0 < ω+u then 1 else 0
  have hs : (Set.univ : Set ℝ) ∈ 𝓝 u := Filter.univ_mem
  have hm : ∀ᶠ x in 𝓝 u, AEStronglyMeasurable (F x) μ := by
    filter_upwards [] with x
    exact ((continuous_id.add continuous_const).max continuous_const).aestronglyMeasurable
  have hset : MeasurableSet {ω : ℝ | 0 < ω+u} :=
    measurableSet_lt measurable_const (measurable_id.add_const u)
  have hm' : AEStronglyMeasurable F' μ := by
    exact (Measurable.ite hset measurable_const measurable_const).aestronglyMeasurable
  have hlip : ∀ᵐ ω ∂μ, LipschitzOnWith (Real.nnabs (1 : ℝ)) (fun x => F x ω) Set.univ := by
    filter_upwards [] with ω
    apply LipschitzWith.lipschitzOnWith
    apply LipschitzWith.of_dist_le_mul
    intro x y
    simp only [F, Real.dist_eq, Real.coe_nnabs, abs_one, one_mul]
    convert abs_max_sub_max_le_abs (ω+x) (ω+y) 0 using 1
    congr 1
    ring
  have hae : ∀ᵐ ω : ℝ ∂μ, ω ≠ -u := by
    exact ae_iff.mpr (by simp)
  have hd : ∀ᵐ ω ∂μ, HasDerivAt (fun x => F x ω) (F' ω) u := by
    filter_upwards [hae] with ω hωu
    exact positive_part_derivative ω u (by intro h; apply hωu; linarith)
  have h := hasDerivAt_integral_of_dominated_loc_of_lip (F := F) (F' := F')
    (bound := fun _ => (1 : ℝ)) hs hm (surplus_integrable μ hω u) hm' hlip (integrable_const 1) hd
  have hi : (∫ ω, F' ω ∂μ) = surplusProbability μ u := by
    simpa [F', surplusProbability, Set.indicator] using (integral_indicator_one hset :
      (∫ ω : ℝ, {ω : ℝ | 0 < ω+u}.indicator (fun _ => (1 : ℝ)) ω ∂μ) = μ.real {ω | 0 < ω+u})
  simpa only [F, surplusMoment, hi] using h.2

 theorem shortfall_moment_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) (u : ℝ) :
    HasDerivAt (shortfallMoment μ) (surplusProbability μ u - 1) u := by
  have he : shortfallMoment μ = fun x => surplusMoment μ x - (∫ ω : ℝ, ω ∂μ) - x := by
    funext x
    have h := expected_moment_identity μ hω x
    linarith
  rw [he]
  exact ((surplus_moment_derivative μ hω u).sub_const (∫ ω : ℝ, ω ∂μ)).sub (hasDerivAt_id u)


noncomputable def shortfallProbability (μ : Measure ℝ) (u : ℝ) : ℝ := μ.real {ω | ω+u < 0}

 theorem probability_partition (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ] (u : ℝ) :
    shortfallProbability μ u + surplusProbability μ u = 1 := by
  have hm : MeasurableSet {ω : ℝ | ω+u < 0} :=
    measurableSet_lt (measurable_id.add_const u) measurable_const
  have hp : MeasurableSet {ω : ℝ | 0 < ω+u} :=
    measurableSet_lt measurable_const (measurable_id.add_const u)
  have hiM := (integrable_const (1 : ℝ) : Integrable (fun _ : ℝ => (1 : ℝ)) μ).indicator hm
  have hiP := (integrable_const (1 : ℝ) : Integrable (fun _ : ℝ => (1 : ℝ)) μ).indicator hp
  have hae : ∀ᵐ ω : ℝ ∂μ, ω ≠ -u := ae_iff.mpr (by simp)
  calc
    shortfallProbability μ u + surplusProbability μ u =
        (∫ ω : ℝ, {ω | ω+u < 0}.indicator (fun _ => (1 : ℝ)) ω +
          {ω | 0 < ω+u}.indicator (fun _ => (1 : ℝ)) ω ∂μ) := by
      rw [integral_add hiM hiP]
      unfold shortfallProbability surplusProbability
      congr 1
      · symm; simpa [Set.indicator] using (integral_indicator_one (μ := μ) hm)
      · symm; simpa [Set.indicator] using (integral_indicator_one (μ := μ) hp)
    _ = ∫ _ : ℝ, (1 : ℝ) ∂μ := by
      apply integral_congr_ae
      filter_upwards [hae] with ω hn
      have hz : ω+u ≠ 0 := by intro h; apply hn; linarith
      rcases lt_or_gt_of_ne hz with h | h
      · simp [Set.indicator, h, show ¬0 < ω+u by linarith]
      · simp [Set.indicator, h, show ¬ω+u < 0 by linarith]
    _ = 1 := by simp

 theorem shortfall_derivative_probability (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) (u : ℝ) :
    HasDerivAt (shortfallMoment μ) (-shortfallProbability μ u) u := by
  convert shortfall_moment_derivative μ hω u using 1
  linarith [probability_partition μ u]

noncomputable def bankObjective {n : ℕ} (law : Fin n → Measure ℝ)
    (w a b : Fin n → ℝ) (r u : ℝ) : ℝ :=
  r*u + ∑ j, w j*(a j*shortfallMoment (law j) u-b j*surplusMoment (law j) u)
noncomputable def bankMarginal {n : ℕ} (law : Fin n → Measure ℝ)
    (w a b : Fin n → ℝ) (r u : ℝ) : ℝ :=
  r - ∑ j, w j*(a j*shortfallProbability (law j) u+b j*surplusProbability (law j) u)

 theorem bank_objective_derivative {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w a b : Fin n → ℝ) (r u : ℝ) :
    HasDerivAt (bankObjective law w a b r) (bankMarginal law w a b r u) u := by
  have hd : HasDerivAt (fun x => ∑ j, w j *
      (a j*shortfallMoment (law j) x-b j*surplusMoment (law j) x))
      (∑ j, w j*(a j*(-shortfallProbability (law j) u)-b j*surplusProbability (law j) u)) u := by
    apply HasDerivAt.fun_sum
    intro j _
    exact (((shortfall_derivative_probability (law j) (hω j) u).const_mul (a j)).sub
      ((surplus_moment_derivative (law j) (hω j) u).const_mul (b j))).const_mul (w j)
  have h := ((hasDerivAt_id u).const_mul r).add hd
  convert h using 1
  unfold bankMarginal
  simp only [mul_one]
  rw [sub_eq_add_neg, ← Finset.sum_neg_distrib]
  congr 1; apply Finset.sum_congr rfl; intro j _; ring

 theorem bank_interior_foc {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w a b : Fin n → ℝ) (r u : ℝ)
    (hmin : IsLocalMin (bankObjective law w a b r) u) : bankMarginal law w a b r u = 0 := by
  exact hmin.hasDerivAt_eq_zero (bank_objective_derivative law hω w a b r u)


noncomputable def shortfallAmount (μ : Measure ℝ) (d u : ℝ) : ℝ := ∫ ω, max (-d*(ω+u)) 0 ∂μ
noncomputable def surplusAmount (μ : Measure ℝ) (d u : ℝ) : ℝ := ∫ ω, max (d*(ω+u)) 0 ∂μ

 theorem shortfall_amount_normalization (μ : Measure ℝ) {d : ℝ} (hd : 0 ≤ d) (u : ℝ) :
    shortfallAmount μ d u = d*shortfallMoment μ u := by
  unfold shortfallAmount shortfallMoment
  calc
    _ = ∫ ω : ℝ, d*max (-ω-u) 0 ∂μ := by
      apply integral_congr_ae; filter_upwards [] with ω
      rw [show -d*(ω+u)=d*(-ω-u) by ring]
      exact pos_scale hd (-ω-u)
    _ = _ := integral_const_mul _ _

 theorem surplus_amount_normalization (μ : Measure ℝ) {d : ℝ} (hd : 0 ≤ d) (u : ℝ) :
    surplusAmount μ d u = d*surplusMoment μ u := by
  unfold surplusAmount surplusMoment
  calc
    _ = ∫ ω : ℝ, d*max (ω+u) 0 ∂μ := by
      apply integral_congr_ae; filter_upwards [] with ω
      exact pos_scale hd (ω+u)
    _ = _ := integral_const_mul _ _

 theorem shortfall_amount_ratio (μ : Measure ℝ) {d : ℝ} (hd : 0 < d) (u : ℝ) :
    shortfallAmount μ d u/d = shortfallMoment μ u := by
  rw [shortfall_amount_normalization μ hd.le]
  field_simp

 theorem surplus_amount_ratio (μ : Measure ℝ) {d : ℝ} (hd : 0 < d) (u : ℝ) :
    surplusAmount μ d u/d = surplusMoment μ u := by
  rw [surplus_amount_normalization μ hd.le]
  field_simp

 theorem shortfall_amount_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) {d : ℝ} (hd : 0 < d) (u : ℝ) :
    HasDerivAt (shortfallAmount μ d) (-d*shortfallProbability μ u) u := by
  have he : shortfallAmount μ d = fun x => d*shortfallMoment μ x :=
    funext (shortfall_amount_normalization μ hd.le)
  rw [he]
  convert (shortfall_derivative_probability μ hω u).const_mul d using 1
  ring

 theorem surplus_amount_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (hω : Integrable (fun ω : ℝ => ω) μ) {d : ℝ} (hd : 0 < d) (u : ℝ) :
    HasDerivAt (surplusAmount μ d) (d*surplusProbability μ u) u := by
  have he : surplusAmount μ d = fun x => d*surplusMoment μ x :=
    funext (surplus_amount_normalization μ hd.le)
  rw [he]
  exact (surplus_moment_derivative μ hω u).const_mul d

end Gomez26LiquidityBuffers
