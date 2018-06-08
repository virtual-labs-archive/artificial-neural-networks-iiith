function [xorDesiredOutput,nnOutput,binaryOutput,input] = testXOR3bit(nnet)

input = [0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]';
[r,c] = size(input);

for i=1:c
	xorDesiredOutput(i) = xor(input(1,i), xor(input(2,i), input(3,i)) );
end

%input1 = input(1:2,:);
%output1 = sim(nnet, input1);

%input2(1,:) = round((output1(:))');
%input2(2,:) = input(3,:);

%output2 = sim(nnet, input2);

output = sim(nnet,input);

xorDesiredOutput = xorDesiredOutput(:)
%nnOutput = output2(:)
nnOutput  = output(:)
binaryOutput = round(nnOutput)

return;
