function [X] = generateData(inputDim, numPoints, regionType, numIterations)

%inputDim: 2,3 etc
%numPoints: Number of data points
%regionType: Square, circle, triangle.
	%pdfType: Uniform, Gaussian: Currently only uniform

	inputDim
	numPoints
	regionType
	numIterations

	if(regionType == 1)
	% Square and uniform pdf.
	X = rand(numPoints, inputDim);
	end
	
	% Circle and uniform pdf.
	if(regionType == 2)
	Y = rand(numPoints, inputDim);
	c = 0.5*ones(1,inputDim);
	C = repmat(c, numPoints,1);
	d = sqrt(sum( (Y-C).*(Y-C), 2) );
	pos = find(d<=0.5);
	X = Y(pos,:);
	end


	% Triangle and uniform pdf.
	if(regionType == 3)
	P = [0,0];
	Q = [1,0];
	R = [0.5, (sqrt(3))/2];

	tmp1 = rand(4*numPoints,2);
	pos = find( (tmp1(:,1) + tmp1(:,2)) < 1);
	tmp2 = tmp1(pos,:);
	[r,c] = size(tmp2);
	tmp3 = ones(r,1) - (tmp2(:,1) + tmp2(:,2));
	tmp2(:,3) =tmp3(:);
	tmp4 = repmat([P(1) Q(1) R(1)], r,1);
	tmp5 = repmat([P(2) Q(2) R(2)], r,1);
	x = sum(tmp2.*tmp4, 2);
	y = sum(tmp2.*tmp5, 2);

	Y(:,1) = x(:);
	Y(:,2) = y(:);
	[r,c] = size(Y);
	if r > numPoints
		X = Y(1:numPoints, :);
	else
		X = Y;
	end

	
	end

	[N,d] = size(X);
	X = X/max(max(abs(X)));
	L = 6; % gridLength;
	K = L^2; % L x L grid.
	T = numIterations;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables and setup

piConst = 3.1416;

% Initialize weights
% Each weight vector is a row vector.
% Weight index is a number, which can be converted into (i,j) form.
W = rand(K,d);

% Neuron index in (i,j) form.
[I,J] = ind2sub([L, L], 1:K);

indx(:,1) = I(:);
indx(:,2) = J(:);

% Number of neighbourhood neurons which need to be updated.
%sig0 = floor(K/9);
sig0 = 1;
% This number should be updated after every iteration/epoch.
sigT = sig0;
% Constant for updating sigT.
tau1 = T;

% Learning rate.
eta0 = 0.05;
etaT = eta0;
%  Constant for updating etaT.
tau2 = T;

currentIterationIndex = 1;

	% Connecting the adjacent nodes in the 2D map and plotting.
	%figure;
        axes('FontSize', 25);

        subplot(1,2,1);
        plot(X(:,1), X(:,2), 'ko', "markersize", 15);
        xlabel('x-coordinate of data');
        ylabel('y-coordinate of data');
        title('Data distribution');
        xlim([-0.1 1.1]);
        ylim([-0.1 1.1]);
        axis 'equal'

        subplot(1,2,2);
	for k=1:K
		wdist = indx - repmat(indx(k,:),K,1);
		wdistSqr = sum(wdist.*wdist, 2);
		neighbourIndex = find(wdistSqr == 1);

		%k
		%neighbourIndex
		%pause
		numNeighbours = length(neighbourIndex);
			
		for kk=1:numNeighbours
			wtemp(1,:) = W(k,:);
			ind = neighbourIndex(kk);
			wtemp(2,:) = W(ind,:);
			plot(wtemp(:,1), wtemp(:,2), 'k');
			hold on;
			clear wtemp ind;
		end
	end
	
	clear k  wdist wdistSqr neighbourIndex numNeighbours kk wtemp ind;
	plot(W(:,1), W(:,2), 'r*', "markersize", 15);
	hold off;
        xlabel('x-coordinate of weight vector');
        ylabel('y-coordinate of weight vector');
        title('Initial state of SOM');
        xlim([-0.1 1.1]);
        ylim([-0.1 1.1]);
        axis 'equal'

        % Save figure;
        print(sprintf('clnnState.png'));

	% Save state of variables.
        save("clnnState.dat");

	return;













	% Three-fourth of a square and uniform pdf.
	clear X;
	X1 = 0.5*rand(numPoints,inputDim);
	X2 = X1;
	X3 = X1;
	X2(:,2) = X2(:,2) + repmat(0.5,numPoints,1);
	X3(:,1) = X3(:,1) + repmat(0.5,numPoints,1);
	X= [X1;X2;X3];
	figure;plot(X(:,1), X(:,2), 'k*');
	



