%function tsp()

clear all;

N=10;
points=[1 1;3 3;0 4;2 6;1 2;3 5;2 6;1 4;2 5;4 5];

clear d
for i=1:N
	for j=1:N
		d(i,j)=norm(points(i,:)-points(j,:));
	end
end

%alpha=2.7; beta=0.3; gamma=3.7; 
alpha=3.0; beta=1.2; gamma=4.2; 

rowndx=0;

for i=1:N
	for a=1:N
		rowndx=rowndx+1;
		colndx=0;
		for j=1:N
		for b=1:N
			colndx=colndx+1;
			term1=d(a,b)*(1-delta(a,b))*(delta(i-1,j)+delta(i+1,j));
			term2=alpha*(1-delta(a,b))*delta(i,j);
			term3=beta*(1-delta(i,j))*delta(a,b);
			W(rowndx,colndx)=term1+term2+term3;
		end
		end
	end
end

th=gamma*N;

% Taka a random state

State=rand(N*N,1);
TempState=zeros(N*N,1);
T=1;
dT=0.001;
while T > 0
	T=T-dT;
	index=0;
	while(norm(TempState-State) >= 0.1)
		TempState=State;
		State=W*State-th;
		State=1./(1+exp(-State/T));
		index=index+1;
	end
end

FinalState=reshape(State,[10 10])