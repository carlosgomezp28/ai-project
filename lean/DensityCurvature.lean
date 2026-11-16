import Gomez26LiquidityBuffers.Regularity
import Mathlib.MeasureTheory.Measure.WithDensity
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-! Density-based curvature, with an explicit measure-with-density representation.
No CDF derivative or curvature identity is assumed. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Filter Set
open scoped Topology BigOperators

noncomputable def cumulative (μ : Measure ℝ) (x : ℝ) : ℝ := μ.real (Iic x)

 theorem density_interval (μ : Measure ℝ) (f : ℝ → ℝ)
    (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) {a b : ℝ} (hab : a ≤ b) :
    μ.real (Ioc a b) = ∫ x in a..b, f x := by
  rw [intervalIntegral.integral_of_le hab]
  change (μ (Ioc a b)).toReal = _
  rw [hμ, withDensity_apply _ measurableSet_Ioc,
    ← ofReal_integral_eq_lintegral_ofReal hf.integrableOn (Filter.Eventually.of_forall hn)]
  exact ENNReal.toReal_ofReal (integral_nonneg hn)

 theorem cumulative_difference (μ : Measure ℝ) [IsProbabilityMeasure μ] (f : ℝ → ℝ)
    (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) (a b : ℝ) :
    cumulative μ b - cumulative μ a = ∫ x in a..b, f x := by
  have ordered : ∀ a b : ℝ, a ≤ b → cumulative μ b-cumulative μ a = ∫ x in a..b, f x := by
    intro a b hab
    have he : Iic b \ Iic a = Ioc a b := by ext x; simp
    unfold cumulative
    rw [← measureReal_diff (Iic_subset_Iic.mpr hab) measurableSet_Iic, he]
    exact density_interval μ f hμ hf hn hab
  rcases le_total a b with hab | hba
  · exact ordered a b hab
  · have h := ordered b a hba
    rw [intervalIntegral.integral_symm]
    linarith

 theorem cumulative_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] (f : ℝ → ℝ)
    (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) {x : ℝ} (hc : ContinuousAt f x) :
    HasDerivAt (cumulative μ) (f x) x := by
  have he : cumulative μ = fun y => cumulative μ 0 + ∫ t in 0..y, f t := by
    funext y; linarith [cumulative_difference μ f hμ hf hn 0 y]
  rw [he]
  exact (intervalIntegral.integral_hasDerivAt_right hf.intervalIntegrable
    hf.aestronglyMeasurable.stronglyMeasurableAtFilter hc).const_add _

 theorem shortfall_probability_cumulative (μ : Measure ℝ) [NoAtoms μ] (u : ℝ) :
    shortfallProbability μ u = cumulative μ (-u) := by
  have he : {ω : ℝ | ω+u < 0} = Iio (-u) := by ext ω; simp; constructor <;> intro h <;> linarith
  unfold shortfallProbability cumulative
  rw [he]
  change (μ (Iio (-u))).toReal = (μ (Iic (-u))).toReal
  rw [measure_congr Iio_ae_eq_Iic]

 theorem shortfall_probability_density_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (f : ℝ → ℝ) (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) {u : ℝ} (hc : ContinuousAt f (-u)) :
    HasDerivAt (shortfallProbability μ) (-f (-u)) u := by
  have he : shortfallProbability μ = fun x => cumulative μ (-x) :=
    funext (shortfall_probability_cumulative μ)
  rw [he]
  convert (cumulative_derivative μ f hμ hf hn hc).comp u (hasDerivAt_id u).neg using 1 <;> ring

 theorem surplus_probability_density_derivative (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (f : ℝ → ℝ) (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) {u : ℝ} (hc : ContinuousAt f (-u)) :
    HasDerivAt (surplusProbability μ) (f (-u)) u := by
  have he : surplusProbability μ = fun x => 1-shortfallProbability μ x := by
    funext x; linarith [probability_partition μ x]
  rw [he]
  convert (hasDerivAt_const u (1 : ℝ)).sub
    (shortfall_probability_density_derivative μ f hμ hf hn hc) using 1 <;> ring

noncomputable def currentCurvature {n : ℕ} (w ψ ℓ Δ : Fin n → ℝ)
    (f : Fin n → ℝ → ℝ) (i κ F u : ℝ) : ℝ :=
  ∑ j, w j*(deficitCoefficient i κ (ψ j) (Δ j) F-i*ℓ j)*f j (-u)

 theorem current_marginal_density_derivative {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (f : Fin n → ℝ → ℝ)
    (hμ : ∀ j, law j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ) (hc : ∀ j, ContinuousAt (f j) (-u)) :
    HasDerivAt (currentMarginal law w ψ ℓ Δ r i κ F)
      (currentCurvature w ψ ℓ Δ f i κ F u) u := by
  have hs : HasDerivAt (fun x => ∑ j, w j *
      (deficitCoefficient i κ (ψ j) (Δ j) F * shortfallProbability (law j) x+
        i*ℓ j*surplusProbability (law j) x))
      (∑ j, w j*(deficitCoefficient i κ (ψ j) (Δ j) F * (-f j (-u))+i*ℓ j*f j (-u))) u := by
    apply HasDerivAt.fun_sum
    intro j _
    exact (((shortfall_probability_density_derivative (law j) (f j) (hμ j) (hf j) (hn j) (hc j)).const_mul _).add
      ((surplus_probability_density_derivative (law j) (f j) (hμ j) (hf j) (hn j) (hc j)).const_mul _)).const_mul _
  have h := (hasDerivAt_const u r).sub hs
  convert h using 1
  unfold currentCurvature
  simp only [zero_sub]
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl; intro j _; ring

 theorem current_cost_density_curvature {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (f : Fin n → ℝ → ℝ)
    (hμ : ∀ j, law j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x)))
    (hf : ∀ j, Integrable (f j) MeasureTheory.volume) (hn : ∀ j x, 0 ≤ f j x)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ) (hc : ∀ j, ContinuousAt (f j) (-u)) :
    deriv (deriv (currentCost law w ψ ℓ Δ r i κ F)) u = currentCurvature w ψ ℓ Δ f i κ F u := by
  have he : deriv (currentCost law w ψ ℓ Δ r i κ F) = currentMarginal law w ψ ℓ Δ r i κ F :=
    funext fun x => (current_cost_derivative law hω w ψ ℓ Δ r i κ F x).deriv
  rw [he]
  exact (current_marginal_density_derivative law f hμ hf hn w ψ ℓ Δ r i κ F u hc).deriv

/-- Local density continuity suffices; no global smoothness at support joins is required. -/
theorem shortfall_probability_C1_at (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (f : ℝ → ℝ) (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) (u : ℝ)
    (hc : ContinuousAt f (-u)) (hloc : ∀ᶠ v in 𝓝 u, ContinuousAt f (-v)) :
    ContDiffAt ℝ 1 (shortfallProbability μ) u := by
  rw [contDiffAt_one_iff]
  refine ⟨fun v => (-f (-v)) • ContinuousLinearMap.id ℝ ℝ,
    {v | ContinuousAt f (-v)}, hloc, ?_, ?_⟩
  · intro v hv
    exact ((hv.comp continuousAt_id.neg).neg.smul continuousAt_const).continuousWithinAt
  · intro v hv
    convert (shortfall_probability_density_derivative μ f hμ hf hn hv).hasFDerivAt using 1
    ext; simp

theorem surplus_probability_C1_at (μ : Measure ℝ) [IsProbabilityMeasure μ] [NoAtoms μ]
    (f : ℝ → ℝ) (hμ : μ = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f x)))
    (hf : Integrable f MeasureTheory.volume) (hn : ∀ x, 0 ≤ f x) (u : ℝ)
    (hc : ContinuousAt f (-u)) (hloc : ∀ᶠ v in 𝓝 u, ContinuousAt f (-v)) :
    ContDiffAt ℝ 1 (surplusProbability μ) u := by
  have he : surplusProbability μ = fun v => 1-shortfallProbability μ v := by
    funext v; linarith [probability_partition μ v]
  rw [he]
  exact contDiffAt_const.sub (shortfall_probability_C1_at μ f hμ hf hn u hc hloc)

end Gomez26LiquidityBuffers
