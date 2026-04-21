# Time-Resolved Floquet Spectroscopy

**Probing transient and sub-cycle dynamics in driven quantum systems**

---

## 📌 Overview

This project implements a numerical framework to study **time-resolved Floquet spectroscopy**, with the goal of probing **transient and sub-cycle states** in periodically driven quantum systems.

By combining **Floquet theory**, **real-time dynamics**, and a **probe-based measurement protocol**, we extract momentum- and energy-resolved information without requiring full spectral reconstruction.

---

## 🔬 Physical Motivation

Engineering quantum phases is often limited by equilibrium constraints and fragile many-body effects. Periodic driving provides an alternative route:

* External fields dynamically modify band structures
* Effective interactions can be engineered
* Systems can be driven into **non-thermal, prethermal states**

This approach — known as **Floquet engineering** — is experimentally accessible via ultrafast techniques such as time-resolved spectroscopy.

---

## ⚡ Floquet Framework

For a periodic Hamiltonian:

[
H(t+T) = H(t)
]

the time evolution can be decomposed as:

[
U(t_0+T, t_0) = e^{-i H_F T}
]

where ( H_F ) is the **Floquet Hamiltonian**, governing long-time dynamics.

The corresponding states take the form:

[
|\Psi_\alpha(t)\rangle = e^{-i \varepsilon_\alpha t} |\Phi_\alpha(t)\rangle
]

with ( |\Phi_\alpha(t)\rangle ) periodic in time.

---

## 🧠 Key Idea of This Project

Standard approaches to compute spectral functions require access to the full spectrum, which becomes infeasible for large systems.

Instead, we implement a **probe-based spectroscopy method**:

* A **non-interacting probe wire** is coupled to the system
* A bias voltage ( V_b = \omega ) selects energy
* Momentum conservation constrains tunneling processes

👉 The energy spectrum is extracted from the **momentum distribution in the probe** at each time step.

### Improvement introduced here:

We extend this method to **finite-time probing windows**, allowing:

* Access to **transient regimes**
* Resolution of **sub-cycle dynamics**

---

## ⚙️ Model

We simulate a driven lattice system coupled to a probe:

[
H =

* J \sum_j \left(c_j^\dagger e^{iA(t)} c_{j+1} + \text{h.c.} \right)

- \Gamma \sum_j (c_j^\dagger d_j + d_j^\dagger c_j)
- \omega \sum_j d_j^\dagger d_j
  ]

with:

* ( A(t) = A_0 \sin(\Omega t) )
* ( \epsilon_k(t) = -2J \cos(k + A(t)) )

In momentum space, each ( k )-mode reduces to a **driven two-level system**:

[
i \partial_t
\begin{pmatrix}
a_k \
b_k
\end{pmatrix}
=============

\begin{pmatrix}
\epsilon_k(t) & \Gamma \
\Gamma & \omega
\end{pmatrix}
\begin{pmatrix}
a_k \
b_k
\end{pmatrix}
]

This leads to **Rabi oscillations** between system and probe, encoding spectral information.

---

## 🧪 Methods

### Exact Diagonalization (ED)

* Benchmark for non-interacting models
* Direct access to Floquet band structure

### Time-Dependent DMRG (tDMRG)

* Interacting systems (e.g., Hubbard model)
* Large system sizes
* Parallel scans over probe energies

---

## Results

### Floquet Band Spectroscopy

* Observation of Floquet sidebands

### Dynamical Localization

* Suppression of hopping at zeros of ( J_0(A_0) )
* Agreement with effective Floquet predictions

### Formation of in-Gap

* As it is, the formation of in-gap state with cosine dispersion were observed (which agrees with results found at arXiv:2205.09557), but their origem is still under investigation.

---

## Features

* Time-resolved spectral reconstruction
* Momentum-resolved probe measurements
* Works without full diagonalization
* Applicable to interacting systems

---

## Project Structure

```text
.
├── src/              # Core simulation code
├── dmrg/             # tDMRG implementation
├── ed/               # Exact diagonalization
├── results/          # Generated spectra
├── figures/          # Plots used in paper
└── README.md
```

---

## Authors

* Lucas Q. Silveira
Northeastern University — Physics Department

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---
