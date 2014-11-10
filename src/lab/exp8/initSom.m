function  [X, W, K, T, N,d,tau0,tauT, currentCityIndex, currentIterationIndex, WBeforeUpdate] = initSom(numCities, numNodes, numIterations)
	X = rand(numCities,2);
	K = numNodes;
	T = numIterations;
 
	% Number of cities.
	[N,d] = size(X);

	% Each node has four dimensions:
	% Index of previous node, index of next node, and two weights.
	% Normalizing the city coordinates.

	W = zeros(K,4);

% Physically arrange nodes along the rim of a unit circle.
r = ones(K,1);
theta = [0:2*pi/(K-1):2*pi] + pi/(K-1);
[wx, wy] = pol2cart(theta(:), r(:));
W(:,1) = wx(:);
W(:,2) = wy(:);

% Initialize weights
W(:,3:4) = rand(K,2);
WBeforeUpdate = W;


% Learning rate.
tau0 = 1.0;
tauT = tau0;

currentCityIndex =1;
currentIterationIndex =1;
