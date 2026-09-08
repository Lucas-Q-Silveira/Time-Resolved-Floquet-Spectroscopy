###################
# Library imports #
###################

import sys
import os
from pathlib import Path

import numpy as np

from joblib import Parallel, delayed, dump

from tenpy.networks.mps import MPS
from tenpy.models.model import CouplingMPOModel
from tenpy.networks import site
from tenpy.algorithms.dmrg import TwoSiteDMRGEngine
from tenpy.algorithms import tdvp

################################################################
# Define the time-dependent spinless interacting fermion model #
################################################################

class time_dependent_Hubbard(CouplingMPOModel):

    default_lattice = 'Ladder' # Using ladder to represent sample + probe
    force_default_lattice = True # Ensure we always use the ladder lattice

    def init_sites(self, model_params): 
        fermion_sample = site.FermionSite(conserve='N') # Sample site
        fermion_probe = site.FermionSite(conserve='N') # Probe site
        site.set_common_charges([fermion_sample, fermion_probe], new_charges='same')
        return [fermion_sample, fermion_probe] # Return list of site objects

    def init_terms(self, model_params):
    
        L = model_params.get('L', 10) # Length of the sample

        # Extract parameters
        J = model_params.get('J', 1.0)
        V = model_params.get('V', 0.0)

        g = model_params.get('g', 0.2)
        omega = model_params.get('omega', 1.0)

        mu = model_params.get('mu', 0.0)
 
        # Hopping within the sample
        self.add_coupling(-J, 0, 'Cd', 0, 'C', [1], plus_hc=True)
 
        # Nearest-neighbor interaction in the sample
        self.add_coupling(V, 0, 'N', 0, 'N', [1], plus_hc=False)

        mu_V = np.full(L, -V)
        mu_V[0] += 0.5 * V
        mu_V[-1] += 0.5 * V
        self.add_onsite(mu_V, 0, 'N')

        # Chemical potential on the sample
        self.add_onsite(mu, 0, 'N')

        # Probe energy term
        self.add_onsite(omega, 1, 'N')

        # Interaction between sample and probe
        self.add_coupling(g, 0, 'Cd', 1, 'C', [0], plus_hc=True)

#############
# Functions #
#############

def correlation(psi, model):

    probe_sites = model.lat.mps_idx_fix_u(1) # Probe sites
    C_p = psi.correlation_function('Cd', 'C', sites1=probe_sites, sites2=probe_sites) # Compute correlation function on probe
    
    return C_p

def DMRG(psi_init, model, dmrg_params):

    dmrg_engine = TwoSiteDMRGEngine(psi_init, model, dmrg_params) # Initialize DMRG engine
    E0, psi_gs = dmrg_engine.run() # Run DMRG to find ground state

    return E0, psi_gs

def TDVP(psi_init, model, tdvp_params):

    tdvp_engine = tdvp.TwoSiteTDVPEngine(psi_init, model, tdvp_params)
    tdvp_engine.run()

    return tdvp_engine.psi, tdvp_engine.trunc_err.eps

##################################################################################################
# Main function that runs TDVP for a given omega and returns the correlation functions over time #
##################################################################################################

def simulation(times, omega_val, A, Probe, psi_init, model_parameter, tdvp_params):

    model_params_copy = model_parameter.copy()  # Create a copy to avoid modifying the original

    J0 = model_params_copy.get('J', 1.0)    
    L = model_params_copy['L']
    N_t = len(times)

    C_t_ij = np.zeros((N_t, L, L), dtype=complex)

    psi = psi_init.copy()

    prev = 0.0
    error = 0.0

    for ti, _ in enumerate(times):

        model_params_copy['J'] = J0 * np.exp(1j * A[ti])
    
        model_params_copy['omega'] = omega_val
    
        model_params_copy['g'] = Probe[ti]
    
        model = time_dependent_Hubbard(model_params_copy)
    
        psi, err = TDVP(psi, model, tdvp_params)

        C_t_ij[ti, :, :] = correlation(psi, model)

        error = max(error, err)
    
    return C_t_ij, error, psi.chi

##############################
# Extracting job information # 
##############################

task_id = int(sys.argv[1]) - 1
n_jobs = int(sys.argv[2])

print(f"Task {task_id} out of {n_jobs} total tasks")

omega_dir = Path(sys.argv[3])
corr_dir = Path(sys.argv[4])

#########################################################################
# Processing Energy scan array to submit different simultaneously tasks #
#########################################################################

N_omega = 200 

omega = np.linspace(-10.0, 10.0, N_omega) 

omega_slices = np.array_split(omega, n_jobs)

omega_scan = omega_slices[task_id]

filename_w = f"omega_{task_id}.npy"
np.save(omega_dir / filename_w, omega_scan)

########
# Time #
########

N_t = 300
times = np.linspace(0.0, 15.0, N_t)
dt = times[1]-times[0]

###################
# Model Paramaters#
###################

L = int(sys.argv[5])

J0 = 1.0
V0 = float(sys.argv[6])
mu = 0.0

########################
# init Drive and Pulse #
########################

A0 = float(sys.argv[7])
omega_drive = float(sys.argv[8])

P0 = 0.2
t_probe = 7.5
sigma = 4.0

A = A0 * np.sin(omega_drive * times)

Probe = P0 * np.exp(-(times - t_probe)**2 / (sigma**2))

#######################################
# DMRG, TDVP and model parameter dict #
#######################################

dmrg_params = {
    'mixer': True,
    'max_E_err': 1.e-6,
    'trunc_params': {
        'chi_max': 100,
        'svd_min': 1.e-6,
    },
}

tdvp_params = {
    'N_steps': 1,
    'dt': dt,
    'trunc_params': {
        'chi_max': 300, 
        'svd_min': 1.e-6,
    },
}

#################################
# Bookkeeping: print statements #
#################################

print("Model parameters: J0={}, V0={}".format(J0, V0))
print()
print("Drive and Probe: A0={}, omega={}, P0={}, sigma={}".format(A0, omega_drive, P0, sigma))
print()
print("Resolution parameters: N_t={}, N_k={}, N_omega={}".format(N_t, L+1, N_omega))
print()
print("===================================================================================")
print()
print("-> Scanning lower band...")
print()

mu_probe = 10.0**4

model_parameter = {
    'L': L,
    'J': J0,
    'g': 0.0,
    'V': V0,
    'omega': mu_probe,
    'mu':mu,
    'bc_MPS': 'finite',
    }

model_init = time_dependent_Hubbard(model_parameter)

lattice = model_init.lat

s_filling = float(sys.argv[9])

N_occ = int(s_filling * L)

state = ['full'] * N_occ + ['empty'] * (L - N_occ)

np.random.shuffle(state)

product_state = [(s, 'empty') for s in state]

psi_init = MPS.from_lat_product_state(lattice, product_state)

E0, psi_gs = DMRG(psi_init, model_init, dmrg_params)

sample_occupation = psi_gs.expectation_value('N', sites=lattice.mps_idx_fix_u(0)) 
probe_occupation = psi_gs.expectation_value('N', sites=lattice.mps_idx_fix_u(1))

print(r'Sample occupation before time-evolution: {:.5}'.format(np.mean(sample_occupation)))
print(r'Probe occupation before time-evolution: {:.5}'.format(np.mean(probe_occupation)))
print()

results = Parallel(n_jobs=-1, verbose=10)(delayed(simulation)(times, w_val, A, Probe, psi_gs, model_parameter, tdvp_params) for w_val in omega_scan)

C_l, error, bond = zip(*results)

print("\n" + "="*100)
print("\n Final bond dimension: \n {}".format(bond[0]))
print("\n Maximum truncation error during TDVP: \n {}".format(np.max(error)))

print()
print("Simulation completed! Saving array ...")

C_l = np.array(C_l)

filename = f"correlation-low_{task_id}.npy"
dump(C_l, corr_dir / filename)

print("Job finished!")


