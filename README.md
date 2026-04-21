# Time-Resolved Floquet Spectroscopy

![Python](https://img.shields.io/badge/Python-Scientific%20Computing-blue)
![ED / DMRG](https://img.shields.io/badge/Method-ED%20/%20DMRG-brightgreen)
![Hubbard model](https://img.shields.io/badge/Physics-Hubbard%20Model-purple)
![Status](https://img.shields.io/badge/Status-Research-lightgrey)


Probing transient and sub-cycle dynamics in driven quantum systems

## Overview

This project implements a numerical framework to study time-resolved Floquet spectroscopy, with the goal of probing transient and sub-cycle states in periodically driven quantum systems.

By combining Floquet theory, real-time dynamics, and a probe-based measurement protocol, we extract momentum- and energy-resolved information without requiring full spectral reconstruction.

## Physical Motivation

Engineering quantum phases is often limited by equilibrium constraints and fragile many-body effects. Periodic driving provides an alternative route:

- External fields dynamically modify band structures
- Effective interactions can be engineered
- Systems can be driven into non-thermal, prethermal states

This approach — known as Floquet engineering — is experimentally accessible via ultrafast techniques such as time-resolved spectroscopy.

## Technique

Standard approaches to compute spectral functions require access to the full spectrum, which becomes infeasible for large systems.

Instead, we implement a probe-based spectroscopy method:

- A non-interacting probe wire is coupled to the system
- A bias voltage $V_b = \omega $ selects energy
- Momentum conservation constrains tunneling processes

The energy spectrum is extracted from the momentum distribution in the probe at each time step.

We extend the approach introduced at arXiv:1905.08166 to finite probing times, allowing:

- Access to transient regimes
- Resolution of sub-cycle dynamics

## Methods

Exact Diagonalization (ED)

- Benchmark for non-interacting models
- Direct access to Floquet band structure

Time-Dependent DMRG (tDMRG)
- Interacting systems (e.g., Hubbard model)
- Large system sizes
- Parallel scans over probe energies
  
## Features

- Time-resolved spectral reconstruction
- Momentum-resolved probe measurements
- Works without full diagonalization
- Applicable to interacting systems

## Contact
Lucas Queiroz Silveira

Email: silveira.lucasq@gmail.com

Institutional: silveira.luc@northeastern.edu

Northeastern University — Physics Department

# License

This project is licensed under the MIT License - see the LICENSE file for details.
