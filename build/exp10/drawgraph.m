function drawgraph(g,nodes)

N=length(nodes);
figure;
gplot(g,nodes);hold on;
plot(nodes(:,1),nodes(:,2),'o','markersize',30);


%xlim([xyminmax(1,1)-1,xyminmax(1,2)+1]);
%ylim([xyminmax(2,1)-1,xyminmax(2,2)+1]);
xymin=min(min(nodes))-1;
xymax=max(max(nodes))+1;
xlim([xymin xymax]);
ylim([xymin xymax]);

for i=1:N;text(nodes(i,1),nodes(i,2)+.7,num2str(i),'fontsize',20);end
%for i=1:N;text(nodes(i,1)-.1,nodes(i,2),num2str(i));end


lh=findall(gcf,'type','line');
set(lh,'linewidth',6);
% ah=findall(gcf,'type','axes');
% th=findall(gcf,'type','text');
% set([ah;th],'fontsize',16,'fontweight','bold');

return;


