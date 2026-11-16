import Mathlib.Analysis.Calculus.ImplicitContDiff

/-! Actual native IFT construction for a scalar FOC with domain (capacity, buffer).
This is an analytical helper: the economic-to-C1 and invertibility bridges remain open.
No branch or differentiated-FOC equation is assumed. -/
namespace Gomez26LiquidityBuffers
open Filter
open scoped Topology

 theorem stationary_branch_from_C1
    (G : ℝ × ℝ → ℝ) (F₀ u₀ : ℝ)
    (hzero : G (F₀,u₀) = 0)
    (hC1 : ContDiffAt ℝ 1 G (F₀,u₀))
    (hinv : ((fderiv ℝ G (F₀,u₀)).comp
      (ContinuousLinearMap.inr ℝ ℝ ℝ)).IsInvertible) :
    ∃ u : ℝ → ℝ, u F₀ = u₀ ∧ ContDiffAt ℝ 1 u F₀ ∧
      (∀ᶠ F in 𝓝 F₀, G (F,u F) = 0) ∧
      HasFDerivAt u
        ((-((fderiv ℝ G (F₀,u₀)).comp (ContinuousLinearMap.inr ℝ ℝ ℝ)).inverse).comp
          ((fderiv ℝ G (F₀,u₀)).comp (ContinuousLinearMap.inl ℝ ℝ ℝ))) F₀ := by
  let u := hC1.implicitFunction (by norm_num) hinv
  refine ⟨u, ?_, ?_, ?_, ?_⟩
  · exact hC1.implicitFunction_apply_self (by norm_num) hinv
  · exact hC1.contDiffAt_implicitFunction (by norm_num) hinv
  · simpa only [hzero] using hC1.eventually_apply_implicitFunction (by norm_num) hinv
  · exact (hC1.hasStrictFDerivAt_implicitFunction (by norm_num) hinv).hasFDerivAt

end Gomez26LiquidityBuffers
