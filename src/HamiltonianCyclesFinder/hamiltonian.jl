is_hamiltonian(graph::SimpleGraph) = (is_connected(graph) && length(keys(degree_histogram(graph))) == 1)

function find_hamiltonian_cycle(graph::SimpleGraph, degree::Int64)
    idx, transformed = 1, tutte_transform(graph, degree)
    while true
        println("Iteration $idx")
        match_edges = [Tuple(val) for val in nx_random_matching(transformed)]
        match_graph = decode_transform(transformed, match_edges, degree)
        if is_hamiltonian(match_graph) println("Worked after $idx iterations"); return idx, match_graph end
        idx += 1
    end 
end