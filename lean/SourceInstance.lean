import Gomez26LiquidityBuffers.Regularity

/-! The actual two-type, finite-state source environment, Assumptions 1-5,
equations (1)-(7). Schedules depend only on the reference profile, not the deviating u.
No optimizer, derivative, convexity or equilibrium conclusion is a structure field. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Set
open scoped BigOperators

structure SourceInstance (m : ℕ) where
  μ : Fin 2 → ℝ
  d : Fin 2 → ℝ
  β : Fin 2 → ℝ
  τ : Fin 2 → ℝ
  U : Fin 2 → ℝ
  uref : Fin 2 → ℝ
  A : Fin m → ℝ
  w : Fin m → ℝ
  epsLaw : Fin 2 → Fin m → Measure ℝ
  μ_pos : ∀ k, 0 < μ k
  d_pos : ∀ k, 0 < d k
  τ_bounds : ∀ k, 0 ≤ τ k ∧ τ k ≤ 1
  U_pos : ∀ k, 0 < U k
  uref_feasible : ∀ k, 0 ≤ uref k ∧ uref k ≤ U k
  w_pos : ∀ j, 0 < w j
  w_sum : ∑ j, w j = 1
  eps_probability : ∀ k j, IsProbabilityMeasure (epsLaw k j)
  eps_atomless : ∀ k j, NoAtoms (epsLaw k j)
  eps_first_moment : ∀ k j, Integrable (fun e : ℝ => e) (epsLaw k j)
  r : ℝ
  i : ℝ
  κ : ℝ
  ρ : ℝ
  ν : ℝ
  R : ℝ
  r_nonneg : 0 ≤ r
  i_nonneg : 0 ≤ i
  κ_gt_i : i < κ
  ρ_nonneg : 0 ≤ ρ
  ν_bounds : 0 ≤ ν ∧ ν ≤ 1
  R_nonneg : 0 ≤ R

namespace SourceInstance
variable {m : ℕ} (s : SourceInstance m)

instance epsProb (k : Fin 2) (j : Fin m) : IsProbabilityMeasure (s.epsLaw k j) := s.eps_probability k j
instance epsNoAtoms (k : Fin 2) (j : Fin m) : NoAtoms (s.epsLaw k j) := s.eps_atomless k j

noncomputable def law (k : Fin 2) (j : Fin m) : Measure ℝ :=
  (s.epsLaw k j).map (fun e => s.β k*s.A j+e)

instance lawProb (k : Fin 2) (j : Fin m) : IsProbabilityMeasure (s.law k j) := by
  unfold law; exact (s.epsLaw k j).isProbabilityMeasure_map (by fun_prop)

instance lawNoAtoms (k : Fin 2) (j : Fin m) : NoAtoms (s.law k j) := by
  constructor
  intro x
  rw [law, Measure.map_apply (by fun_prop) (measurableSet_singleton x)]
  have he : (fun e : ℝ => s.β k*s.A j+e) ⁻¹' {x} = {x-s.β k*s.A j} := by
    ext e; simp only [mem_preimage, mem_singleton_iff]
    constructor <;> intro h <;> linarith
  rw [he]; exact measure_singleton _

 theorem law_first_moment (k : Fin 2) (j : Fin m) :
    Integrable (fun ω : ℝ => ω) (s.law k j) := by
  unfold law
  apply (integrable_map_measure (by fun_prop) (by fun_prop)).mpr
  exact (integrable_const (s.β k*s.A j)).add (s.eps_first_moment k j)

noncomputable def deposits : ℝ := ∑ k, s.μ k*s.d k
noncomputable def capacity : ℝ := s.ν*s.ρ*s.deposits+s.R
noncomputable def Dref (k : Fin 2) (j : Fin m) : ℝ := shortfallAmount (s.law k j) (s.d k) (s.uref k)
noncomputable def Xref (k : Fin 2) (j : Fin m) : ℝ := surplusAmount (s.law k j) (s.d k) (s.uref k)
noncomputable def P (j : Fin m) : ℝ := volume s.μ s.τ (fun k => s.Xref k j)
noncomputable def Q (j : Fin m) : ℝ := volume s.μ s.τ (fun k => s.Dref k j)
noncomputable def ψ (k : Fin 2) (j : Fin m) : ℝ := borrowFraction (s.τ k) (s.P j) (s.Q j)
noncomputable def ℓ (k : Fin 2) (j : Fin m) : ℝ := lendFraction (s.τ k) (s.P j) (s.Q j)
noncomputable def Δ (j : Fin m) : ℝ := ∑ k, s.μ k*(1-s.ψ k j)*s.Dref k j
noncomputable def a (k : Fin 2) (j : Fin m) (F : ℝ) : ℝ := deficitCoefficient s.i s.κ (s.ψ k j) (s.Δ j) F
noncomputable def b (k : Fin 2) (j : Fin m) : ℝ := s.i*s.ℓ k j
noncomputable def objective (k : Fin 2) (F u : ℝ) : ℝ :=
  currentCost (s.law k) s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u
noncomputable def marginal (k : Fin 2) (F u : ℝ) : ℝ :=
  currentMarginal (s.law k) s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u

 theorem deposits_pos : 0 < s.deposits := by
  apply Finset.sum_pos
  · intro k _; exact mul_pos (s.μ_pos k) (s.d_pos k)
  · exact Finset.univ_nonempty

 theorem capacity_nonneg : 0 ≤ s.capacity :=
  add_nonneg (mul_nonneg (mul_nonneg s.ν_bounds.1 s.ρ_nonneg) s.deposits_pos.le) s.R_nonneg

 theorem Dref_nonneg (k : Fin 2) (j : Fin m) : 0 ≤ s.Dref k j := by
  exact integral_nonneg fun _ => le_max_right _ _
 theorem Xref_nonneg (k : Fin 2) (j : Fin m) : 0 ≤ s.Xref k j := by
  exact integral_nonneg fun _ => le_max_right _ _
 theorem P_nonneg (j : Fin m) : 0 ≤ s.P j := by
  unfold P volume
  apply Finset.sum_nonneg; intro k _
  exact mul_nonneg (mul_nonneg (s.μ_pos k).le (s.τ_bounds k).1) (s.Xref_nonneg k j)
 theorem Q_nonneg (j : Fin m) : 0 ≤ s.Q j := by
  unfold Q volume
  apply Finset.sum_nonneg; intro k _
  exact mul_nonneg (mul_nonneg (s.μ_pos k).le (s.τ_bounds k).1) (s.Dref_nonneg k j)

 theorem ψ_bounds (k : Fin 2) (j : Fin m) : 0 ≤ s.ψ k j ∧ s.ψ k j ≤ 1 := by
  unfold ψ borrowFraction
  split_ifs with h
  · exact ⟨le_rfl, by norm_num⟩
  · have hfrac : 0 ≤ min 1 (s.P j/s.Q j) := le_min (by norm_num) (div_nonneg (s.P_nonneg j) (s.Q_nonneg j))
    refine ⟨mul_nonneg (s.τ_bounds k).1 hfrac, ?_⟩
    exact (mul_le_of_le_one_right (s.τ_bounds k).1 (min_le_left _ _)).trans (s.τ_bounds k).2

 theorem Δ_nonneg (j : Fin m) : 0 ≤ s.Δ j := by
  apply Finset.sum_nonneg; intro k _
  exact mul_nonneg (mul_nonneg (s.μ_pos k).le (sub_nonneg.mpr (s.ψ_bounds k j).2)) (s.Dref_nonneg k j)

 theorem interbank_conservation (j : Fin m) :
    (∑ k, s.μ k*s.ψ k j*s.Dref k j) = min (s.P j) (s.Q j) ∧
    (∑ k, s.μ k*s.ℓ k j*s.Xref k j) = min (s.P j) (s.Q j) :=
  interbank_conservation_all s.μ s.τ _ _ (s.P_nonneg j) (s.Q_nonneg j)

 theorem objective_derivative (k : Fin 2) (F u : ℝ) :
    HasDerivAt (s.objective k F) (s.marginal k F u) u :=
  current_cost_derivative (s.law k) (s.law_first_moment k) s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F u

 theorem objective_C1 (k : Fin 2) (F : ℝ) : ContDiff ℝ 1 (s.objective k F) :=
  current_cost_C1 (s.law k) (s.law_first_moment k) s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F

 theorem objective_exists (k : Fin 2) (F : ℝ) :
    ∃ u ∈ Icc 0 (s.U k), IsMinOn (s.objective k F) (Icc 0 (s.U k)) u :=
  current_global_exists (s.law k) (s.law_first_moment k) s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F _ (s.U_pos k).le

 theorem interior_foc (k : Fin 2) (F u : ℝ) (hu : 0 < u ∧ u < s.U k)
    (hmin : IsMinOn (s.objective k F) (Icc 0 (s.U k)) u) : s.marginal k F u = 0 :=
  current_interior_foc (s.law k) (s.law_first_moment k) s.w (s.ψ k) (s.ℓ k) s.Δ s.r s.i s.κ F _ u hu hmin

end SourceInstance
end Gomez26LiquidityBuffers
