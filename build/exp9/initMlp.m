function  [X, X1, X2, w, W, P, T, N, d, r, eta0, etaT, indexArray, currentSampleIndex, trainingSample, currentIterationIndex, globalCount, updateFlag] = initMlp(numSamplesPerClass, numIterations)

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
