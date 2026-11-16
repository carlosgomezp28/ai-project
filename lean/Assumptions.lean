import Gomez26LiquidityBuffers.MainTheorems

/-! Named source antecedents, not axioms or conclusion certificates.
Assumptions 1–5 are the primitive fields of SourceInstance. The predicates below
spell out the probability-density meaning and Assumption 6 for density clauses. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Filter Set
open scoped Topology

/-- A nonnegative integrable PDF representing the actual conditional signed-flow law.
This is not a consequence of atomlessness; supply it only for density clauses. -/
def ConditionalDensities {m : ℕ} (s : SourceInstance m) (k : Fin 2)
    (f : Fin m → ℝ → ℝ) : Prop :=
  (∀ j, s.law k j = MeasureTheory.volume.withDensity (fun x => ENNReal.ofReal (f j x))) ∧
  (∀ j, Integrable (f j) MeasureTheory.volume) ∧ (∀ j x, 0 ≤ f j x)

/-- Density continuity in a neighborhood of every threshold. No smoothness across
uniform support endpoints is asserted. The pointwise clause is made explicit. -/
def DensityContinuousNear {m : ℕ} (f : Fin m → ℝ → ℝ) (u : ℝ) : Prop :=
  (∀ j, ContinuousAt (f j) (-u)) ∧
  (∀ j, ∀ᶠ v in 𝓝 u, ContinuousAt (f j) (-v))

/-- Paper Assumption 6. Marginal/curvature equal J_u/J_uu by the proved source
identities; no branch or comparative-static conclusion is a premise. -/
def RegularCapacityPoint {m : ℕ} (s : SourceInstance m) (k : Fin 2)
    (f : Fin m → ℝ → ℝ) (F u : ℝ) : Prop :=
  0 < F ∧ (0 < u ∧ u < s.U k) ∧ s.marginal k F u = 0 ∧
  (∀ j, 0 < s.Δ j → F ≠ s.Δ j) ∧ DensityContinuousNear f u ∧
  0 < currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u

end Gomez26LiquidityBuffers
