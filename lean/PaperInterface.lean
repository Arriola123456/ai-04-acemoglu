import AKO26KnowledgeCollapse.MainTheorems
import AKO26KnowledgeCollapse.Assumptions

/-!
# Human-Facing Paper Interface: AI, Human Cognition and Knowledge Collapse

This is the compact Lean file a human should read after formalization to check
whether the paper's definitions and named theorem statements were represented
correctly. Keep the row-level dashboard and LLM audit statements in this file
for every paper. Move implementation details, proof aliases, and bulky helper
lemmas behind imported modules such as `AuditInterface.lean`, but expose the
audited paper-facing statements directly here; do not use
`paper_interface.audit_surface_path`.

Rules for completing this file:

- Keep the paper's definitions/formatted objects first, in source order.
- Expose the actual paper formulas here; do not only point to generic library
  definitions or implementation witnesses.
- A material reusable `EconCSLib` primitive may remain a reference here only
  after `audit/library_semantic_review.json` records its exact bounded library
  declaration and an explicit byte-pinned paper-source connection. The
  dashboard and human-review packet show and source-check that declaration
  before the dependent Spec; a library name, docstring, or glossary is not a
  semantic bridge. Do not add a duplicate paper claim merely to restate it.
- If a named theorem needs a hypothesis that is not derived from earlier Lean
  declarations, declare that hypothesis in `Assumptions.lean` and list it in
  `status.json` `review_surface.assumption_names`.
- Then state the named results directly, with assumptions visible in each
  theorem signature by referencing named paper assumptions imported from
  `Assumptions.lean`.
- In the statement-first phase, write every complete source-facing statement as
  a transparent `<name>Spec : Prop` here, exactly once. Put the paired
  theorem/lemma of that exact type in `ProofInterface.lean`; its temporary
  proof body may be `by sorry` only in a private draft. This separation keeps
  the human semantic surface free of thin wrapper declarations.
- Before drafting that Lean surface, independently inventory every material
  source atom from exact pinned source quote bytes. Do not infer source atoms
  from declaration, binder, field, function, or source-map names.
- Run raw-source-to-expanded-Spec statement matching plus recursive
  premise/conclusion provenance on the skeleton. The semantic comparison uses
  only byte-pinned source quotes (and separately pinned source context) against
  the expanded transparent Spec; map summaries and proof wrappers are not
  semantic inputs. Then freeze each canonical Lean declaration-manifest digest.
- In the proof phase, replace the `ProofInterface.lean` `sorry` with a short
  proof that calls into `MainTheorems.lean` or lower proof files without
  changing the specification or theorem type. Any specification/type change
  invalidates the freeze and requires a fresh statement audit.
- At formalized closeout, complete the v11 realization receipt: Lean Meta checks
  the theorem has exactly the transparent Spec type; each source atom is bound
  to the elaborated Spec surface; closure traversal includes proof and instance
  arguments; and every material terminal has a source, approved correction or
  additional assumption, checked derivation, or version-pinned foundation
  disposition. No data, container, or identifier-based exemption is allowed.
- The transparent `...Spec` is the sole semantic-review target for its source
  claim. The paired theorem/lemma is a proof endpoint whose exact Spec type is
  verified by Lean Meta, not a duplicate source-to-Lean comparison row.
- Keep proof endpoints, exhaustive endpoint aliases, and proof-seam checks in
  `ProofInterface.lean`, implementation modules, or `ProofLedger.lean`, not
  here. Do not create new `PostPaperAudit.lean` or `AuditLedger.lean` files;
  those names are legacy.

## Named Results

Each entry has one semantic-review target (`Spec`) and one proof endpoint (the
paired theorem/lemma). The human dashboard and review packet present that pair
once rather than treating the two declarations as duplicate paper claims.

- `paper_equation_6_expected_utilitySpec` -> `paper_equation_6_expected_utility`: Equation (6): expected period utility under Assumption 1 (ΔI = 0), Section 3.3, PDF page 15 (printed page 14), Equation (6); definitions of ΔG, ΔI, ΔX in Section 3.1, PDF page 10 (printed page 9).
- `paper_first_order_conditionSpec` -> `paper_first_order_condition`: First-order condition for effort (Section 3.5), Section 3.5, PDF page 16 (printed page 15), display after 'the first-order condition is'; also Section 3.4, PDF page 15 (printed page 14).
- `paper_observation_1_complementSpec` -> `paper_observation_1_complement`: Observation 1, complement part: public precision complements human effort, Section 3.4, PDF pages 15-16 (printed pages 14-15), Observation 1 and the display ∂²U/∂e∂X = ΔX λI g(X) g(Y) > 0.
- `paper_observation_1_substituteSpec` -> `paper_observation_1_substitute`: Observation 1, substitute part: agentic-AI precision substitutes for human effort, Section 3.4, PDF page 16 (printed page 15), display ∂²U/∂e∂τA = ΔX G(X) λI g'(Y) < 0.
- `paper_marginal_utility_strictly_decreasingSpec` -> `paper_marginal_utility_strictly_decreasing`: Section 3.5: the marginal utility of effort is strictly decreasing in effort, Section 3.5, PDF page 16 (printed page 15), text 'Consequently, ∂U/∂e is strictly decreasing in e'.
- `paper_best_response_uniqueSpec` -> `paper_best_response_unique`: Section 3.5: the first-order condition has at most one solution (unique maximizer), Section 3.5, PDF page 16 (printed page 15), 'admits a unique and finite maximizer' and the definition of the best-response effort e(X, τA).
- `paper_best_response_existsSpec` -> `paper_best_response_exists`: Section 3.5: the first-order condition has a solution (a finite maximizer exists), Section 3.5, PDF page 16 (printed page 15), displays ∂U/∂e at e = 0 ≥ 0 and lim ∂U/∂e < 0, 'admits a unique and finite maximizer'.
- `paper_observation_2_increasing_in_XSpec` -> `paper_observation_2_increasing_in_X`: Observation 2 (in X): best-response effort is increasing in public precision, Section 3.5, PDF page 17 (printed page 16), Observation 2.
- `paper_observation_2_decreasing_in_tauSpec` -> `paper_observation_2_decreasing_in_tau`: Observation 2 (in τA): best-response effort is decreasing in agentic-AI precision, Section 3.5, PDF page 17 (printed page 16), Observation 2.
- `paper_lemma_1_transition_strictly_increasingSpec` -> `paper_lemma_1_transition_strictly_increasing`: Lemma 1 (monotonicity): the state transition map F is strictly increasing, Section 3.6, PDF page 18 (printed page 17), Lemma 1; transition map F defined in Equation (8), PDF page 17 (printed page 16).
- `paper_lemma_1_transition_boundsSpec` -> `paper_lemma_1_transition_bounds`: Lemma 1 (bounds): the transition map takes values in (0, Σ^{-2}), Section 3.5, PDF page 18 (printed page 17), display '0 ≤ F(X) < Σ^{-2} for all finite X'.
- `paper_proposition_2_increasing_in_ISpec` -> `paper_proposition_2_increasing_in_I`: Proposition 2 (Comparative Statics of F), aggregation scale I, Section 3.6, PDF page 19 (printed page 18), Proposition 2.
- `paper_proposition_2_decreasing_in_tauSpec` -> `paper_proposition_2_decreasing_in_tau`: Proposition 2 (Comparative Statics of F), agentic-AI precision τA, Section 3.6, PDF page 19 (printed page 18), Proposition 2 and the following paragraph.
-/

namespace AKO26KnowledgeCollapse

/--
Equation (6): expected period utility under Assumption 1 (ΔI = 0)

Paper statement: Under (5), P(|x - θ| ≤ 1) = G(X) and P(|y - θ_i| ≤ 1) = G(Y). Therefore, using the fact that ΔI = 0, agent i's expected period-t utility can be written as U = f(0,0) + G(X) ΔG + G(X) G(Y) ΔX - (ε/(ε+1)) e^((ε+1)/ε), where ΔG = f(1,0) - f(0,0), ΔI = f(0,1) - f(0,0), ΔX = f(1,1) - f(1,0) - f(0,1) + f(0,0).

Source location: Section 3.3, PDF page 15 (printed page 14), Equation (6); definitions of ΔG, ΔI, ΔX in Section 3.1, PDF page 10 (printed page 9)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_equation_6_expected_utilitySpec : Prop :=
  ∀ f00 f10 f01 f11 GX GY cost : ℝ,
    f01 - f00 = 0 →
      f00 * (1 - GX) * (1 - GY) + f10 * GX * (1 - GY) + f01 * (1 - GX) * GY + f11 * GX * GY
          - cost
        = f00 + GX * (f10 - f00) + GX * GY * (f11 - f10 - f01 + f00) - cost

/--
First-order condition for effort (Section 3.5)

Paper statement: Using (4), the first-order condition is ∂U/∂e = ΔX G(X) · λI g(σ^{-2} + λI e + τA) - e^{1/ε}.

Source location: Section 3.5, PDF page 16 (printed page 15), display after 'the first-order condition is'; also Section 3.4, PDF page 15 (printed page 14)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_first_order_conditionSpec : Prop :=
  ∀ (f00 ΔG ΔX p0 lamI τ X ε e : ℝ) (G g : ℝ → ℝ),
    0 < e → 0 < ε →
    HasDerivAt G (g (p0 + lamI * e + τ)) (p0 + lamI * e + τ) →
      HasDerivAt
        (fun e' : ℝ => f00 + G X * ΔG + G X * G (p0 + lamI * e' + τ) * ΔX
          - ε / (ε + 1) * e' ^ ((ε + 1) / ε))
        (ΔX * G X * lamI * g (p0 + lamI * e + τ) - e ^ (1 / ε)) e

/--
Observation 1, complement part: public precision complements human effort

Paper statement: Observation 1. Public precision Xt complements human effort, while agentic-AI precision τA substitutes for human effort. That is: ∂²U/∂e∂X > 0, ∂²U/∂e∂τA < 0. Formally, ∂U/∂e = ΔX G(X) λI g(Y) - e^{1/ε} ⇒ ∂²U/∂e∂X = ΔX λI g(X) g(Y) > 0.

Source location: Section 3.4, PDF pages 15-16 (printed pages 14-15), Observation 1 and the display ∂²U/∂e∂X = ΔX λI g(X) g(Y) > 0
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_observation_1_complementSpec : Prop :=
  ∀ (ΔX lamI p0 τ e X ε : ℝ) (G g : ℝ → ℝ),
    0 < ΔX → 0 < lamI → HasDerivAt G (g X) X → 0 < g X → 0 < g (p0 + lamI * e + τ) →
      HasDerivAt (fun X' : ℝ => ΔX * G X' * lamI * g (p0 + lamI * e + τ) - e ^ (1 / ε))
          (ΔX * lamI * g X * g (p0 + lamI * e + τ)) X
        ∧ 0 < ΔX * lamI * g X * g (p0 + lamI * e + τ)

/--
Observation 1, substitute part: agentic-AI precision substitutes for human effort

Paper statement: Because the probability of success G(Y) exhibits diminishing returns in precision, higher τA reduces the marginal gain from additional human effort: ∂²U/∂e∂τA = ΔX G(X) λI g'(Y) < 0.

Source location: Section 3.4, PDF page 16 (printed page 15), display ∂²U/∂e∂τA = ΔX G(X) λI g'(Y) < 0
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_observation_1_substituteSpec : Prop :=
  ∀ (ΔX lamI p0 τ e X ε : ℝ) (G g gd : ℝ → ℝ),
    0 < ΔX → 0 < lamI → 0 < G X →
    HasDerivAt g (gd (p0 + lamI * e + τ)) (p0 + lamI * e + τ) → gd (p0 + lamI * e + τ) < 0 →
      HasDerivAt (fun τ' : ℝ => ΔX * G X * lamI * g (p0 + lamI * e + τ') - e ^ (1 / ε))
          (ΔX * G X * lamI * gd (p0 + lamI * e + τ)) τ
        ∧ ΔX * G X * lamI * gd (p0 + lamI * e + τ) < 0

/--
Section 3.5: the marginal utility of effort is strictly decreasing in effort

Paper statement: The marginal benefit term is weakly decreasing in e because g(·) is decreasing, while the marginal cost e^{1/ε} is strictly increasing. Consequently, ∂U/∂e is strictly decreasing in e.

Source location: Section 3.5, PDF page 16 (printed page 15), text 'Consequently, ∂U/∂e is strictly decreasing in e'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_marginal_utility_strictly_decreasingSpec : Prop :=
  ∀ (ΔX lamI p0 τ X ε : ℝ) (G g : ℝ → ℝ),
    0 ≤ ΔX → 0 ≤ G X → 0 < lamI → 0 < ε → 0 < p0 → 0 ≤ τ →
    AntitoneOn g (Set.Ici p0) →
      StrictAntiOn (fun e : ℝ => ΔX * G X * lamI * g (p0 + lamI * e + τ) - e ^ (1 / ε))
        (Set.Ici 0)

/--
Section 3.5: the first-order condition has at most one solution (unique maximizer)

Paper statement: So U is strictly concave in effort and admits a unique and finite maximizer. Let us then define the best-response effort e(X, τA) as the unique solution to the first-order condition: e(X, τA) := {e ≥ 0 | ΔX G(X) · λI g(σ^{-2} + λI e + τA) = e^{1/ε}}.

Source location: Section 3.5, PDF page 16 (printed page 15), 'admits a unique and finite maximizer' and the definition of the best-response effort e(X, τA)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_best_response_uniqueSpec : Prop :=
  ∀ (ΔX lamI p0 τ X ε e1 e2 : ℝ) (G g : ℝ → ℝ),
    0 ≤ ΔX → 0 ≤ G X → 0 < lamI → 0 < ε → 0 < p0 → 0 ≤ τ →
    AntitoneOn g (Set.Ici p0) → 0 ≤ e1 → 0 ≤ e2 →
    ΔX * G X * lamI * g (p0 + lamI * e1 + τ) = e1 ^ (1 / ε) →
    ΔX * G X * lamI * g (p0 + lamI * e2 + τ) = e2 ^ (1 / ε) →
      e1 = e2

/--
Section 3.5: the first-order condition has a solution (a finite maximizer exists)

Paper statement: Moreover, we have ∂U/∂e at e=0 = ΔX G(X) · λI g(σ^{-2} + τA) ≥ 0 and lim_{e→+∞} ∂U/∂e < 0, so U is strictly concave in effort and admits a unique and finite maximizer.

Source location: Section 3.5, PDF page 16 (printed page 15), displays ∂U/∂e at e = 0 ≥ 0 and lim ∂U/∂e < 0, 'admits a unique and finite maximizer'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_best_response_existsSpec : Prop :=
  ∀ (ΔX lamI p0 τ X ε : ℝ) (G g : ℝ → ℝ),
    0 ≤ ΔX → 0 ≤ G X → 0 < lamI → 0 < ε → 0 < p0 → 0 ≤ τ →
    ContinuousOn g (Set.Ici p0) → AntitoneOn g (Set.Ici p0) →
    (∀ y ∈ Set.Ici p0, 0 ≤ g y) →
      ∃ e : ℝ, 0 ≤ e ∧ ΔX * G X * lamI * g (p0 + lamI * e + τ) = e ^ (1 / ε)

/--
Observation 2 (in X): best-response effort is increasing in public precision

Paper statement: Observation 2. The best-response effort e(X, τA) is increasing in X and decreasing in τA, strictly so for all X > 0. (Observation 1 together with standard monotone comparative statics arguments, e.g. Topkis' theorem.)

Source location: Section 3.5, PDF page 17 (printed page 16), Observation 2
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_observation_2_increasing_in_XSpec : Prop :=
  ∀ (ΔX lamI p0 τ ε GX1 GX2 e1 e2 : ℝ) (g : ℝ → ℝ),
    0 < ΔX → 0 < lamI → 0 < ε → 0 < p0 → 0 ≤ τ →
    AntitoneOn g (Set.Ici p0) → (∀ y ∈ Set.Ici p0, 0 < g y) →
    0 ≤ GX1 → GX1 < GX2 → 0 ≤ e1 → 0 ≤ e2 →
    ΔX * GX1 * lamI * g (p0 + lamI * e1 + τ) = e1 ^ (1 / ε) →
    ΔX * GX2 * lamI * g (p0 + lamI * e2 + τ) = e2 ^ (1 / ε) →
      e1 < e2

/--
Observation 2 (in τA): best-response effort is decreasing in agentic-AI precision

Paper statement: Observation 2. The best-response effort e(X, τA) is increasing in X and decreasing in τA, strictly so for all X > 0.

Source location: Section 3.5, PDF page 17 (printed page 16), Observation 2
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_observation_2_decreasing_in_tauSpec : Prop :=
  ∀ (ΔX lamI p0 τ1 τ2 X ε e1 e2 : ℝ) (G g : ℝ → ℝ),
    0 < ΔX → 0 < lamI → 0 < ε → 0 < p0 → 0 ≤ τ1 → τ1 < τ2 → 0 < G X →
    StrictAntiOn g (Set.Ici p0) → 0 ≤ e1 → 0 ≤ e2 →
    ΔX * G X * lamI * g (p0 + lamI * e1 + τ1) = e1 ^ (1 / ε) →
    ΔX * G X * lamI * g (p0 + lamI * e2 + τ2) = e2 ^ (1 / ε) →
      e2 < e1

/--
Lemma 1 (monotonicity): the state transition map F is strictly increasing

Paper statement: Lemma 1. The state transition map F is continuous and strictly increasing on R≥0, with F(0) = 0 and F(+∞) = Σ^{-2}. Here F(X) := [Σ² + (X + λG I e(X, τA))^{-1}]^{-1}.

Source location: Section 3.6, PDF page 18 (printed page 17), Lemma 1; transition map F defined in Equation (8), PDF page 17 (printed page 16)
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_lemma_1_transition_strictly_increasingSpec : Prop :=
  ∀ (Sig2 lamG I : ℝ) (e : ℝ → ℝ),
    0 < Sig2 → 0 < lamG → 0 < I → MonotoneOn e (Set.Ici 0) → (∀ X, 0 ≤ e X) →
      StrictMonoOn (fun X : ℝ => (Sig2 + (X + lamG * I * e X)⁻¹)⁻¹) (Set.Ioi 0)

/--
Lemma 1 (bounds): the transition map takes values in (0, Σ^{-2})

Paper statement: Public precision can never exceed Σ^{-2} and thus F maps into a bounded interval: 0 ≤ F(X) < Σ^{-2} for all finite X.

Source location: Section 3.5, PDF page 18 (printed page 17), display '0 ≤ F(X) < Σ^{-2} for all finite X'
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_lemma_1_transition_boundsSpec : Prop :=
  ∀ (Sig2 lamG I X eX : ℝ),
    0 < Sig2 → 0 < lamG → 0 < I → 0 < X → 0 ≤ eX →
      0 < (Sig2 + (X + lamG * I * eX)⁻¹)⁻¹ ∧ (Sig2 + (X + lamG * I * eX)⁻¹)⁻¹ < Sig2⁻¹

/--
Proposition 2 (Comparative Statics of F), aggregation scale I

Paper statement: Proposition 2 (Comparative Statics of F). The function F is pointwise increasing in I and pointwise decreasing in τA, strictly so for all X > 0.

Source location: Section 3.6, PDF page 19 (printed page 18), Proposition 2
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_proposition_2_increasing_in_ISpec : Prop :=
  ∀ (Sig2 lamG I1 I2 X eX : ℝ),
    0 < Sig2 → 0 < lamG → 0 < I1 → I1 < I2 → 0 < X → 0 < eX →
      (Sig2 + (X + lamG * I1 * eX)⁻¹)⁻¹ < (Sig2 + (X + lamG * I2 * eX)⁻¹)⁻¹

/--
Proposition 2 (Comparative Statics of F), agentic-AI precision τA

Paper statement: A higher agentic-AI precision τA depresses effort today (since recommendations substitute for private learning), reducing the flow of new human-generated knowledge into the stock of general knowledge: F is pointwise decreasing in τA, strictly so for all X > 0.

Source location: Section 3.6, PDF page 19 (printed page 18), Proposition 2 and the following paragraph
Source status: pinned statement-spec transcription; independent source audit pending

This transparent proposition is the exact statement-audit target. It is not
proof evidence. Its exact-type proof endpoint is declared in
`ProofInterface.lean`, so this human-facing file presents the full semantic
proposition once. At closeout, source atoms must be independently inventoried
from pinned source quote bytes and bound to this elaborated proposition rather
than inferred from identifiers.
-/
def paper_proposition_2_decreasing_in_tauSpec : Prop :=
  ∀ (Sig2 lamG I X e1 e2 : ℝ),
    0 < Sig2 → 0 < lamG → 0 < I → 0 < X → 0 ≤ e2 → e2 < e1 →
      (Sig2 + (X + lamG * I * e2)⁻¹)⁻¹ < (Sig2 + (X + lamG * I * e1)⁻¹)⁻¹

end AKO26KnowledgeCollapse
