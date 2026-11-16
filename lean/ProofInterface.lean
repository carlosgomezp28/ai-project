import Gomez26LiquidityBuffers.PaperInterface

/-! Exact-type proof endpoints. No theorem is declared for the full P2 Spec or
its global-continuation obligation. All bodies assemble existing compiled proofs. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Filter Set
open scoped Topology BigOperators

theorem proposition1 : proposition1Spec := by
  intro m s k F _hF
  refine ⟨?_,s.objective_C1 k F,s.objective_exists k F,?_,?_,?_,?_,?_,?_,?_⟩
  · intro u j
    exact ⟨shortfall_integrable (s.law k j) (s.law_first_moment k j) u,
      surplus_integrable (s.law k j) (s.law_first_moment k j) u⟩
  · intro u
    refine ⟨?_,s.objective_derivative k F u⟩
    intro j
    exact ⟨shortfall_derivative_probability (s.law k j) (s.law_first_moment k j) u,
      surplus_moment_derivative (s.law k j) (s.law_first_moment k j) u⟩
  · intro u hu hm
    have h := s.interior_foc k F u hu hm
    change s.r - ∑ j, s.w j * (s.a k j F * shortfallProbability (s.law k j) u +
      s.b k j * surplusProbability (s.law k j) u) = 0 at h
    linarith
  · intro f hp u hc
    have he : deriv (s.objective k F) = s.marginal k F :=
      funext fun x => (s.objective_derivative k F x).deriv
    have hd : HasDerivAt (deriv (s.objective k F))
        (∑ j, s.w j * (s.a k j F-s.b k j) * f j (-u)) u := by
      rw [he]
      exact current_marginal_density_derivative (s.law k) f hp.1 hp.2.1 hp.2.2
        s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u hc.1
    exact ⟨hd,hd.deriv⟩
  · intro hab
    exact (s.objective_convex k F hab).subset (by intro x _; trivial) (convex_Icc _ _)
  · intro hcv
    refine ⟨s.lower_corner_iff k F hcv,s.upper_corner_iff k F hcv,?_,
      s.strict_lower_unique k F hcv,s.strict_upper_unique k F hcv,?_⟩
    · intro u hu; exact s.interior_iff k F u hu hcv
    · intro u hu hz hpos
      have he : deriv (s.objective k F) = s.marginal k F :=
        funext fun x => (s.objective_derivative k F x).deriv
      refine ⟨(s.interior_iff k F u hu hcv).mpr hz,?_⟩
      apply convex_positive_curvature_unique hu hcv
      · intro x; exact (s.objective_derivative k F x).deriv.symm ▸ s.objective_derivative k F x
      · simpa only [he] using hz
      · exact (differentiableAt_of_deriv_ne_zero hpos.ne').hasDerivAt
      · exact hpos
  · exact lower_corner_necessary (s.U_pos k) (s.objective_derivative k F 0)
  · exact upper_corner_necessary (s.U_pos k) (s.objective_derivative k F (s.U k))

theorem proposition2LocalSupport : proposition2LocalSupportSpec := by
  intro m s k F u f hp hr
  exact s.capacity_branch k F u f hp.1 hp.2.1 hp.2.2 hr.2.2.2.2.1.1 hr.2.2.2.2.1.2
    hr.2.2.2.1 hr.1 hr.2.1 hr.2.2.1 hr.2.2.2.2.2

end Gomez26LiquidityBuffers
