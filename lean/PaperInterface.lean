import Gomez26LiquidityBuffers.MainTheorems
import Gomez26LiquidityBuffers.Assumptions

/-! Source-facing interface for the CURRENT post-Marco paper (final immutable source in SOURCE_REFERENCE.json).
There are exactly TWO numbered economic propositions. One complete Spec is
registered for each. The local-support and global-obligation Specs are explicitly
scoped components of Proposition 2, not extra paper results. An unproved Spec is
a transparent proposition definition, not an axiom or a proof placeholder.

Actual primitives and equations (1)-(7) are SourceInstance and its transparent
law, Dref/Xref, P/Q, ψ/ℓ/Δ, capacity, a/b, objective and marginal definitions.
They use signed β*A+eps, currency moments, the reference profile, correct zero
volumes, NU and frozen schedules. No historical eligibility model is imported.
Read SourceInstance.lean and Assumptions.lean to expand every model premise.
Proof endpoints live only in ProofInterface.lean. -/
namespace Gomez26LiquidityBuffers
open MeasureTheory Filter Set
open scoped Topology BigOperators

/-- COMPLETE Proposition 1, including density-free convex uniqueness and
nonconvex necessary conditions. The density hypothesis is conditional, not
imposed on the base atomless model. -/
def proposition1Spec : Prop :=
  ∀ (m : ℕ) (s : SourceInstance m) (k : Fin 2) (F : ℝ), 0 ≤ F →
  (∀ u j, Integrable (fun ω : ℝ => max (-ω-u) 0) (s.law k j) ∧
    Integrable (fun ω : ℝ => max (ω+u) 0) (s.law k j)) ∧
  ContDiff ℝ 1 (s.objective k F) ∧
  (∃ u ∈ Icc 0 (s.U k), IsMinOn (s.objective k F) (Icc 0 (s.U k)) u) ∧
  (∀ u, (∀ j, HasDerivAt (shortfallMoment (s.law k j))
      (-shortfallProbability (s.law k j) u) u ∧
    HasDerivAt (surplusMoment (s.law k j)) (surplusProbability (s.law k j) u) u) ∧
    HasDerivAt (s.objective k F) (s.r - ∑ j, s.w j *
      (s.a k j F * shortfallProbability (s.law k j) u +
       s.b k j * surplusProbability (s.law k j) u)) u) ∧
  (∀ u, (0 < u ∧ u < s.U k) → IsMinOn (s.objective k F) (Icc 0 (s.U k)) u →
    s.r = ∑ j, s.w j * (s.a k j F * shortfallProbability (s.law k j) u +
      s.b k j * surplusProbability (s.law k j) u)) ∧
  (∀ (f : Fin m → ℝ → ℝ), ConditionalDensities s k f → ∀ u,
    DensityContinuousNear f u →
      HasDerivAt (deriv (s.objective k F))
        (∑ j, s.w j * (s.a k j F-s.b k j) * f j (-u)) u ∧
      deriv (deriv (s.objective k F)) u = ∑ j, s.w j * (s.a k j F-s.b k j) * f j (-u)) ∧
  ((∀ j, s.b k j ≤ s.a k j F) → ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F)) ∧
  (ConvexOn ℝ (Icc 0 (s.U k)) (s.objective k F) →
    (IsMinOn (s.objective k F) (Icc 0 (s.U k)) 0 ↔ 0 ≤ s.marginal k F 0) ∧
    (IsMinOn (s.objective k F) (Icc 0 (s.U k)) (s.U k) ↔ s.marginal k F (s.U k) ≤ 0) ∧
    (∀ u, (0 < u ∧ u < s.U k) →
      (IsMinOn (s.objective k F) (Icc 0 (s.U k)) u ↔ s.marginal k F u = 0)) ∧
    (0 < s.marginal k F 0 → ∀ y ∈ Icc 0 (s.U k),
      s.objective k F y = s.objective k F 0 → y = 0) ∧
    (s.marginal k F (s.U k) < 0 → ∀ y ∈ Icc 0 (s.U k),
      s.objective k F y = s.objective k F (s.U k) → y = s.U k) ∧
    (∀ u, (0 < u ∧ u < s.U k) → s.marginal k F u = 0 →
      0 < deriv (deriv (s.objective k F)) u →
      IsMinOn (s.objective k F) (Icc 0 (s.U k)) u ∧
      ∀ y ∈ Icc 0 (s.U k), s.objective k F y = s.objective k F u → y = u)) ∧
  (IsMinOn (s.objective k F) (Icc 0 (s.U k)) 0 → 0 ≤ s.marginal k F 0) ∧
  (IsMinOn (s.objective k F) (Icc 0 (s.U k)) (s.U k) → s.marginal k F (s.U k) ≤ 0)

/-- FULL Proposition 2 target. Deliberately has NO paired proof endpoint.
The response/sign is required throughout a neighborhood, and unique-global
continuation is included. It is not replaced by the weaker local support below. -/
def proposition2Spec : Prop :=
  ∀ (m : ℕ) (s : SourceInstance m) (k : Fin 2) (F₀ u₀ : ℝ) (f : Fin m → ℝ → ℝ),
    ConditionalDensities s k f → RegularCapacityPoint s k f F₀ u₀ →
    ∃ b : ℝ → ℝ, b F₀ = u₀ ∧ ContDiffAt ℝ 1 b F₀ ∧
      (∀ᶠ F in 𝓝 F₀, 0 < F ∧ (0 < b F ∧ b F < s.U k) ∧
        s.marginal k F (b F) = 0 ∧
        HasDerivAt b (-capacityNumerator s.w (s.ψ k) s.Δ
          (fun j => shortfallProbability (s.law k j) (b F)) s.κ F /
          currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F (b F)) F ∧
        deriv b F ≤ 0 ∧
        (deriv b F < 0 ↔ ∃ j, 0 < F ∧ F < s.Δ j ∧ s.ψ k j < 1 ∧
          0 < shortfallProbability (s.law k j) (b F)) ∧
        ∃ δ > 0, ∀ v ∈ Ioo (b F-δ) (b F+δ), v ≠ b F →
          s.objective k F (b F) < s.objective k F v) ∧
      ((IsMinOn (s.objective k F₀) (Icc 0 (s.U k)) u₀ ∧
        ∀ y ∈ Icc 0 (s.U k), s.objective k F₀ y = s.objective k F₀ u₀ → y = u₀) →
        ∀ᶠ F in 𝓝 F₀, IsMinOn (s.objective k F) (Icc 0 (s.U k)) (b F) ∧
          ∀ y ∈ Icc 0 (s.U k), s.objective k F y = s.objective k F (b F) → y = b F)

/-- PROVED COMPONENT only: source IFT, base-point formula/sign/strictness,
and persistence of strict interior local minima. Not full Proposition 2. -/
def proposition2LocalSupportSpec : Prop :=
  ∀ (m : ℕ) (s : SourceInstance m) (k : Fin 2) (F u : ℝ) (f : Fin m → ℝ → ℝ),
    ConditionalDensities s k f → RegularCapacityPoint s k f F u →
    ∃ b : ℝ → ℝ, b F = u ∧ ContDiffAt ℝ 1 b F ∧
      (∀ᶠ x in 𝓝 F, s.marginal k x (b x)=0) ∧
      HasDerivAt b (-capacityNumerator s.w (s.ψ k) s.Δ
        (fun j => shortfallProbability (s.law k j) u) s.κ F /
        currentCurvature s.w (s.ψ k) (s.ℓ k) s.Δ f s.i s.κ F u) F ∧
      deriv b F ≤ 0 ∧
      (deriv b F < 0 ↔ ∃ j, 0 < F ∧ F < s.Δ j ∧ s.ψ k j < 1 ∧
        0 < shortfallProbability (s.law k j) u) ∧
      (∀ᶠ x in 𝓝 F, 0 < b x ∧ b x < s.U k ∧
        ∃ δ > 0, ∀ v ∈ Ioo (b x-δ) (b x+δ), v ≠ b x →
          s.objective k x (b x) < s.objective k x v)

/-- Exact missing compact-gap/global-continuation obligation. NO proof endpoint.
No assumed no-switch certificate or global optimizer branch is supplied. -/
def proposition2GlobalContinuationSpec : Prop :=
  ∀ (m : ℕ) (s : SourceInstance m) (k : Fin 2) (F₀ u₀ : ℝ) (f : Fin m → ℝ → ℝ),
    ConditionalDensities s k f → RegularCapacityPoint s k f F₀ u₀ →
    IsMinOn (s.objective k F₀) (Icc 0 (s.U k)) u₀ →
    (∀ y ∈ Icc 0 (s.U k), s.objective k F₀ y = s.objective k F₀ u₀ → y = u₀) →
    ∃ b : ℝ → ℝ, b F₀ = u₀ ∧ ContDiffAt ℝ 1 b F₀ ∧
      ∀ᶠ F in 𝓝 F₀, IsMinOn (s.objective k F) (Icc 0 (s.U k)) (b F) ∧
        ∀ y ∈ Icc 0 (s.U k), s.objective k F y = s.objective k F (b F) → y = b F

end Gomez26LiquidityBuffers
