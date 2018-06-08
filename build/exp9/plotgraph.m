function graph = plotgraph(graph)

Nnodes = length(graph);
disp(Nnodes);

switch(Nnodes)
	case {4} 
		nodeloc=[0 5;5 10;5 0;10 5];
	case {6}
		nodeloc=[0 5;5 10;5 0;8 7;12 8;12 2];
	case {8}
		nodeloc=[0 5;5 10;5 0;8 7;12 8;12 2;];
	case {10}
		nodeloc=[0 5;2 8;6 8;5 5;3 2;0 1;4 1;6 2;8 6;9 8;8 10;10 9;10 5;8 2];
	case {12}
		nodeloc=[2 8;6 8;5 5;3 2;4 1;6 2;8 6;9 8;8 10;10 9;10 5;8 2];
	case {14}
		nodeloc=[0 5;2 8;6 8;5 5;3 2;0 1;4 1;6 2;8 6;9 8;8 10;10 9;10 5;8 2];
	case {16}
		nodeloc=[0 5;2 8;6 8;5 5;3 2;0 1;4 1;6 2;8 6;9 8;8 10;10 9;10 5;8 2;6 1;7 0];
	otherwise
		error("Invalid number of nodes");
endswitch

xymin = min(nodeloc);
xymax = max(nodeloc);

figure;
gplot(graph,nodeloc);
xlim([xymin(1)-1,xymax(1)+1]);
ylim([xymin(2)-1,xymax(2)+1]);
hold on;plot(nodeloc(:,1),nodeloc(:,2),'o','markersize',40);
for i=1:Nnodes;text(nodeloc(i,1),nodeloc(i,2)+.7,num2str(i));end

hl=findall(gcf,'type','line');
set(hl,'linewidth',3);

ht=findall(gcf,'type','text');
set(ht,'fontsize',20);
%set(ht,'fontweight','bold');

return;
