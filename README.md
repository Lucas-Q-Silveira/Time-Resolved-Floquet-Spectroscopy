# Time-Resolved and Momentum-Resolved Floquet Spectroscopy

![Python](https://img.shields.io/badge/Python-Scientific%20Computing-blue)
![ED / DMRG](https://img.shields.io/badge/Method-ED%20/%20DMRG-brightgreen)
![Hubbard model](https://img.shields.io/badge/Physics-Hubbard%20Model-purple)
![Status](https://img.shields.io/badge/Status-Research-lightgrey)

Numerical and theoretical study of time-resolved Floquet spectroscopy in driven quantum systems, with a focus on extracting instantenous energy spectrum and observables in the out-of-equilibrium regime.

## Overview

This project investigates how periodic driving modifies the properties of quantum systems, combining:

- Floquet theory (periodically driven systems)
- Time-resolved spectroscopy (extended tunneling probe-based measurements)

The main goal is to connect:

- Microscopic time-dependent Hamiltonians
- Effective (Floquet) descriptions

## Project Objectives



## Current Capabilities

## Method

$$
\begin{aligned}
H &= -J \sum_j \big(c_j^\dagger e^{iA(t)} c_{j+1} +c_{j+1}^\dagger e^{-i A(t)} c_j\big) \\
&\quad +\Gamma \sum_j\big(c_j^\dagger d_j+d_j^\dagger c_j\big)+\omega\sum_j d^\dagger_j d_j \\
&= \sum_k \epsilon_k(t)c_k^\dagger c_k + \Gamma \sum_k\big(c_k^\dagger d_k+d_k^\dagger c_k\big)+\omega\sum_k d^\dagger_k d_k \\
&=\sum_k 
\begin{pmatrix}
c_k^\dagger & d_k^\dagger 
\end{pmatrix}
\begin{pmatrix}
\epsilon_k(t) & \Gamma \\
\Gamma & \omega 
\end{pmatrix}
\begin{pmatrix}
c_k \\
d_k
\end{pmatrix}
\end{aligned}
$$

## Examples

## Intended Audience

## Contact

**Lucas Queiroz Silveira**  
- Email: silveira.lucasq@gmail.com  
- Institutional: silveira.luc@northeastern.edu
