# Repository 4 — Acemoglu, Kong & Ozdaglar (2026)

*AI, Human Cognition and Knowledge Collapse.* NBER Working Paper 34910 (issued
February 2026). **Version read and pinned:** the MIT working-paper PDF dated
**May 5, 2026** (69 pp., SHA-256 `63e37f2a…2d4ec6`), the one the course
repository links. The February and May versions have the same sections and
statements; February writes the effort cost with a curvature $\alpha$ and its
stability threshold as $\alpha - 1 > 1/4$, May uses the Frisch elasticity
$\varepsilon$ with $\alpha - 1 = 1/\varepsilon$, i.e. $\varepsilon < 4$. The
issue's "Section 2" is *Related Literature* in both versions; the model is
Section 3 (the static problem in 3.1–3.5, Observation 1 in 3.4).

> **Tools, stated up front.** Everything below — the reading, the Lean
> formalization through EconCSLib, the numerics, this README and the deck — was
> produced with Claude Code in one session, whose prompts are in `prompts.md`
> (no Codex run this week; the issue does not mandate one). The LLM "cold"
> prompts required by the trap are recorded in `prompts.md` as well.

---

## What question the paper answers

Agentic AI gives every person accurate, context-specific advice. Does that
erode the *general* knowledge which makes context-specific information useful
in the first place — and can a community lose it altogether? The answer is a
model in which the same human effort produces private, context-specific
knowledge (internalised) and a thin public contribution to general knowledge
(an externality). Agentic AI substitutes for that effort; general knowledge
complements it. When effort is elastic enough, a better AI can push the
economy into a **knowledge-collapse** steady state.

## The agent's problem

Each period a short-lived agent $i$ predicts a common state $\theta_t$
(general knowledge, a random walk) and her own idiosyncratic state
$\theta_{i,t}$ (her context). Output is
$f(\mathbf 1\{|x-\theta_t|\le 1\},\mathbf 1\{|y-\theta_{i,t}|\le 1\})$ with
$\Delta_G = f(1,0)-f(0,0)$, $\Delta_I = f(0,1)-f(0,0)$,
$\Delta_X = f(1,1)-f(1,0)-f(0,1)+f(0,0)$ and $\Delta_G+\Delta_I+\Delta_X = 1$.

**Assumption 1.** $\Delta_I = 0$ and $\Delta_X > 0$: context-specific knowledge
alone creates no value.

Effort $e \ge 0$ costs $\tfrac{\varepsilon}{\varepsilon+1}e^{(\varepsilon+1)/\varepsilon}$
($\varepsilon$ the Frisch elasticity) and yields a private signal on
$\theta_{i,t}$ with precision $\lambda_I e$ and a public signal on $\theta_t$
with precision $\lambda_G E$, $E$ the island's aggregate effort. Agentic AI adds
a signal on $\theta_{i,t}$ with precision $\tau_A \ge 0$. With Gaussian
signals the public precision $X_t$ summarises general knowledge and the
idiosyncratic precision is $Y = \sigma^{-2} + \lambda_I e + \tau_A$
(Equation 4). Predictions are posterior means, a unit-tolerance success has
probability $G(\tau) = 2\Phi(\sqrt\tau) - 1$ with $g = G' = \varphi(\sqrt\tau)/\sqrt\tau$,
and under $\Delta_I = 0$ (Equation 6)

$$U = f(0,0) + G(X)\Delta_G + G(X)G(Y)\Delta_X - \tfrac{\varepsilon}{\varepsilon+1}e^{\frac{\varepsilon+1}{\varepsilon}},
\qquad
\frac{\partial U}{\partial e} = \Delta_X G(X)\lambda_I\,g(Y) - e^{1/\varepsilon}.$$

The agent chooses $e$ taking $X$ and $\tau_A$ as given; the general knowledge
she creates is an externality she does not internalise.

## The main result, with all its conditions

**Observation 1 (Section 3.4).** *Public precision complements human effort,
agentic-AI precision substitutes for it:*

$$\frac{\partial^2 U}{\partial e\,\partial X} = \Delta_X\lambda_I\,g(X)\,g(Y) > 0,
\qquad
\frac{\partial^2 U}{\partial e\,\partial\tau_A} = \Delta_X G(X)\lambda_I\,g'(Y) < 0.$$

Conditions, spelled out:

1. **Assumption 1** — $\Delta_I = 0$ makes the private return to effort run
   entirely through the complementarity term $G(X)G(Y)\Delta_X$; $\Delta_X > 0$.
2. $\lambda_I > 0$, and $X > 0$ so that $G(X) > 0$ (at $X = 0$ effort is
   worthless and the best response is $0$, footnote 6).
3. Gaussian facts: $G' = g > 0$ and $g' < 0$ — the success probability has
   diminishing returns in precision.
4. Additive precision $Y = \sigma^{-2} + \lambda_I e + \tau_A$: the AI signal
   and the agent's own learning are perfect substitutes in producing
   context-specific precision.
5. Posterior-mean predictions (Equation 5) and independence of the two
   prediction errors given the information set, which is what turns
   $E[f(\cdot,\cdot)]$ into Equation 6.

**Observation 2** (Topkis): the best response $e(X,\tau_A)$ is increasing in
$X$ and decreasing in $\tau_A$, strictly for $X > 0$.

**Consequences (read-only in this repo):** the transition map
$F(X) = [\Sigma^2 + (X + \lambda_G I\,e(X,\tau_A))^{-1}]^{-1}$ is strictly
increasing with $0 \le F < \Sigma^{-2}$ (Lemma 1), shifts up in $I$ and down
in $\tau_A$ (Proposition 2). With $\varepsilon < 4$ there is a unique positive
steady state (Proposition 3); with $\varepsilon > 4$ the zero-knowledge state
is locally stable and above a threshold $\tau_A^c$ complete collapse is the
only outcome (Proposition 5).

**What the result does not claim:** that AI lowers each person's
context-specific precision — $\bar Y_h$ rises with $\tau_A$ at first
(Propositions 4, 8). The loss is in the *public* stock $X$, through effort.

## This week's trap

**Is welfare increasing in AI accuracy?** No. Steady-state welfare
$\bar U^+ = G(\bar X_h)\Delta_G + G(\bar X_h)G(\bar Y_h)\Delta_X - \text{cost}$
has derivative (Section 4.3)

$$\frac{\partial\bar U^+}{\partial\tau_A}
= \underbrace{g(\bar Y_h)G(\bar X_h)\Delta_X}_{\text{direct} \ \ge 0}
+ \underbrace{\frac{\partial G(\bar X_h)}{\partial\tau_A}\big(\Delta_G + G(\bar Y_h)\Delta_X\big)}_{\text{indirect} \ \le 0},$$

and the ratio indirect/direct rises with $\tau_A$: the direct gain has
diminishing returns ($g$ falls), the indirect loss grows as $\bar X_h$ falls.
With Assumption 2 ($\sigma^{-2} \ge \sqrt2 - 1$): for $\varepsilon < 4$,
$\bar U^+$ is strictly increasing on $(0,\tau_A^\star)$, strictly decreasing
after, and $\to 0$ (Proposition 10); for $\varepsilon > 4$ the same up to
$\tau_A^c$, then $\bar U^+ = 0$ — a discontinuous collapse (Proposition 11).
Both thresholds grow only like $\log I$ (Proposition 12). The numerics in
`analysis/` reproduce the hump ($\tau_A^\star \approx 1.0$ for $\varepsilon = 2$)
and the cliff ($\tau_A^c \approx 0.30$ for $\varepsilon = 6$).

**Which assumptions do the authors relax, and which one never?** Section 5
relaxes three *learning-side* assumptions: AI can also improve aggregation,
$I(\tau_A) = I_0 + e^{\eta\tau_A}$ (5.1, results survive if $\eta < \varepsilon/2$);
synthetic data adds precision $\tau_{syn}$ to the public signal (5.2, a floor
under $X$); effort can be partially separable, public signal $\propto e^\beta$
(5.3, threshold $\varepsilon < 4/\beta$). The **production-side** assumption
they never relax is Assumption 1's $\Delta_I = 0$. It is what makes the private
return to effort vanish with general knowledge, what makes $(\bar X,\bar e) = (0,0)$
a steady state, and what gives the collapse state welfare $0$. With
$\Delta_I > 0$ the marginal benefit of effort at $X = 0$ is
$\Delta_I\lambda_I g(\sigma^{-2}+\tau_A) > 0$, effort stays positive, and
$F(0) > 0$: the collapse fixed point disappears. Both facts are proved in Lean
(`lean/MainTheorems.lean`, extension theorems). A second untouched one: the
additive precision in Equation 4, i.e. AI and own learning as perfect
substitutes for context.

## What is in this repository

| File | What it is |
|---|---|
| `README.md` | This page |
| `prompts.md` | Raw prompts and answers: the Claude Code session, and the LLM "cold" prompts of the trap |
| `hand/derivacion-a-mano.pdf` | Hand derivation of Equation 6 and of both cross-partials of Observation 1 |
| `presentation.tex` / `.pdf` | The 5-minute deck (title + 4 slides) followed by backup slides: five figures, one per slide, three Lean slides, and the trap |
| `lean/` | The EconCSLib paper folder `papers/AKO26KnowledgeCollapse/` as generated: 13 Specs, 13 closed proofs, reports, DAG, audit stubs, `docs/RUN_LOG.md`, `docs/CHECK_FAST_OUTPUT.txt` |
| `analysis/` | `model_numerics.py`: SymPy check of Observation 1 with the real Gaussian, best response, transition maps, welfare; figures in `analysis/figures/` |
| `paper/README.md` | Pointer to both versions of the article (PDFs not committed) |

## The Lean component in one paragraph

Thirteen source-facing statements of Sections 3.1–3.6 were pinned to the May
PDF in an EconCSLib statement spec, scaffolded with `paper_contribution.py new`
and proved with no `sorry`: Equation 6 (the expected-output decomposition
under $\Delta_I = 0$), the first-order condition as a `HasDerivAt`, both
cross-partial signs of Observation 1, strict decrease of the marginal utility,
existence (intermediate value theorem on $[0,(C+1)^\varepsilon]$) and
uniqueness of the best response, Observation 2 in $X$ and in $\tau_A$ as
comparisons of two first-order-condition solutions, Lemma 1 (monotonicity and
bounds of $F$ on $X > 0$) and Proposition 2 in $I$ and $\tau_A$.
`lake build AKO26KnowledgeCollapse` completes; `check --fast` exits 0
(`lean/docs/CHECK_FAST_OUTPUT.txt`). Status **partially formalized**: the
Gaussian facts about $G$ and $g$ are hypotheses (checked symbolically with
SymPy, not derived in Lean), the transition map is stated on $X > 0$ because
Lean's $0^{-1} = 0$ would return $\Sigma^{-2}$ at $X = 0$ where the paper
writes $F(0) = 0$, and the dynamics and welfare sections are not formalized.
`lean/FINAL_VALIDATION_REPORT.md` has the full ledger.
