function FinalState = anneal_wmp_mean(points,InitState)

%%%%%%%%%
% Ex1: points=[1 1;3 3;0 4;2 6];
%   The network yields solution only for certain initial states. For other
%   init states, the network oscillates or gets stuck at some local minima.
% validinitstates=[5 6 7 9 10 11 13 14 15 21 25 29 37 41 45];
%%%%%%%%%

fid=fopen('result.txt','w');

%points=[1 1;3 3;0 4;2 6];
N=length(points);
M=nchoosek(N,2);

if(~exist('InitState'))
	InitState=rand(M,1);
end

fprintf(fid,'Initial state:\n');
fprintf(fid,'%d ',InitState);
fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'\nAvg. output state of the nodes after annealing for each temperature:\n');

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
th=th(:);

% Random initialization
%State = (rand(M,1)-0.5)>0;
%state=[0 1 1 0 0 0]'

State=InitState(:);
TempState=zeros(M,1);
disp(State')

T=1;
dT=0.01;
i=1;
while(T>0)
    %TempState=rand(M,1);
    T=T-dT;
    while(norm(State-TempState) >= 0.00001 & i<100)
        TempState = State;
	State = (W*State + th);
	State = tanh(State/T);
	i=i+1;
%disp(State')
%disp(norm(State-TempState))
%pause;
    end
disp(State')
	
    fprintf(fid,'%4.2f :',T);
    fprintf(fid,'%d ',State>0);
    fprintf(fid,'\n');

end

[sval,spos]=sort(State,'descend');
FinalState=zeros(M,1);
FinalState(spos(1:floor(N/2)))=1;

disp(FinalState)
    fprintf(fid,'\n');
    fprintf(fid,'\nFinal output state of the nodes:\n');
    fprintf(fid,'%d ',FinalState);
    fprintf(fid,'\n');


g=zeros(N,N);
ndx=unit(find(FinalState),:);
for i=1:size(ndx,1)
	g([ndx(i,1)],[ndx(i,2)])=1;
end
%xyminmax = min_max(points');

drawgraph(g,points);

print wmpoutput.png

fclose(fid);



return;
