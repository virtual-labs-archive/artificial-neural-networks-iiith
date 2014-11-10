function [xorDesiredOutput,nnOutput,binaryOutput,input] = testXORlinear(nnet)

%Number of samples per class = P 
P = 20;

dxy=0.02;

k=1;
for i=0:dxy:1
for j=0:dxy:1
X(k,:)=[i j];
k=k+1;
end
end

% Generate samples and initialize class index.
%x1 = rand(P,2);
%x2 = rand(P,2);

%xoffset = 1.0;
%yoffset = 1.0;

%x2 = x2 + repmat([xoffset,yoffset],P,1);

%X(1:P,1:2) = x1;
%X(1:P,3) = repmat(1,P,1);

%X(P+1:2*P,1:2) = x2;
%X(P+1:2*P,3) = repmat(0,P,1);

[N,col] = size(X);
%d = col-1;
d = col;

% Normalize data.
Xmax = max(max(abs(X(:,1:d))));
X(:,1:d) = X(:,1:d)/Xmax;

% Identify elements of class-1 and class-2.
%i1 = find(X(:,col) == 1);
%i2 = find(X(:,col) == 0);
%X1 = X(i1,1:d);
%X2 = X(i2,1:d);

input = X(:,1:d)'
[r,c] = size(input);

%xorDesiredOutput = X(:,col)';
	
output = sim(nnet,input);

%xorDesiredOutput = xorDesiredOutput(:)
nnOutput  = output(:)
binaryOutput = round(nnOutput) 

o1 = find(binaryOutput == 1);
o2 = find(binaryOutput == 0);
O1 = X(o1,1:d);
O2 = X(o2,1:d);

testflag = 1;
if testflag==1

%%% Plotting the testing samples %%%%

	figure; 
	axes('FontSize', 14);
	plot(O1(:,1), O1(:,2), 'b*', "markersize", 10);
	hold on;
	plot(O2(:,1), O2(:,2), 'r*', "markersize", 10);
%       line([x1 x2]', [y1 y2]', 'Color', [0 0 0]);
	xlabel('x-coordinate of test sample');
	ylabel('y-coordinate of test sample');
	xlim([-0.1 1.2]);
	ylim([-0.2 1.2]);
end

% Save figure;
print(sprintf('mlffnntestingSamples.png'));


return;

