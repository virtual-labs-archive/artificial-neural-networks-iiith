function [nnet] = trainXORnonlinear(numberOfhiddenNodes)

%inputDim
%numberOfhiddenNodes

% Number of samples per class = P 
P = 50;
% Generate samples and initialize class index.
 	 
x1 = rand(P,2);
x2 = rand(P,2);
x3 = rand(P,2);
x4 = rand(P,2);

xoffset = 1.0;
yoffset = 1.0;

x2 = x2 + repmat([xoffset,0],P,1);
x3 = x3 + repmat([xoffset,yoffset],P,1);
x4 = x4 + repmat([0,yoffset],P,1);

X(1:P,1:2) = x1;
X(1:P,3) = repmat(1,P,1);

X(P+1:2*P,1:2) = x2;
X(P+1:2*P,3) = repmat(0,P,1);

X(2*P+1:3*P,1:2) = x3;
X(2*P+1:3*P,3) = repmat(1,P,1);

X(3*P+1:4*P,1:2) = x4;
X(3*P+1:4*P,3) = repmat(0,P,1);

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

xorDesiredOutput = X(:,col)';

max_x1_x4_x = max(X(1:P,1),X(3*P+1:4*P,1));
min_x2_x3_x = min(X(P+1:2*P,1),X(2*P+1:3*P,1));
max_x1_x2_y = max(X(1:2*P,2));
min_x3_x4_y = min(X(2*P+1:4*P,2));

xx1 = (max_x1_x4_x + min_x2_x3_x)/2;
yy1 = -0.2;

xx2 = xx1;
yy2 = 1.2;

xx3 = -0.2;
yy3 = (max_x1_x2_y + min_x3_x4_y)/2;

xx4 = 1.2;
yy4 = yy3;

flag = 1;
if flag==1

%%% Plotting the training samples %%%%
		
		figure;               
		axes('FontSize', 14);                                           
		plot(X1(:,1), X1(:,2), 'bv', "markersize", 10);                                         
		hold on;                                                
		plot(X2(:,1), X2(:,2), 'r^', "markersize", 10);                                                                                         
%		line([xx1 xx2]', [yy1 yy2]', 'Color', [0 0 0]);
%		line([xx1 xx2]', [yy1 yy2]');                                                                                                             
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

