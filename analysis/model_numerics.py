"""Numerical checks for Acemoglu, Kong & Ozdaglar (2026), "AI, Human Cognition and
Knowledge Collapse" (MIT version, May 5, 2026), static block and steady states.

  G(t) = Pr(|Z| <= 1) for Z ~ N(0, 1/t) = 2 Phi(sqrt t) - 1 = erf(sqrt(t/2)),
  g(t) = G'(t) = phi(sqrt t) / sqrt t.

Expected utility (6) under Assumption 1 (Delta_I = 0):
  U(e; X, tau) = f00 + G(X) DG + G(X) G(Y) DX - eps/(eps+1) e^((eps+1)/eps),
  Y = s0 + lamI e + tau   (s0 = sigma^{-2}).
Best response e(X, tau): DX G(X) lamI g(Y) = e^(1/eps).
Transition F(X) = [Sigma^2 + (X + lamG I e(X,tau))^{-1}]^{-1}.

Outputs (each figure alone, for one slide each):
  figures/observation1_sympy.txt   symbolic cross-partials + numeric sign check
  figures/best_response.pdf        e(X, tau) vs X for several tau (eps = 2)
  figures/transition_eps2.pdf      F(X) vs 45-degree line, eps = 2 (unique regime)
  figures/transition_eps6.pdf      F(X) vs 45-degree line, eps = 6 (collapse regime)
  figures/welfare_eps2.pdf         steady-state welfare vs tau_A, eps = 2
  figures/welfare_eps6.pdf         steady-state welfare vs tau_A, eps = 6
"""
import os
import numpy as np
import sympy as sp
from scipy.optimize import brentq
from scipy.special import erf
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))
FIG = os.path.join(HERE, "figures")
os.makedirs(FIG, exist_ok=True)

# ----------------------------------------------------------------------------
# 1. SymPy: Observation 1 with the actual Gaussian G
# ----------------------------------------------------------------------------
e, X, tau, s0, lamI, DX, DG, eps, f00 = sp.symbols("e X tau s0 lambda_I Delta_X Delta_G epsilon f00", positive=True)
t = sp.symbols("t", positive=True)
G = sp.Lambda(t, sp.erf(sp.sqrt(t / 2)))
g = sp.Lambda(t, sp.diff(G(t), t))
Y = s0 + lamI * e + tau
U = f00 + G(X) * DG + G(X) * G(Y) * DX - eps / (eps + 1) * e ** ((eps + 1) / eps)
MU = sp.simplify(sp.diff(U, e))
cross_X = sp.simplify(sp.diff(MU, X))
cross_tau = sp.simplify(sp.diff(MU, tau))
lines = []
lines.append("g(t) = G'(t) = " + str(sp.simplify(g(t))) + "   (= phi(sqrt t)/sqrt t)")
lines.append("dU/de = " + str(MU))
lines.append("d2U/de dX  = " + str(cross_X))
lines.append("d2U/de dtau = " + str(cross_tau))
lines.append("g'(t) = " + str(sp.simplify(sp.diff(g(t), t))))
# numeric sign check on a grid
rng = np.random.default_rng(0)
fX = sp.lambdify((e, X, tau, s0, lamI, DX, eps), cross_X, "numpy")
ft = sp.lambdify((e, X, tau, s0, lamI, DX, eps), cross_tau, "numpy")
grid = [(rng.uniform(0.01, 5), rng.uniform(0.01, 5), rng.uniform(0, 5), rng.uniform(0.1, 3),
         rng.uniform(0.1, 3), rng.uniform(0.05, 1), rng.uniform(0.5, 8)) for _ in range(2000)]
vx = np.array([fX(*p) for p in grid]); vt = np.array([ft(*p) for p in grid])
lines.append(f"sign check on 2000 random points: d2U/dedX > 0 in {np.mean(vx > 0):.3f}, "
             f"d2U/dedtau < 0 in {np.mean(vt < 0):.3f}")
with open(os.path.join(FIG, "observation1_sympy.txt"), "w", encoding="utf-8") as fh:
    fh.write("\n".join(lines) + "\n")
print("\n".join(lines))

# ----------------------------------------------------------------------------
# 2. Numerics
# ----------------------------------------------------------------------------
def Gn(t):
    return erf(np.sqrt(np.maximum(t, 0.0) / 2.0))

def gn(t):
    t = np.maximum(t, 1e-12)
    return np.exp(-t / 2.0) / np.sqrt(2.0 * np.pi * t)

class Model:
    def __init__(self, eps, DX=0.8, DG=0.2, lamI=3.0, s0=0.5, lamG=1.0, I=20.0, Sig2=0.2):
        self.eps, self.DX, self.DG, self.lamI, self.s0, self.lamG, self.I, self.Sig2 = eps, DX, DG, lamI, s0, lamG, I, Sig2

    def mu(self, e, X, tau):  # marginal utility of effort
        return self.DX * Gn(X) * self.lamI * gn(self.s0 + self.lamI * e + tau) - e ** (1.0 / self.eps)

    def br(self, X, tau):  # best response
        if X <= 0:
            return 0.0
        C = self.DX * Gn(X) * self.lamI * gn(self.s0 + tau)
        if C <= 0:
            return 0.0
        b = (C + 1.0) ** self.eps
        return brentq(lambda ee: self.mu(ee, X, tau), 0.0, b, xtol=1e-14, maxiter=500)

    def F(self, X, tau):
        if X <= 0:
            return 0.0
        return 1.0 / (self.Sig2 + 1.0 / (X + self.lamG * self.I * self.br(X, tau)))

    def high_steady_state(self, tau, iters=4000):
        X = 1.0 / self.Sig2  # start at the upper bound
        for _ in range(iters):
            Xn = self.F(X, tau)
            if abs(Xn - X) < 1e-13:
                X = Xn
                break
            X = Xn
        return X

    def fixed_points(self, tau, n=600):
        xs = np.logspace(-6, np.log10(1.0 / self.Sig2), n)
        d = np.array([self.F(x, tau) - x for x in xs])
        pts = []
        for i in range(n - 1):
            if d[i] == 0 or d[i] * d[i + 1] < 0:
                pts.append(brentq(lambda x: self.F(x, tau) - x, xs[i], xs[i + 1]))
        return pts

    def welfare(self, tau):
        pts = [p for p in self.fixed_points(tau) if p > 1e-5]
        if not pts:
            return 0.0  # complete collapse: the only steady state is X = 0, welfare 0
        Xb = max(pts)  # high-knowledge steady state
        eb = self.br(Xb, tau)
        Yb = self.s0 + self.lamI * eb + tau
        return Gn(Xb) * self.DG + Gn(Xb) * Gn(Yb) * self.DX - self.eps / (self.eps + 1) * eb ** ((self.eps + 1) / self.eps)

def slide_fig():
    fig, ax = plt.subplots(figsize=(7.2, 4.2))
    return fig, ax

# --- best response (eps = 2) ---
m2 = Model(eps=2.0)
Xs = np.linspace(0.0, 2.0, 200)
fig, ax = slide_fig()
for tau_, ls in [(0.0, "-"), (1.0, "--"), (3.0, ":")]:
    ax.plot(Xs, [m2.br(x, tau_) for x in Xs], ls, lw=2, label=fr"$\tau_A = {tau_:g}$")
ax.set_xlabel(r"public precision $X$ (general knowledge)")
ax.set_ylabel(r"best-response effort $e(X,\tau_A)$")
ax.set_title(r"Observation 2: effort rises with $X$, falls with $\tau_A$  ($\varepsilon=2$)")
ax.legend(); ax.grid(alpha=.3); fig.tight_layout()
fig.savefig(os.path.join(FIG, "best_response.pdf")); plt.close(fig)

# --- transition map, eps = 2 ---
Xg = np.linspace(0.0, 1.0 / m2.Sig2, 300)
fig, ax = slide_fig()
for tau_, ls in [(0.0, "-"), (2.0, "--")]:
    ax.plot(Xg, [m2.F(x, tau_) for x in Xg], ls, lw=2, label=fr"$F(X)$, $\tau_A={tau_:g}$")
ax.plot(Xg, Xg, "k", lw=1, label="45°")
for tau_ in (0.0, 2.0):
    for p in m2.fixed_points(tau_):
        ax.plot(p, p, "o", color="tab:red", ms=6)
ax.set_xlabel(r"$X_t$"); ax.set_ylabel(r"$X_{t+1} = F(X_t)$")
ax.set_title(r"$\varepsilon = 2 < 4$: a unique positive steady state; $X=0$ unstable")
ax.legend(); ax.grid(alpha=.3); fig.tight_layout()
fig.savefig(os.path.join(FIG, "transition_eps2.pdf")); plt.close(fig)
print("eps=2 fixed points tau=0:", m2.fixed_points(0.0), " tau=2:", m2.fixed_points(2.0))

# --- transition map, eps = 6: find tau_c ---
m6 = Model(eps=6.0)
def n_pos_fp(tau_):
    return len([p for p in m6.fixed_points(tau_) if p > 1e-5])
taus = np.linspace(0.0, 12.0, 241)
npos = [n_pos_fp(t_) for t_ in taus]
tau_c = None
for t_, n_ in zip(taus, npos):
    if n_ == 0:
        tau_c = t_; break
print("eps=6: positive fixed points along tau:", list(zip(taus[::20], npos[::20])), " first collapse tau ~", tau_c)
tau_lo = 0.0
tau_hi = tau_c if tau_c is not None else 8.0
fig, ax = slide_fig()
Xg6 = np.linspace(0.0, 1.0 / m6.Sig2, 300)
ax.plot(Xg6, [m6.F(x, tau_lo) for x in Xg6], "-", lw=2, label=fr"$F(X)$, $\tau_A={tau_lo:g} < \tau_A^c$")
ax.plot(Xg6, [m6.F(x, tau_hi) for x in Xg6], "--", lw=2, label=fr"$F(X)$, $\tau_A={tau_hi:.2f} \geq \tau_A^c$")
ax.plot(Xg6, Xg6, "k", lw=1, label="45°")
for p in m6.fixed_points(tau_lo):
    ax.plot(p, p, "o", color="tab:red", ms=6)
ax.set_xlabel(r"$X_t$"); ax.set_ylabel(r"$X_{t+1} = F(X_t)$")
ax.set_title(r"$\varepsilon = 6 > 4$: three steady states, then complete collapse")
ax.legend(); ax.grid(alpha=.3); fig.tight_layout()
fig.savefig(os.path.join(FIG, "transition_eps6.pdf")); plt.close(fig)
print("eps=6 fixed points tau_lo:", m6.fixed_points(tau_lo), " tau_hi:", m6.fixed_points(tau_hi))

# --- welfare vs tau_A ---
for m, name, tmax in [(m2, "welfare_eps2", 12.0), (m6, "welfare_eps6", (tau_hi + 0.5) if tau_c else 12.0)]:
    ts = np.linspace(0.0, tmax, 121)
    W = np.array([m.welfare(t_) for t_ in ts])
    i_star = int(np.argmax(W))
    fig, ax = slide_fig()
    ax.plot(ts, W, lw=2)
    ax.axvline(ts[i_star], color="gray", ls=":", lw=1)
    ax.text(ts[i_star], W[i_star], r"  $\tau_A^\star$", va="bottom")
    if m is m6 and tau_c is not None:
        ax.axvline(tau_c, color="tab:red", ls="--", lw=1)
        ax.text(tau_c, 0.5 * W.max(), r" $\tau_A^c$: collapse", color="tab:red")
    ax.set_xlabel(r"agentic-AI precision $\tau_A$"); ax.set_ylabel(r"steady-state welfare $\bar U^+$")
    ax.set_title((r"$\varepsilon=2$: welfare is single-peaked in $\tau_A$" if m is m2
                  else r"$\varepsilon=6$: single-peaked, then a discontinuous drop to 0"))
    ax.grid(alpha=.3); fig.tight_layout()
    fig.savefig(os.path.join(FIG, f"{name}.pdf")); plt.close(fig)
    print(name, "argmax tau* =", ts[i_star], "W* =", W[i_star], "W(0) =", W[0], "W(end) =", W[-1])
print("done")
