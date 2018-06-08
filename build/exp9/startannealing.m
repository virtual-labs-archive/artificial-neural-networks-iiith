function startannealing(Nnodes,edges,alpha,deltaT)

A = sparse(edges(:,1),edges(:,2),1,Nnodes,Nnodes);
graph = full(A);

bpgraph = graphbipartition(graph, alpha, deltaT);

plotgraph(bpgraph);

print output.png

return;
