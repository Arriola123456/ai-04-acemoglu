# Final Validation Report: Acemoglu, Kong and Ozdaglar (2026), AI, Human Cognition and Knowledge Collapse
Updated: 2026-09-09

## 1. Human Verdict
Partially formalized. The static block of the model — Sections 3.1 to 3.6 of
the May 5, 2026 version — is checked with closed Lean proofs: the expected
utility of Equation (6) under Assumption 1, the first-order condition as an
actual derivative, both cross-partial signs of Observation 1 (general knowledge
complements effort, agentic-AI precision substitutes for it), the strict
monotonicity of the marginal utility of effort, existence and uniqueness of the
best-response effort, Observation 2 in both arguments, Lemma 1 (monotonicity
and bounds of the transition map) and Proposition 2 (comparative statics of the
transition map in the aggregation scale and in agentic precision). The paper
does not reach `formalized` for three reasons. The Gaussian facts about the
success probability $G(\tau) = 2\Phi(\sqrt\tau) - 1$ and its derivative
$g$ — $G' = g > 0$, $g$ decreasing, $G > 0$ on $(0,\infty)$ — enter as
hypotheses rather than being derived from the normal distribution. The dynamic
results (Lemma 2, Propositions 3–16) and the welfare section are not
formalized. And the protocol's independent semantic audits were not executed.

## 2. Closeout Status
- Completion status: partially formalized
- One-sentence recap: thirteen of thirteen selected static statements proved;
  Gaussian properties and the boundary $X = 0$ are declared boundaries;
  dynamics and welfare out of scope.

## 3. Source and Scope
- Paper: AI, Human Cognition and Knowledge Collapse (Daron Acemoglu, Dingwen
  Kong, Asuman Ozdaglar)
- Source version: MIT working-paper version dated May 5, 2026 (NBER Working
  Paper 34910, issued February 2026). The February version has the same
  section structure and the same statements; it parametrizes the effort cost
  by a curvature $\alpha$ with $\alpha - 1 = 1/\varepsilon$, so its threshold
  "$\alpha - 1 > 1/4$" is the May version's "$\varepsilon < 4$".
- Lean folder: `papers/AKO26KnowledgeCollapse`
- Human-facing theorem file: `papers/AKO26KnowledgeCollapse/PaperInterface.lean`
- Paper assumption file: `papers/AKO26KnowledgeCollapse/Assumptions.lean`
  (empty: every premise is a visible binder)
- DAG artifacts: `papers/AKO26KnowledgeCollapse/docs/DependencyDAG.tex`,
  `papers/AKO26KnowledgeCollapse/docs/DependencyDAG.pdf`
- Lean footprint: four paper modules; `lake build AKO26KnowledgeCollapse`
  completes with no errors.
- Scope: Sections 3.1–3.6 (environment, beliefs, equilibrium definition,
  substitutes and complements, existence and characterization, the transition
  map's basic properties). Out of scope: Lemma 2 and Propositions 3–8
  (steady states, collapse), Section 4 (welfare, information design),
  Section 5 (extensions), appendices.

## 4. Researcher Summary of Checked Results
At a fixed agent and period, a decision succeeds on the general component
with probability $G(X)$ (public precision $X$) and on the context-specific
component with probability $G(Y)$, $Y = \sigma^{-2} + \lambda_I e + \tau_A$.
With $\Delta_I = 0$ the expected utility is
$U = f(0,0) + G(X)\Delta_G + G(X)G(Y)\Delta_X - \tfrac{\varepsilon}{\varepsilon+1}e^{(\varepsilon+1)/\varepsilon}$;
Lean checks the algebraic decomposition behind this display for independent
success events. The derivative of $U$ in effort is
$\Delta_X G(X)\lambda_I g(Y) - e^{1/\varepsilon}$, obtained in Lean by the
chain rule from $G' = g$ and the derivative of the power cost.

Observation 1 is checked in both parts: the marginal utility of effort has
derivative $\Delta_X\lambda_I g(X)g(Y) > 0$ in $X$ and
$\Delta_X G(X)\lambda_I g'(Y) < 0$ in $\tau_A$, under $\Delta_X > 0$,
$\lambda_I > 0$, $g > 0$, $G(X) > 0$ and $g' < 0$.

The marginal utility of effort is strictly decreasing in effort whenever $g$
is decreasing on $[\sigma^{-2}, \infty)$, so the first-order condition has at
most one solution; it has a solution because the marginal utility is
nonnegative at zero effort, negative at effort $(C+1)^\varepsilon$ (with
$C$ the marginal benefit at zero effort), and continuous in between.

Observation 2 is checked as a comparison of first-order-condition solutions:
if $G(X_1) < G(X_2)$ then the effort solving the condition at $X_2$ exceeds
the one at $X_1$; if $\tau_1 < \tau_2$ and $g$ is strictly decreasing, the
effort at $\tau_2$ is smaller.

Lemma 1 is checked in the form: for any nondecreasing nonnegative effort
schedule, $X \mapsto [\Sigma^2 + (X + \lambda_G I e(X))^{-1}]^{-1}$ is
strictly increasing on $(0,\infty)$ and takes values in $(0, \Sigma^{-2})$.
Proposition 2 is checked pointwise: the map is strictly increasing in $I$
(for $X > 0$ and positive effort) and, since a higher $\tau_A$ lowers effort,
strictly decreasing in $\tau_A$.

## 5. Remaining Boundaries and Gaps
- Gaussian boundary: $G$, $g$ and $g'$ are abstract functions with the
  properties the paper states; the identities $G(\tau) = 2\Phi(\sqrt\tau)-1$,
  $g(\tau) = \varphi(\sqrt\tau)/\sqrt\tau$ and the sign of $g'$ are not
  derived in Lean (checked symbolically with SymPy in the course repository).
- Boundary $X = 0$: the transition statements are on $X > 0$; the paper's
  $F(0) = 0$ relies on the convention $1/0 = +\infty$, whereas Lean's real
  inverse gives $0^{-1} = 0$ and the formula returns $\Sigma^{-2}$ at $X = 0$
  with zero effort (recorded as an extension theorem).
- Observation 2 is stated as a comparison of two first-order-condition
  solutions rather than as monotonicity of a function $e(X, \tau_A)$; the
  existence and uniqueness rows justify the function.
- Lemma 1's continuity claim and $F(+\infty) = \Sigma^{-2}$ are not
  formalized; the bounds row gives $F(X) < \Sigma^{-2}$.
- Lemma 2, Propositions 3–16, Section 4 and Section 5: not formalized.
- LLM-as-judge and human semantic audits of the review surface were not run.

## 6. Additional Assumptions Beyond Paper
- $\tau_A \ge 0$ and $\sigma^{-2} > 0$ are used to keep the argument of $g$
  in $[\sigma^{-2}, \infty)$; both are source conditions ($\tau_A \ge 0$ on
  page 12, $\sigma^2$ finite).
- The monotonicity of $g$ is required only on $[\sigma^{-2}, \infty)$, and
  the existence row additionally uses continuity of $g$ there; these are
  properties of the Gaussian, listed here because they are hypotheses in Lean.

## 7. Proof-Strategy Deviations
- Observation 2 is proved directly from the strict monotonicity of the
  marginal utility (a two-solution comparison) instead of invoking Topkis'
  theorem as the source does; the conclusion is the same.
- Existence of the best response uses the explicit bracket
  $[0, (C+1)^\varepsilon]$ and the intermediate value theorem instead of the
  source's limit argument.

## 8. Proof Tricks Worth Reusing
- Stating cross-partials as `HasDerivAt` of the marginal utility in the
  other variable keeps Observation 1 a one-line chain-rule computation.
- The transition map's comparative statics reduce to one lemma:
  $A \mapsto (\Sigma^2 + A^{-1})^{-1}$ is strictly increasing on positives.

## 9. Generalizations, Conjectures, and Extensions
- `transition_at_zero_lean_convention`: Lean's `0⁻¹ = 0` makes the transition
  formula return $\Sigma^{-2}$ at $X = 0$ with zero effort.
- `effort_incentive_survives_without_general_knowledge` and
  `transition_positive_with_effort`: if the production-side assumption
  $\Delta_I = 0$ (Assumption 1) were dropped, the private marginal benefit of
  effort at $X = 0$ would be $\Delta_I\lambda_I g(\sigma^{-2}+\tau_A) > 0$
  and the transition map would be positive at $X = 0$, so the
  knowledge-collapse steady state (9) would no longer be a fixed point. This
  is the one production-side assumption the paper never relaxes (Section 5
  relaxes aggregation, synthetic data and effort separability only).

## 10. Mathematical Typos or Other Fixes Suggested in the Source Paper
- Lemma 1 states $F(0) = 0$ on $\mathbb{R}_{\ge 0}$; the formula (8) needs
  the convention $(0)^{-1} = +\infty$ at $X = 0$ (footnote 6 gives
  $e(0,\tau_A) = 0$). This is a convention, not an error; the formal
  statement is on $X > 0$ with $F(0) = 0$ as a separate definition.

## 11. Paper Issues or Caveats
None.

## 12. Detailed Formalization Evidence
- `lake build AKO26KnowledgeCollapse`: Build completed successfully (4000 jobs).
- `python3 scripts/paper_contribution.py check AKO26KnowledgeCollapse --fast`:
  exit code 0 (focused interface build, semantic import isolation, and
  `git diff --check` all passed); see `docs/CHECK_FAST_OUTPUT.txt`.
- No declaration in the paper folder uses `sorry`, `axiom` or `unsafe`.
- `Assumptions.lean` declares nothing.

## 13. Paper Assumption Provenance
| Assumption declaration | Lean declaration | Source location / statement | Assumption validators | Comments |
| --- | --- | --- | --- | --- |
| None | `none` | Assumption 1 ($\Delta_I = 0$, $\Delta_X > 0$) enters as the binder `f01 - f00 = 0` in the Equation (6) row and as `0 < ΔX` elsewhere | None | No axiom-like premise. |

## 14. Displayed Formula Provenance
| Paper formula / subclaim | Lean declaration | Provenance | Validators | Comments |
| --- | --- | --- | --- | --- |
| Equation (6) | `paper_equation_6_expected_utilitySpec` | derived in Lean (`ring`) | Lean build | independence of the two success events is the source's Gaussian structure |
| First-order condition | `paper_first_order_conditionSpec` | derived in Lean (chain rule, `rpow` derivative) | Lean build | $e > 0$, $\varepsilon > 0$ |
| $\partial^2 U/\partial e\partial X$ | `paper_observation_1_complementSpec` | derived in Lean | Lean build | $g > 0$ hypothesis |
| $\partial^2 U/\partial e\partial\tau_A$ | `paper_observation_1_substituteSpec` | derived in Lean | Lean build | $g' < 0$, $G(X) > 0$ hypotheses |
| Transition map bounds | `paper_lemma_1_transition_boundsSpec` | derived in Lean | Lean build | $X > 0$ |

## 15. Library Lift Pass
- Reusable library extraction candidates: the two-solution comparison
  argument for monotone comparative statics of a first-order condition.
- Library certificate/source-boundary audit: not run; no certificate-taking
  library API is used.
- Paper-local hidden-premise audit: not run; all premises are visible binders.

## 16. DAG Audit
- Rendered artifact: `docs/DependencyDAG.pdf` rendered from
  `docs/DependencyDAG.tex`.
- Topology: model definitions feed Equation (6); the FOC feeds Observation 1,
  the strict decrease, existence and uniqueness; those feed Observation 2;
  Observation 2 feeds Proposition 2 through the effort schedule; Lemma 1
  stands on the transition formula.
- Layout: checked visually.

## 17. Validation Checks
- Targeted Lean build: passed.
- Statement precheck / assumption precheck / repository audit / LLM audits:
  not run (see Section 5).

## 18. Paper Definitions Checked
- Success probabilities $G(X)$, $G(Y)$ and the expected-utility decomposition
  (Equation (6)); the effort cost $\tfrac{\varepsilon}{\varepsilon+1}e^{(\varepsilon+1)/\varepsilon}$.
- Idiosyncratic precision $Y = \sigma^{-2} + \lambda_I e + \tau_A$ (Equation (4)).
- The transition map $F$ (Equation (8)).

## 19. Named Theorem Statements Checked
### Observation 1
**Paper statement.** $\partial^2 U/\partial e\partial X > 0$ and
$\partial^2 U/\partial e\partial\tau_A < 0$.

**Lean interface statement.**
- `paper_observation_1_complementSpec`, `paper_observation_1_substituteSpec`.

**Status.** formalized (with the Gaussian properties as hypotheses).

### Observation 2
**Paper statement.** $e(X,\tau_A)$ increasing in $X$, decreasing in $\tau_A$,
strictly for $X > 0$.

**Lean interface statement.**
- `paper_observation_2_increasing_in_XSpec`,
  `paper_observation_2_decreasing_in_tauSpec` (two-solution comparisons).

**Status.** formalized under the representation of Section 5.

### Lemma 1
**Paper statement.** $F$ continuous and strictly increasing on
$\mathbb{R}_{\ge 0}$, $F(0) = 0$, $F(+\infty) = \Sigma^{-2}$.

**Lean interface statement.**
- `paper_lemma_1_transition_strictly_increasingSpec` (on $(0,\infty)$),
  `paper_lemma_1_transition_boundsSpec`.

**Status.** partially formalized (continuity and the limits not formalized;
boundary convention at $X = 0$).

### Proposition 2
**Paper statement.** $F$ pointwise increasing in $I$, decreasing in $\tau_A$,
strictly for $X > 0$.

**Lean interface statement.**
- `paper_proposition_2_increasing_in_ISpec`,
  `paper_proposition_2_decreasing_in_tauSpec`.

**Status.** formalized.

## 20. Paper-Facing Statement Validator Ledger
| Paper-facing statement | Lean declaration | Validators | Validator comments |
| --- | --- | --- | --- |
| Equation (6) | `paper_equation_6_expected_utilitySpec` | Lean build 2026-09-09 | proof closed |
| First-order condition | `paper_first_order_conditionSpec` | Lean build 2026-09-09 | proof closed |
| Observation 1 (X) | `paper_observation_1_complementSpec` | Lean build 2026-09-09 | proof closed |
| Observation 1 (τ) | `paper_observation_1_substituteSpec` | Lean build 2026-09-09 | proof closed |
| MU strictly decreasing | `paper_marginal_utility_strictly_decreasingSpec` | Lean build 2026-09-09 | proof closed |
| Best response unique | `paper_best_response_uniqueSpec` | Lean build 2026-09-09 | proof closed |
| Best response exists | `paper_best_response_existsSpec` | Lean build 2026-09-09 | proof closed |
| Observation 2 (X) | `paper_observation_2_increasing_in_XSpec` | Lean build 2026-09-09 | proof closed |
| Observation 2 (τ) | `paper_observation_2_decreasing_in_tauSpec` | Lean build 2026-09-09 | proof closed |
| Lemma 1 (monotone) | `paper_lemma_1_transition_strictly_increasingSpec` | Lean build 2026-09-09 | on X > 0 |
| Lemma 1 (bounds) | `paper_lemma_1_transition_boundsSpec` | Lean build 2026-09-09 | proof closed |
| Proposition 2 (I) | `paper_proposition_2_increasing_in_ISpec` | Lean build 2026-09-09 | proof closed |
| Proposition 2 (τ) | `paper_proposition_2_decreasing_in_tauSpec` | Lean build 2026-09-09 | proof closed |

## 21. Source-Coverage Audit Ledger
- Source inventory: 13 statements inventoried from the pinned May 5, 2026 PDF
  (`paper.pdf`, SHA-256
  `63e37f2af463422e587c9bd81cda3bb555404a6ad65763aca0f9bebb8e2d4ec6`).
- Coverage result: 13 direct rows; Lemma 2, Propositions 1 and 3–16 and the
  welfare section out-of-scope.
- LLM-as-judge coverage audit: not run.
- Row-local statement checks: not run.

| Source statement | Linked Lean review rows | Coverage judgment | Row-local statement checks | Comments |
| --- | --- | --- | --- | --- |
| Equation (6), FOC | two rows | covered | pending | algebra and calculus |
| Observation 1 | two rows | covered (Gaussian boundary) | pending | hypotheses on G, g |
| Section 3.5 (decreasing MU, existence, uniqueness) | three rows | covered | pending | — |
| Observation 2 | two rows | conditional boundary (two-solution form) | pending | — |
| Lemma 1, Proposition 2 | four rows | covered on X > 0 | pending | boundary convention |
| Lemma 2, Propositions 1, 3–16, Section 4–5 | none | out-of-scope | — | dynamics, welfare, extensions |
