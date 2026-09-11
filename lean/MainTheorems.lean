import EconCSLib

/-!
# Paper-Facing Theorems: AI, Human Cognition and Knowledge Collapse

This file is the implementation theorem layer for the source paper. Keep
source-faithful definitions and theorem wrappers here, and expose only the
compact human-review subset in `PaperInterface.lean`.

During the statement-first phase, each exact paper-facing proposition lives in a
transparent `<name>Spec : Prop` declaration in `PaperInterface.lean`; the paired
theorem/lemma endpoint belongs in `ProofInterface.lean` and has exactly that
type.

## Source model (Sections 3.1-3.6, static block)

All objects are taken at a fixed agent-period `(i, t)`. The success probability
`G(τ) = 2Φ(√τ) - 1`, its derivative `g(τ) = φ(√τ)/√τ` and `g'` enter the Specs
as abstract functions `G`, `g`, `gd` with exactly the properties the paper uses
(`G' = g`, `g > 0` and decreasing, `g' < 0`, `G(X) > 0` for `X > 0`); deriving
them from the Gaussian CDF is a declared analytic boundary. `p0` is the prior
precision `σ⁻²`, `τ` the agentic precision `τ_A`, `lamI`/`lamG` are `λ_I`/`λ_G`
(a Lean keyword), `Sig2` is the innovation variance `Σ²`.
-/

namespace AKO26KnowledgeCollapse

/-! ## Helper for the transition map (Lemma 1, Proposition 2) -/

/-- The map `A ↦ (Σ² + A⁻¹)⁻¹` is strictly increasing on positive arguments. -/
theorem transition_strictMono_aux {Sig2 A1 A2 : ℝ} (hSig : 0 < Sig2) (hA1 : 0 < A1)
    (hlt : A1 < A2) :
    (Sig2 + A1⁻¹)⁻¹ < (Sig2 + A2⁻¹)⁻¹ := by
  have hA2 : 0 < A2 := lt_trans hA1 hlt
  have hinv : A2⁻¹ < A1⁻¹ := by
    have := one_div_lt_one_div_of_lt hA1 hlt
    simpa [one_div] using this
  have hpos : 0 < Sig2 + A2⁻¹ := by positivity
  have hsum : Sig2 + A2⁻¹ < Sig2 + A1⁻¹ := by linarith
  have := one_div_lt_one_div_of_lt hpos hsum
  simpa [one_div] using this

/-! ## Extensions beyond the printed statements -/

/-- Lean's convention `0⁻¹ = 0` at the boundary. The paper reads `F(0) = 0`
because with zero effort the inner term `(0 + 0)⁻¹` is `+∞`; in Lean's reals the
same formula evaluated at `X = 0` with zero effort returns `Σ2⁻¹`. The Specs are
therefore stated on `X > 0`, and `F(0) = 0` is a separate boundary convention. -/
theorem transition_at_zero_lean_convention (Sig2 lamG I : ℝ) :
    (Sig2 + ((0 : ℝ) + lamG * I * 0)⁻¹)⁻¹ = Sig2⁻¹ := by
  simp

/-- The production-side assumption the paper never relaxes is `ΔI = 0`
(Assumption 1). With `ΔI > 0` the private marginal benefit of effort at zero
general knowledge (`G(0) = 0`) is `ΔI λI g(σ⁻² + τ) > 0` instead of `0`: effort
would not vanish with general knowledge. -/
theorem effort_incentive_survives_without_general_knowledge
    (ΔI ΔX lamI p0 τ : ℝ) (g : ℝ → ℝ)
    (hΔI : 0 < ΔI) (hlam : 0 < lamI) (hg : 0 < g (p0 + τ)) :
    0 < ΔI * lamI * g (p0 + τ) + ΔX * 0 * lamI * g (p0 + τ) := by
  have : 0 < ΔI * lamI * g (p0 + τ) := mul_pos (mul_pos hΔI hlam) hg
  simpa using this

/-- If effort stayed positive at `X = 0`, the transition map would be positive
there, so `X = 0` would no longer be a fixed point: the knowledge-collapse steady
state (9) depends on effort vanishing with general knowledge, i.e. on `ΔI = 0`. -/
theorem transition_positive_with_effort (Sig2 lamG I e0 : ℝ)
    (hSig : 0 < Sig2) (hlam : 0 < lamG) (hI : 0 < I) (he : 0 < e0) :
    0 < (Sig2 + ((0 : ℝ) + lamG * I * e0)⁻¹)⁻¹ := by
  have hA : 0 < (0 : ℝ) + lamG * I * e0 := by
    have := mul_pos (mul_pos hlam hI) he; linarith
  have : 0 < (0 + lamG * I * e0)⁻¹ := inv_pos.mpr hA
  exact inv_pos.mpr (by linarith)

end AKO26KnowledgeCollapse
