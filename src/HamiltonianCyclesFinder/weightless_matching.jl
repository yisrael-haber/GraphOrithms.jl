using PyCall 
nx = pyimport("networkx")

function createNX(origGraph::AbstractGraph)
	G = nx.Graph()
	G.add_edges_from(map(x->(src(x), dst(x)), edges(origGraph)))
	return G
end

nx_matching(graph::SimpleGraph) = nx.max_weight_matching(createNX(graph))

reverse_perm(perm::Vector{Int64}) = map(x->x[1], sort(collect(enumerate(perm)), by = x->x[2]))

function permute_and_reverse(n::Int64)
	perm = shuffle(collect(1:n))
	return perm, reverse_perm(perm)
end

function permute_graph(graph::SimpleGraph, perm::Vector{Int64})
	perm_graph = SimpleGraph(nv(graph))
	for edge in edges(graph) add_edge!(perm_graph, (perm[src(edge)], perm[dst(edge)])) end 
	return perm_graph
end

function nx_random_matching(graph::SimpleGraph)
	perm, reverse = permute_and_reverse(nv(graph))
	gnihctam = nx_matching(permute_graph(graph, perm))
    return [(reverse[tup[1]], reverse[tup[2]]) for tup in gnihctam]
end