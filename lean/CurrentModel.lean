import Gomez26LiquidityBuffers.Convexity
import Gomez26LiquidityBuffers.Capacity

/-! Explicit current-model specialization: a = i psi + kappa(1-phi)(1-psi), b=i ell.
No old eligibility or reserve-usability objective occurs in these declarations. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Set

noncomputable def currentCost {n : ℕ} (law : Fin n → Measure ℝ)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ) : ℝ :=
  bankObjective law w (fun j => deficitCoefficient i κ (ψ j) (Δ j) F) (fun j => i*ℓ j) r u
noncomputable def currentMarginal {n : ℕ} (law : Fin n → Measure ℝ)
    (w ψ ℓ Δ : Fin n → ℝ) (r i κ F u : ℝ) : ℝ :=
  bankMarginal law w (fun j => deficitCoefficient i κ (ψ j) (Δ j) F) (fun j => i*ℓ j) r u

 theorem current_cost_derivative {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F u : ℝ) :
    HasDerivAt (currentCost law w ψ ℓ Δ r i κ F) (currentMarginal law w ψ ℓ Δ r i κ F u) u :=
  bank_objective_derivative law hω w _ _ r u

 theorem current_global_exists {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F U : ℝ) (hU : 0 ≤ U) :
    ∃ u ∈ Icc 0 U, IsMinOn (currentCost law w ψ ℓ Δ r i κ F) (Icc 0 U) u :=
  bank_global_exists law hω w _ _ r U hU

 theorem current_interior_foc {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F U u : ℝ) (hu : 0 < u ∧ u < U)
    (hmin : IsMinOn (currentCost law w ψ ℓ Δ r i κ F) (Icc 0 U) u) :
    currentMarginal law w ψ ℓ Δ r i κ F u = 0 := by
  exact (hmin.isLocalMin (Icc_mem_nhds hu.1 hu.2)).hasDerivAt_eq_zero
    (current_cost_derivative law hω w ψ ℓ Δ r i κ F u)

 theorem current_sufficient_convexity {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F : ℝ) (hw : ∀ j, 0 ≤ w j)
    (hab : ∀ j, i*ℓ j ≤ deficitCoefficient i κ (ψ j) (Δ j) F) :
    ConvexOn ℝ univ (currentCost law w ψ ℓ Δ r i κ F) :=
  bank_sufficient_convexity law hω w _ _ r hw hab

 theorem current_lower_corner_iff {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F U : ℝ) (hU : 0 < U) (hw : ∀ j, 0 ≤ w j)
    (hab : ∀ j, i*ℓ j ≤ deficitCoefficient i κ (ψ j) (Δ j) F) :
    IsMinOn (currentCost law w ψ ℓ Δ r i κ F) (Icc 0 U) 0 ↔
      0 ≤ currentMarginal law w ψ ℓ Δ r i κ F 0 := by
  exact convex_lower_corner_iff hU
    ((current_sufficient_convexity law hω w ψ ℓ Δ r i κ F hw hab).subset (subset_univ _) (convex_Icc _ _))
    (current_cost_derivative law hω w ψ ℓ Δ r i κ F 0)

 theorem current_upper_corner_iff {n : ℕ} (law : Fin n → Measure ℝ)
    [∀ j, IsProbabilityMeasure (law j)] [∀ j, NoAtoms (law j)]
    (hω : ∀ j, Integrable (fun ω : ℝ => ω) (law j)) (w ψ ℓ Δ : Fin n → ℝ)
    (r i κ F U : ℝ) (hU : 0 < U) (hw : ∀ j, 0 ≤ w j)
    (hab : ∀ j, i*ℓ j ≤ deficitCoefficient i κ (ψ j) (Δ j) F) :
    IsMinOn (currentCost law w ψ ℓ Δ r i κ F) (Icc 0 U) U ↔
      currentMarginal law w ψ ℓ Δ r i κ F U ≤ 0 := by
  exact convex_upper_corner_iff hU
    ((current_sufficient_convexity law hω w ψ ℓ Δ r i κ F hw hab).subset (subset_univ _) (convex_Icc _ _))
    (current_cost_derivative law hω w ψ ℓ Δ r i κ F U)

end Gomez26LiquidityBuffers
