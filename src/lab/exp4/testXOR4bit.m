function [xorDesiredOutput,nnOutput,binaryOutput,input] = testXOR4bit(nnet)

input = [0 0 0 0; 0 0 0 1; 0 0 1 0; 0 0 1 1; 0 1 0 0; 0 1 0 1; 0 1 1 0; 0 1 1 1;1 0 0 0; 1 0 0 1; 1 0 1 0; 1 0 1 1; 1 1 0 0; 1 1 0 1; 1 1 1 0; 1 1 1 1]';
[r,c] = size(input);

for i=1:c
	tmpOut = xor(input(1,i), xor(input(2,i), input(3,i)));
	xorDesiredOutput(i) = xor(tmpOut, input(4,i));
end

clear tmpOut;

%input1 = input(1:2,:);
%input2 = input(3:4,:);

%output1 = sim(nnet, input1);
%output2 = sim(nnet, input2);

%input3(1,:) = round((output1(:))');
%input3(2,:) = round((output2(:))');
%output3 = sim(nnet, input3);
output = sim(nnet, input);

xorDesiredOutput = xorDesiredOutput(:)
%nnOutput = output3(:)
nnOutput = output(:)
binaryOutput = round(nnOutput)

return;

