function [nnet] = trainXORlinear(numberOfhiddenNodes)

%inputDim
% numberOfhiddenNodes

%Number of samples per class = P 
P = 100;
% Generate samples and initialize class index.
 	 
x1 = rand(P,2);
x2 = rand(P,2);

xoffset = 1.4;
yoffset = 1.4;
x2 = x2 + repmat([xoffset,yoffset],P,1);
	 
X(1:P,1:2) = x1;
X(1:P,3) = repmat(1,P,1);

X(P+1:2*P,1:2) = x2;
X(P+1:2*P,3) = repmat(0,P,1);

[N,col] = size(X);

d = col-1;

% Normalize data.
Xmax = max(max(abs(X(:,1:d))));
X(:,1:d) = X(:,1:d)/Xmax;

% Identify elements of class-1 and class-2.
i1 = find(X(:,col) == 1);
i2 = find(X(:,col) == 0);
X1 = X(i1,1:d);
X2 = X(i2,1:d);

input = X(:,1:d)';
%input = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]';
[r,c] = size(input);

%for i=1:c
%	xorDesiredOutput(i) = xor(input(1,i), xor(input(2,i), input(3,i)) );
%end
xorDesiredOutput = X(:,col)';

flag = 1;
if flag==1

%%% Plotting the training samples %%%%
	
		figure;               
		axes('FontSize', 14);                                           
		plot(X1(:,1), X1(:,2), 'b*', "markersize", 10);                                         
		hold on;                                                
		plot(X2(:,1), X2(:,2), 'r*', "markersize", 10);                                                                                         
%		line([x1 x2]', [y1 y2]', 'Color', [0 0 0]);                                                                                                             
		xlabel('x-coordinate of training sample');
		ylabel('y-coordinate of training sample');
		xlim([-0.1 1.2]);
		ylim([-0.2 1.2]);
end
		
% Save figure;
print(sprintf('mlffnntrainingSamples.png'));

% min and max values for  2 input elements.
Pr = repmat([0 1], 2, 1);

% num. of elements in Ss = num. of layers (excluding i/p, including o/p).
Ss = [numberOfhiddenNodes 1];

%trf = {"tansig","purelin"};
%trf = {"tansig","tansig"};
trf = {"tansig","logsig"};
btf = "trainlm";
blf = "learngdm";
pf = "mse";
nnet = newff(Pr, Ss, trf, btf, blf, pf);

figure;
nnet = train(nnet, input, xorDesiredOutput); 

%obtainedOutput = sim(nnet,input);
%xorDesiredOutput
%round(obtainedOutput)


xlabel('Number of iterations');
ylabel('Mean squared error');
title('Variation of training error');

clear input r c xorDesiredOutput Pr Ss trf btf blf pf;

% Save figure;
print(sprintf('mlffnnState.png'));

% Save state of variables.
save("mlffnnState.dat");

return;

