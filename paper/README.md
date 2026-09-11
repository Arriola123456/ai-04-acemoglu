# The paper

Not committed — it is a third-party PDF and the repository should stay light.

**Acemoglu, D., Kong, D., & Ozdaglar, A. (2026).** *AI, Human Cognition and
Knowledge Collapse.* NBER Working Paper 34910 (issued February 2026); the
version read and pinned for the Lean formalization is the MIT working-paper
PDF dated **May 5, 2026** (69 pp.).

- NBER: https://www.nber.org/papers/w34910 (DOI 10.3386/w34910)
- MIT PDF (May 5, 2026), the one linked from the course repository:
  https://economics.mit.edu/sites/default/files/2026-05/AI%2C%20Human%20Cognition%20and%20Knowledge%20Collapse%2005-05-26.pdf
- SHA-256 of the May PDF pinned by the EconCSLib statement spec:
  `63e37f2af463422e587c9bd81cda3bb555404a6ad65763aca0f9bebb8e2d4ec6`

Two versions exist. They have the same section structure and the same
statements; the February version writes the effort cost with a curvature
$\alpha$ and its stability threshold as $\alpha - 1 > 1/4$, the May version
uses the Frisch elasticity $\varepsilon$ with $\alpha - 1 = 1/\varepsilon$
(so $\varepsilon < 4$).

```bash
curl -L -o paper/acemoglu-kong-ozdaglar-2026-knowledge-collapse.pdf \
  "https://economics.mit.edu/sites/default/files/2026-05/AI%2C%20Human%20Cognition%20and%20Knowledge%20Collapse%2005-05-26.pdf"
```
