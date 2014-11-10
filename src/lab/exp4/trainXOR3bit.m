function [nnet] = trainXOR3bit(numberOfhiddenNodes)

%inputDim
%numberOfhiddenNodes

input = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]';
[r,c] = size(input);

for i=1:c
	xorDesiredOutput(i) = xor(input(1,i), xor(input(2,i), input(3,i)) );
end

% num. of input nodes (dimensionality of input).

% min and max values for  2 input elements.
Pr = repmat([0 1], 3, 1);

% num. of elements in Ss = num. of layers (excluding i/p, including o/p).
Ss = [numberOfhiddenNodes 1];


%trf = {"tansig","purelin"};
trf = {"tansig","tansig"};
%trf = {"tansig","logsig"};
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

