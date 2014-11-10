function  [X, X1, X2, w, W, P, T, N, d, r, eta0, etaT, indexArray, currentSampleIndex, trainingSample, currentIterationIndex, globalCount, updateFlag] = initMlp(numSamplesPerClass, numIterations, linearity_flag)

if linearity_flag ==1

	P = numSamplesPerClass;

	% Generate samples and initialize class index.
        x1 = rand(P,2);
        x2 = rand(P,2);

	xoffset = 1.4;
	yoffset = 0.8;
        x2 = x2 + repmat([xoffset,yoffset],P,1);

        X(1:P,1:2) = x1;
        X(1:P,3) = repmat(1,P,1);

        X(P+1:2*P,1:2) = x2;
        X(P+1:2*P,3) = repmat(2,P,1);
	
	T = numIterations;
 
	[N,r] = size(X);
	d = r-1;
else 
        
	P = numSamplesPerClass;
	Q = floor(P/2);
	% Generate samples and initialize class index.
	x1 = rand(Q,2);
	x2 = rand(Q,2);
	x3 = rand(Q,2);
	x4 = rand(Q,2);

	xoffset = 1.4;
	yoffset = 1.4;
%	x2 = x2 + repmat([xoffset,yoffset],P,1);
	x2 = x2 + repmat([xoffset,0],Q,1);
	x3 = x3 + repmat([xoffset,yoffset],Q,1);
	x4 = x4 + repmat([0,yoffset],Q,1);

	X(1:Q,1:2) = x1;
	X(1:Q,3) = repmat(1,Q,1);

	X(Q+1:2*Q,1:2) = x2;
	X(Q+1:2*Q,3) = repmat(2,Q,1);

	X(2*Q+1:3*Q,1:2) = x3;
	X(2*Q+1:3*Q,3) = repmat(1,Q,1);

	X(3*Q+1:4*Q,1:2) = x4;
	X(3*Q+1:4*Q,3) = repmat(2,Q,1);

	T = numIterations;
	
	[N,r] = size(X);
	d = r-1;


end

% Normalize data.
Xmax = max(max(abs(X(:,1:d))));
X(:,1:d) = X(:,1:d)/Xmax;

% Identify elements of class-1 and class-2.
i1 = find(X(:,r) == 1);
i2 = find(X(:,r) == 2);

X1 = X(i1,1:d);
X2 = X(i2,1:d);

% Learning rate.
eta0 = 0.1;
etaT = eta0;

% Initialize weights.
wtmp = rand(1,d);
x = X1(1,1);
y = X1(1,2);
%theta = W(1)*x + W(2)*y;
theta = rand(1);
w = [theta (wtmp(:))']';
w = w(:);

% Make provision for storing weights for all iterations.
W(:,1) = w;
W(:,2) = w;

% Generate indices from 1 to N, but in a random fashion.
indexArray = randperm(N);

currentSampleIndex =1;
trainingSample = X(indexArray(currentSampleIndex), 1:d);
currentIterationIndex =1;
globalCount = 1;
updateFlag = 1;
