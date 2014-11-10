function [xorDesiredOutput,nnOutput,binaryOutput,input] = testXOR2bit(nnet)

input = [0 0; 0 1; 1 0; 1 1]';
[r,c] = size(input);

for i=1:c
	xorDesiredOutput(i) = xor(input(1,i), input(2,i));
end

output = sim(nnet, input);

xorDesiredOutput = xorDesiredOutput(:)
nnOutput = output(:)
binaryOutput = round(nnOutput)

return;
