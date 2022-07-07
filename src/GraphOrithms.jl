module GraphOrithms

using Graphs

greet() = print("Hello World!")

export greet, this_is_func

include("HamiltonianCyclesFinder/tryThis.jl")

end # module
