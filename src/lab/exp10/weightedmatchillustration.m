function weightedmatchillustration()

addpath ~/svl-lib/matlib/Tools-fromnet/exportfig/
points=[1 5;3 8;5 1;8 3];

N=length(points);
d=zeros(N,N);
for i=1:N
    for j=i+1:N
        d(i,j)=norm(points(i,:)-points(j,:));
        mpx(i,j)=(points(i,1)+points(j,1))/2;
        mpy(i,j)=(points(i,2)+points(j,2))/2;
    end
end

g = zeros(N,N);
drawweightedgraph(g,points);
saveas(gcf,'figures/prob.tiff');


g1 = [
    0 1 1 1;
    0 0 1 1;
    0 0 0 1;
    0 0 0 0;
    ];
drawweightedgraph(g1,points,d,mpx,mpy)
saveas(gcf,'figures/wgraph.tiff');

g2 = zeros(N,N);
g2(1,2)=1;g2(3,4)=1;
drawweightedgraph(g2,points,d,mpx,mpy)
saveas(gcf,'figures/sol1.tiff');


g2 = zeros(N,N);
g2(1,3)=1;g2(2,4)=1;
drawweightedgraph(g2,points,d,mpx,mpy)
saveas(gcf,'figures/sol2.tiff');

g2 = zeros(N,N);
g2(1,4)=1;g2(2,3)=1;
drawweightedgraph(g2,points,d,mpx,mpy)
saveas(gcf,'figures/sol3.tiff');


return;


function drawweightedgraph(g,nodes,d,mpx,mpy)

N=length(nodes);
figure;
applytofig(gcf,'width',10,'height',8);
gplot(g,nodes);hold on;
plot(nodes(:,1),nodes(:,2),'o','markersize',20);


%xlim([xyminmax(1,1)-1,xyminmax(1,2)+1]);
%ylim([xyminmax(2,1)-1,xyminmax(2,2)+1]);
xymin=min(min(nodes))-1;
xymax=max(max(nodes))+1;
xlim([xymin xymax]);
ylim([xymin xymax]);

for i=1:N;text(nodes(i,1),nodes(i,2)+.7,num2str(i));end
%for i=1:N;text(nodes(i,1)-.1,nodes(i,2),num2str(i));end

if(exist('d'))
    for i=1:N
        for j=1:N
            if(g(i,j)==1)
                text(mpx(i,j)+.5,mpy(i,j)+.5,sprintf('%3.1f',d(i,j)));
            end
        end
    end
end


lh=findall(gcf,'type','line');
set(lh,'linewidth',4);
ah=findall(gcf,'type','axes');
th=findall(gcf,'type','text');
set([ah;th],'fontsize',12,'fontweight','bold');

return;
