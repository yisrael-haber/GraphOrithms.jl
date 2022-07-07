nodedex(node::Int64, deg::Int64) = (2 * deg - 2) * (node - 1) + 1

decodex(node::Int64, deg::Int64) = div(node - 1, 2 * deg - 2) + 1

occupied_generator(graph::SimpleGraph, deg::Int64) = Dict(node => Dict(neigh=>false for neigh in get_index_map(node, deg)) for node in vertices(graph))

get_vec(dic::Dict{Int64, Bool}) = map(x->Tuple(x), collect(dic))

get_unoccupied(occupied::Dict{Int64, Dict{Int64, Bool}}, node) = map(x->x[1], filter(x->!(x[2]), get_vec(occupied[node])))[1]

get_index_map(node::Int64, deg::Int64) = collect(nodedex(node, deg):(nodedex(node, deg) + deg - 1))

function get_indices(node::Int64, deg::Int64)
    noder = nodedex(node, deg)
    return reduce(vcat, [(i, j) for i in noder:(noder + deg - 1), j in (noder + deg):(noder + 2 * deg - 3)])
end

function tutte_transform(gr::SimpleGraph, deg::Int64)
    transformed, occupied = SimpleGraph((2*deg-2)*nv(gr)), occupied_generator(gr, deg)
    basic_edges = reduce(vcat, [get_indices(node, deg) for node in vertices(gr)])
    for tuple in basic_edges add_edge!(transformed, tuple) end
    for node in vertices(gr)
        for neighbor in neighbors(gr, node)
            if node > neighbor continue end
            next_node, next_neighbor = get_unoccupied(occupied, node), get_unoccupied(occupied, neighbor)
            occupied[node][next_node], occupied[neighbor][next_neighbor] = true, true
            add_edge!(transformed, (next_node, next_neighbor))
        end
    end
    return transformed
end

function decode_transform(tutte_graph::SimpleGraph, match_edges::Vector{Tuple{Int64, Int64}}, deg::Int64)
    original_node_num = Int64(nv(tutte_graph)/(2 * deg - 2))
    original_skeleton = SimpleGraph(original_node_num)
    original_match_edges = map(tup->(decodex(tup[1], deg), decodex(tup[2], deg)), match_edges)
    filter!(x->x[1]!=x[2], original_match_edges)
    for tup in original_match_edges add_edge!(original_skeleton, tup) end
    return original_skeleton
end