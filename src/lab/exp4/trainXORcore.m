function [] = trainXORcore(inputDim, numberofhiddenNodes)


switch(inputDim)
        case 2
                [nnet]=trainXOR2bit(numberofhiddenNodes);
        case 3
                [nnet]=trainXOR3bit(numberofhiddenNodes);
        case 4
                [nnet]=trainXOR4bit(numberofhiddenNodes);
	case -1
		[nnet]=trainXORlinear(numberofhiddenNodes);
	case -2 
		[nnet]=trainXORnonlinear(numberofhiddenNodes);
end

return;
