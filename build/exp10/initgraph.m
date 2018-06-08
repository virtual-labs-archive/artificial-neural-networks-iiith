function graph = initgraph(Nnodes,edges)

disp(Nnodes);
disp(edges);

A = sparse(edges(:,1),edges(:,2),1,Nnodes,Nnodes);
graph = full(A);

plotgraph(graph);

print tmp/input.png

return;
