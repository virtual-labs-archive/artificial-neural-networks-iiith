function init_wmp(points)

%%%%%%%%%
% Ex1: points=[1 1;3 3;0 4;2 6];
%   The network yields solution only for certain initial states. For other
%   init states, the network oscillates or gets stuck at some local minima.
% validinitstates=[5 6 7 9 10 11 13 14 15 21 25 29 37 41 45];
%%%%%%%%%
%addpath ~/svl-lib/matlib/Tools-fromnet/exportfig/

Nnodes=length(points);

%xyminmax = min_max(points');
figure;
%applytofig(gcf,'width',10,'height',8);
plot(points(:,1),points(:,2),'o','markersize',30,'linewidth',6);
%xlim([xyminmax(1,1)-1,xyminmax(1,2)+1]);
%ylim([xyminmax(2,1)-1,xyminmax(2,2)+1]);

xymin=min(min(points))-1;
xymax=max(max(points))+1;
xlim([xymin xymax]);
ylim([xymin xymax]);

for i=1:Nnodes;text(points(i,1),points(i,2)+.7,num2str(i),'fontsize',20);end

print wmpinput.png

return;
