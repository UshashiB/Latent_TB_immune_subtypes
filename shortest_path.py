import os
import sys
import zen
import timeit

current_file=sys.argv[1]
print current_file
G =zen.io.edgelist.read(current_file, node_obj_fxn=str, directed=True, ignore_duplicate_edges=False, merge_graph=None, weighted=True)
nodes = G.nodes()
foutname = current_file + "_FINAL_OUTPUT.txt"
path_length_cutoff = 3
output=open(foutname, "w")
output.write("NodeA\t" + "NodeB\t" + "path_score\t" + "normalized_path_score\t" + "path_length\t" + "path_trace\n")
start_time = timeit.default_timer()

for node in nodes:
    # print(node)
    compare_nodes = list(nodes) # This should force a copy of the list, I hope
    compare_nodes.remove(node)
    x = zen.algorithms.shortest_path.dijkstra_path(G, node)
    for cnode in compare_nodes:
        y = zen.algorithms.shortest_path.pred2path(node, cnode, x)
        z = x[cnode][0]
        if z!=float('Inf'):
            plength = len(y) - 1
            if (plength >= path_length_cutoff):
                nscore = z/plength
                output.write(node + "\t" + cnode + "\t" + str(z) + "\t" + str(nscore) + "\t" + str(plength) + "\t" + ','.join(y) + "\n")
output.close()
elapsed = timeit.default_timer() - start_time
