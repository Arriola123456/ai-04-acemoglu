import AKO26KnowledgeCollapse.PaperInterface

/-!
# Proof Interface: AI, Human Cognition and Knowledge Collapse

This file contains exact-type proof endpoints for the transparent propositions
in `PaperInterface.lean`. It is not a human semantic-review surface: one source
claim is reviewed once, against its expanded `...Spec : Prop` declaration.
-/

namespace AKO26KnowledgeCollapse

/--
Lean proof endpoint for `paper_equation_6_expected_utilitySpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_equation_6_expected_utility :
  paper_equation_6_expected_utilitySpec := by
  intro f00 f10 f01 f11 GX GY cost h
  have : f01 = f00 := by linarith
  subst this
  ring

/--
Lean proof endpoint for `paper_first_order_conditionSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_first_order_condition :
  paper_first_order_conditionSpec := by
  intro f00 ΔG ΔX p0 lamI τ X ε e G g he hε hG
  have hε' : ε ≠ 0 := hε.ne'
  have hε1 : ε + 1 ≠ 0 := by linarith
  have hexp : (ε + 1) / ε - 1 = 1 / ε := by field_simp; ring
  have h1 : HasDerivAt (fun e' : ℝ => p0 + lamI * e' + τ) (lamI * 1) e :=
    (((hasDerivAt_id' (x := e)).const_mul lamI).const_add p0).add_const τ
  have h2 : HasDerivAt (fun e' : ℝ => G (p0 + lamI * e' + τ))
      (g (p0 + lamI * e + τ) * (lamI * 1)) e :=
    hG.comp e h1
  have h3 : HasDerivAt (fun e' : ℝ => G X * G (p0 + lamI * e' + τ) * ΔX)
      (G X * (g (p0 + lamI * e + τ) * (lamI * 1)) * ΔX) e :=
    (h2.const_mul (G X)).mul_const ΔX
  have h4 : HasDerivAt (fun e' : ℝ => e' ^ ((ε + 1) / ε)) ((ε + 1) / ε * e ^ (1 / ε)) e := by
    have := Real.hasDerivAt_rpow_const (x := e) (p := (ε + 1) / ε) (Or.inl he.ne')
    rwa [hexp] at this
  have h5 : HasDerivAt (fun e' : ℝ => ε / (ε + 1) * e' ^ ((ε + 1) / ε))
      (ε / (ε + 1) * ((ε + 1) / ε * e ^ (1 / ε))) e := h4.const_mul _
  have h6 := ((hasDerivAt_const e (f00 + G X * ΔG)).add h3).sub h5
  refine h6.congr_deriv ?_
  field_simp
  ring

/--
Lean proof endpoint for `paper_observation_1_complementSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_observation_1_complement :
  paper_observation_1_complementSpec := by
  intro ΔX lamI p0 τ e X ε G g hΔ hlam hG hgX hgY
  refine ⟨?_, ?_⟩
  · have h := (((hG.const_mul ΔX).mul_const lamI).mul_const (g (p0 + lamI * e + τ))).sub_const
      (e ^ (1 / ε))
    exact h.congr_deriv (by ring)
  · exact mul_pos (mul_pos (mul_pos hΔ hlam) hgX) hgY

/--
Lean proof endpoint for `paper_observation_1_substituteSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_observation_1_substitute :
  paper_observation_1_substituteSpec := by
  intro ΔX lamI p0 τ e X ε G g gd hΔ hlam hGX hg hgd
  refine ⟨?_, ?_⟩
  · have h1 : HasDerivAt (fun τ' : ℝ => p0 + lamI * e + τ') 1 τ :=
      (hasDerivAt_id' (x := τ)).const_add (p0 + lamI * e)
    have h2 : HasDerivAt (fun τ' : ℝ => g (p0 + lamI * e + τ'))
        (gd (p0 + lamI * e + τ) * 1) τ :=
      hg.comp τ h1
    have h3 := (h2.const_mul (ΔX * G X * lamI)).sub_const (e ^ (1 / ε))
    exact h3.congr_deriv (by ring)
  · exact mul_neg_of_pos_of_neg (mul_pos (mul_pos hΔ hGX) hlam) hgd

/--
Lean proof endpoint for `paper_marginal_utility_strictly_decreasingSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_marginal_utility_strictly_decreasing :
  paper_marginal_utility_strictly_decreasingSpec := by
  intro ΔX lamI p0 τ X ε G g hΔ hG hlam hε hp0 hτ hanti
  intro e1 he1 e2 he2 hlt
  simp only [Set.mem_Ici] at he1 he2
  change ΔX * G X * lamI * g (p0 + lamI * e2 + τ) - e2 ^ (1 / ε)
    < ΔX * G X * lamI * g (p0 + lamI * e1 + τ) - e1 ^ (1 / ε)
  have hY1 : p0 + lamI * e1 + τ ∈ Set.Ici p0 := by
    simp only [Set.mem_Ici]; nlinarith
  have hY2 : p0 + lamI * e2 + τ ∈ Set.Ici p0 := by
    simp only [Set.mem_Ici]; nlinarith
  have hYle : p0 + lamI * e1 + τ ≤ p0 + lamI * e2 + τ := by nlinarith
  have hg : g (p0 + lamI * e2 + τ) ≤ g (p0 + lamI * e1 + τ) := hanti hY1 hY2 hYle
  have hcoef : 0 ≤ ΔX * G X * lamI := mul_nonneg (mul_nonneg hΔ hG) hlam.le
  have hben : ΔX * G X * lamI * g (p0 + lamI * e2 + τ)
      ≤ ΔX * G X * lamI * g (p0 + lamI * e1 + τ) :=
    mul_le_mul_of_nonneg_left hg hcoef
  have hcost : e1 ^ (1 / ε) < e2 ^ (1 / ε) := Real.rpow_lt_rpow he1 hlt (by positivity)
  linarith

/--
Lean proof endpoint for `paper_best_response_uniqueSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_best_response_unique :
  paper_best_response_uniqueSpec := by
  intro ΔX lamI p0 τ X ε e1 e2 G g hΔ hG hlam hε hp0 hτ hanti he1 he2 h1 h2
  have hmu := paper_marginal_utility_strictly_decreasing ΔX lamI p0 τ X ε G g hΔ hG hlam hε
    hp0 hτ hanti
  rcases lt_trichotomy e1 e2 with hlt | heq | hgt
  · have := hmu (Set.mem_Ici.mpr he1) (Set.mem_Ici.mpr he2) hlt
    simp only at this
    linarith
  · exact heq
  · have := hmu (Set.mem_Ici.mpr he2) (Set.mem_Ici.mpr he1) hgt
    simp only at this
    linarith

/--
Lean proof endpoint for `paper_best_response_existsSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_best_response_exists :
  paper_best_response_existsSpec := by
  intro ΔX lamI p0 τ X ε G g hΔ hG hlam hε hp0 hτ hcont hanti hgnn
  set C := ΔX * G X * lamI * g (p0 + τ) with hC
  have hcoef : 0 ≤ ΔX * G X * lamI := mul_nonneg (mul_nonneg hΔ hG) hlam.le
  have hp0mem : p0 + τ ∈ Set.Ici p0 := by simp only [Set.mem_Ici]; linarith
  have hCnn : 0 ≤ C := mul_nonneg hcoef (hgnn _ hp0mem)
  set b := (C + 1) ^ ε with hb
  have hbpos : 0 < b := by
    have : 0 < C + 1 := by linarith
    exact Real.rpow_pos_of_pos this ε
  have hbroot : b ^ (1 / ε) = C + 1 := by
    rw [hb, one_div, Real.rpow_rpow_inv (by linarith) hε.ne']
  let MU : ℝ → ℝ := fun e => ΔX * G X * lamI * g (p0 + lamI * e + τ) - e ^ (1 / ε)
  have hMU0 : MU 0 = C := by
    simp only [MU]
    rw [Real.zero_rpow (by positivity : (1 / ε) ≠ 0)]
    simp [hC]
  have hMUb : MU b ≤ -1 := by
    simp only [MU]
    have hYb : p0 + lamI * b + τ ∈ Set.Ici p0 := by
      simp only [Set.mem_Ici]; nlinarith
    have hle : p0 + τ ≤ p0 + lamI * b + τ := by nlinarith
    have hg : g (p0 + lamI * b + τ) ≤ g (p0 + τ) := hanti hp0mem hYb hle
    have := mul_le_mul_of_nonneg_left hg hcoef
    rw [hbroot]
    linarith
  have hMUcont : ContinuousOn MU (Set.Icc 0 b) := by
    apply ContinuousOn.sub
    · apply ContinuousOn.mul continuousOn_const
      have haff : ContinuousOn (fun e : ℝ => p0 + lamI * e + τ) (Set.Icc 0 b) :=
        (continuousOn_const.add (continuousOn_const.mul continuousOn_id)).add continuousOn_const
      refine hcont.comp haff ?_
      intro e he
      simp only [Set.mem_Icc] at he
      simp only [Set.mem_Ici]
      nlinarith [he.1]
    · intro e he
      simp only [Set.mem_Icc] at he
      exact (Real.continuousAt_rpow_const e (1 / ε) (Or.inr (by positivity))).continuousWithinAt
  have hsub : Set.Icc (MU b) (MU 0) ⊆ MU '' Set.Icc 0 b :=
    intermediate_value_Icc' hbpos.le hMUcont
  have h0mem : (0 : ℝ) ∈ Set.Icc (MU b) (MU 0) := by
    simp only [Set.mem_Icc]
    constructor <;> linarith
  obtain ⟨e, he, hMUe⟩ := hsub h0mem
  refine ⟨e, he.1, ?_⟩
  simp only [MU] at hMUe
  linarith

/--
Lean proof endpoint for `paper_observation_2_increasing_in_XSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_observation_2_increasing_in_X :
  paper_observation_2_increasing_in_XSpec := by
  intro ΔX lamI p0 τ ε GX1 GX2 e1 e2 g hΔ hlam hε hp0 hτ hanti hgpos hGX1 hGlt he1 he2 h1 h2
  by_contra hcon
  have hle : e2 ≤ e1 := not_lt.mp hcon
  have hY1 : p0 + lamI * e1 + τ ∈ Set.Ici p0 := by simp only [Set.mem_Ici]; nlinarith
  have hY2 : p0 + lamI * e2 + τ ∈ Set.Ici p0 := by simp only [Set.mem_Ici]; nlinarith
  have hYle : p0 + lamI * e2 + τ ≤ p0 + lamI * e1 + τ := by nlinarith
  have hg : g (p0 + lamI * e1 + τ) ≤ g (p0 + lamI * e2 + τ) := hanti hY2 hY1 hYle
  have hg2pos : 0 < g (p0 + lamI * e2 + τ) := hgpos _ hY2
  have hprod : GX1 * g (p0 + lamI * e1 + τ) < GX2 * g (p0 + lamI * e2 + τ) :=
    lt_of_le_of_lt (mul_le_mul_of_nonneg_left hg hGX1) (mul_lt_mul_of_pos_right hGlt hg2pos)
  have hcoef : 0 < ΔX * lamI := mul_pos hΔ hlam
  have hben : ΔX * lamI * (GX1 * g (p0 + lamI * e1 + τ))
      < ΔX * lamI * (GX2 * g (p0 + lamI * e2 + τ)) :=
    mul_lt_mul_of_pos_left hprod hcoef
  have hcost : e2 ^ (1 / ε) ≤ e1 ^ (1 / ε) := Real.rpow_le_rpow he2 hle (by positivity)
  nlinarith [h1, h2, hben, hcost]

/--
Lean proof endpoint for `paper_observation_2_decreasing_in_tauSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_observation_2_decreasing_in_tau :
  paper_observation_2_decreasing_in_tauSpec := by
  intro ΔX lamI p0 τ1 τ2 X ε e1 e2 G g hΔ hlam hε hp0 hτ1 hτlt hGX hanti he1 he2 h1 h2
  by_contra hcon
  have hle : e1 ≤ e2 := not_lt.mp hcon
  have hY1 : p0 + lamI * e1 + τ1 ∈ Set.Ici p0 := by simp only [Set.mem_Ici]; nlinarith
  have hY2 : p0 + lamI * e2 + τ2 ∈ Set.Ici p0 := by simp only [Set.mem_Ici]; nlinarith
  have hYlt : p0 + lamI * e1 + τ1 < p0 + lamI * e2 + τ2 := by nlinarith
  have hg : g (p0 + lamI * e2 + τ2) < g (p0 + lamI * e1 + τ1) := hanti hY1 hY2 hYlt
  have hcoef : 0 < ΔX * G X * lamI := mul_pos (mul_pos hΔ hGX) hlam
  have hben : ΔX * G X * lamI * g (p0 + lamI * e2 + τ2)
      < ΔX * G X * lamI * g (p0 + lamI * e1 + τ1) :=
    mul_lt_mul_of_pos_left hg hcoef
  have hcost : e1 ^ (1 / ε) ≤ e2 ^ (1 / ε) := Real.rpow_le_rpow he1 hle (by positivity)
  linarith

/--
Lean proof endpoint for `paper_lemma_1_transition_strictly_increasingSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_lemma_1_transition_strictly_increasing :
  paper_lemma_1_transition_strictly_increasingSpec := by
  intro Sig2 lamG I e hSig hlam hI hmono hnn
  intro X1 hX1 X2 hX2 hlt
  simp only [Set.mem_Ioi] at hX1 hX2
  change (Sig2 + (X1 + lamG * I * e X1)⁻¹)⁻¹ < (Sig2 + (X2 + lamG * I * e X2)⁻¹)⁻¹
  have he : e X1 ≤ e X2 := hmono (Set.mem_Ici.mpr hX1.le) (Set.mem_Ici.mpr hX2.le) hlt.le
  have hA1 : 0 < X1 + lamG * I * e X1 := by
    have := mul_nonneg (mul_nonneg hlam.le hI.le) (hnn X1); linarith
  have hAlt : X1 + lamG * I * e X1 < X2 + lamG * I * e X2 := by
    have := mul_le_mul_of_nonneg_left he (mul_nonneg hlam.le hI.le); linarith
  exact transition_strictMono_aux hSig hA1 hAlt

/--
Lean proof endpoint for `paper_lemma_1_transition_boundsSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_lemma_1_transition_bounds :
  paper_lemma_1_transition_boundsSpec := by
  intro Sig2 lamG I X eX hSig hlam hI hX heX
  have hA : 0 < X + lamG * I * eX := by
    have := mul_nonneg (mul_nonneg hlam.le hI.le) heX; linarith
  have hAinv : 0 < (X + lamG * I * eX)⁻¹ := inv_pos.mpr hA
  refine ⟨inv_pos.mpr (by linarith), ?_⟩
  have := one_div_lt_one_div_of_lt hSig (by linarith : Sig2 < Sig2 + (X + lamG * I * eX)⁻¹)
  simpa [one_div] using this

/--
Lean proof endpoint for `paper_proposition_2_increasing_in_ISpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_proposition_2_increasing_in_I :
  paper_proposition_2_increasing_in_ISpec := by
  intro Sig2 lamG I1 I2 X eX hSig hlam hI1 hIlt hX heX
  have hA1 : 0 < X + lamG * I1 * eX := by
    have := mul_pos (mul_pos hlam hI1) heX; linarith
  have hAlt : X + lamG * I1 * eX < X + lamG * I2 * eX := by
    have := mul_lt_mul_of_pos_right (mul_lt_mul_of_pos_left hIlt hlam) heX; linarith
  exact transition_strictMono_aux hSig hA1 hAlt

/--
Lean proof endpoint for `paper_proposition_2_decreasing_in_tauSpec`.

This theorem is intentionally outside `PaperInterface.lean`: Lean Meta checks
that it has exactly the transparent Spec type, while source-to-Lean semantic
review compares the raw source bundle only to that Spec.
-/
theorem paper_proposition_2_decreasing_in_tau :
  paper_proposition_2_decreasing_in_tauSpec := by
  intro Sig2 lamG I X e1 e2 hSig hlam hI hX he2 hlt
  have hA2 : 0 < X + lamG * I * e2 := by
    have := mul_nonneg (mul_nonneg hlam.le hI.le) he2; linarith
  have hAlt : X + lamG * I * e2 < X + lamG * I * e1 := by
    have := mul_lt_mul_of_pos_left hlt (mul_pos hlam hI); linarith
  exact transition_strictMono_aux hSig hA2 hAlt

end AKO26KnowledgeCollapse
