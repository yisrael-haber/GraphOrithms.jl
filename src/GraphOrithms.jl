module GraphOrithms

using Distributed
using Graphs
using PyCall
using Random

const nx = PyNULL()

function __init__()
    nx = pyimport_conda("networkx", "networkx")
end

export is_hamiltonian, find_hamiltonian_cycle, tutte_transform, decode_transform, nx_matching, nx_random_matching

include("HamiltonianCyclesFinder/hamiltonian.jl")
include("HamiltonianCyclesFinder/tutte_transform.jl")
include("HamiltonianCyclesFinder/weightless_matching.jl")

end # module
