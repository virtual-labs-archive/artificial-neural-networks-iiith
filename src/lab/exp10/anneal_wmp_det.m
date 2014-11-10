function finalstate = anneal_wmp_det(points,initstate)

%%%%%%%%%
% Ex1: points=[1 1;3 3;0 4;2 6];
%   The network yields solution only for certain initial states. For other
%   init states, the network oscillates or gets stuck at some local minima.
% validinitstates=[5 6 7 9 10 11 13 14 15 21 25 29 37 41 45];
%%%%%%%%%

fid=fopen('result.txt','w');

N=length(points);
M=nchoosek(N,2);
if(~exist('initstate'))
	initstate=(rand(M,1)-0.5)>0;
end
initstate=initstate(:);

fprintf(fid,'Initial state:\n');
fprintf(fid,'%d ',initstate);
fprintf(fid,'\n');

d=zeros(N,N);
unit=[];
th=[];
k=1;
for i=1:N
	for j=i+1:N
		d(i,j)=norm(points(i,:)-points(j,:));
		unit(k,:)=[i j];
		th=[th; d(i,j)];
		k=k+1;
	end
end
d=d+d';


% The nodes are (i,j): 12, 13, 14, 23, 24, 34

gamma=max(max(d))/(M/2);
W = zeros(M,M);

for i=1:M
for j=i+1:M
	if(any(~[unit(i,:)-unit(j,:) unit(i,[2 1])-unit(j,:)]))
		W(i,j)=-gamma;
	end
end
end

W = W + W';

th=th-gamma;

% Random initialization
%state = (rand(M,1)-0.5)>0;
%state=[0 1 1 0 0 0]'
state=initstate;
disp(state)
tempstate = zeros(M,1);
stateseq=[zeros(M,2) state];
k=3;
while(norm(tempstate-state) ~= 0 & norm(stateseq(:,k)-stateseq(:,k-2))~=0 | k<10)
	tempstate=state;
	state=W*state+th;
    %disp(state')
	state=state>0;
    %disp(state')
    stateseq=[stateseq state];
    k=k+1;
    %pause;
end
finalstate=state;

disp(stateseq);
fprintf(fid,'\nOutput state of the nodes after each update:\n');
for i=3:size(stateseq,2)
    fprintf(fid,'%d ',stateseq(:,i));
    fprintf(fid,'\n');
end


g=zeros(N,N);
ndx=unit(find(finalstate),:);
for i=1:size(ndx,1)
g([ndx(i,1)],[ndx(i,2)])=1;
end
%xyminmax = min_max(points');

drawgraph(g,points);

print wmpoutput.png

fclose(fid);

return;
