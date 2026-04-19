# Time-Resolved and Momentum-Resolved Floquet Spectroscopy

![Python](https://img.shields.io/badge/Python-Scientific%20Computing-blue)
![ED / DMRG](https://img.shields.io/badge/Method-ED%20DMRG-brightgreen)
![Hubbard model](https://img.shields.io/badge/Physics-Hubbard%20Model-purple)
![Status](https://img.shields.io/badge/Status-Research-lightgrey)


## Overview

## Project Objectives

## Current Capabilities

## Method

\begin{align}
        H &= -J \sum_j \big(c_j^\dagger e^{iA(t)} c_{j+1} +c_{j+1}^\dagger e^{-i A(t)} c_j\big) \nonumber
        \\
        & \hspace{2cm}+\Gamma \sum_j\big(c_j^\dagger d_j+d_j^\dagger c_j\big)+\omega\sum_j d^\dagger_j d_j
        \\
        &= \sum_k \epsilon_k(t)c_k^\dagger c_k + \Gamma \sum_k\big(c_k^\dagger d_k+d_k^\dagger c_k\big)+\omega\sum_k d^\dagger_k d_k
        \\
        &=\sum_k 
        \left(
            \begin{array}{cc}
                c_k^\dagger & d_k^\dagger 
            \end{array}
        \right)
        \left(
        \begin{array}{cc}
            \epsilon_k(t) & \Gamma \\
             \Gamma & \omega 
        \end{array}
        \right)
        \left(
        \begin{array}{c}
            c_k \\
            d_k
        \end{array}
        \right)
    \end{align}

## Examples

## Intended Audience

## Contact

**Lucas Queiroz Silveira**  
- Email: silveira.lucasq@gmail.com  
- Institutional: silveira.luc@northeastern.edu
