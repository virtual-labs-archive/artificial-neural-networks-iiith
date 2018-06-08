function [] = clnn_mapping_2D_2D(X, gridLength, numIterations)

  	%X: Matrix of input vectors (N X d): 
  	% Each input vector is a row vector.  
  	%N: Number of input vectors. 
  	%d: Dimension of each input vector.
 
    	%gridLength: Number of neurons per side (assuming a square grid of neurons).
  	%numIterations: Total number of iterations / time-steps
  
          
	% SOM/Kohonen map K neurons arranged in a square LxL layout (K = L^2)
	% mapping a square


  
	[N,d] = size(X);
	X = X/max(max(abs(X)));
	L = gridLength;
	K = L^2;
	T = numIterations;


	figure;
	plot(X(:,1), X(:,2), 'k*');
	pause



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variables and setup

pi = 3.1416;

% Initialize weights
% Each weight vector is a row vector.
% Weight index is a number, which can be converted into (i,j) form.
W = rand(K,d);

% Neuron index in (i,j) form.
[I,J] = ind2sub([L, L], 1:K);

indx(:,1) = I(:);
indx(:,2) = J(:);


% Number of neighbourhood neurons which need to be updated.
sig0 = floor(K/5);

% This number should be updated after every iteration/epoch.
sigT = sig0;

% Constant for updating sigT.
tau1 = T;

% Learning rate.
eta0 = 0.1;
etaT = eta0;

%  Constant for updating etaT.
tau2 = 2*T;

% dT: Number of iterations/time-steps for which plot needs to be shown once.
% For example, if dT=10, then plot is generated once in every 10 iterations.
dT = 20;



% For each iteration
for i=1:T
  	ri=[];
  	disp('Iteration number:')
	disp(i)

	rnd = randperm(N);
 
	% For N input vectors. 
  	for p=1:N
    		j=rnd(p);
    
      		% Compute distance.
      		dist = (W - repmat(X(j,:),K,1) ).^2 ;
      		tsumdist = sum(dist,2);
    
      		% Find winning neuron.
      		[mindist ind] = min(tsumdist);
    
      		% 2D index of winning neuron.
      		ri(j,1) = I(ind);
      		ri(j,2) = J(ind);


      		% Distance of other neurons from the winning neuron.
      		dist = 1/(sqrt(2*pi)*sigT).*exp( sum(( ([I( : ), J( : )]-  repmat([ri(j,1), ri(j,2)], K,1)) .^2) ,2)/(-2*sigT)) * etaT;

      		
		W = W + repmat(dist(:),1,d).*(repmat(X(j,:),K,1) - W);

		% Plotting weights  
		

      	end
      
  	% Update neighbourhood function.
  	sigT = sig0*exp(-i/tau1);
    
  	% Update the learning rate.
  	etaT = eta0*exp(-i/tau2);

	if mod(i,dT) == dT-1
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
		plot(W(:,1), W(:,2), 'r*');
		hold off;
		pause
	end

  	% Plotting weights  
  	%if mod(i,dT) == dT-1
	%	labels = num2str(C(:));
	%	text(ri(:,1), ri(:,2), labels);
	%	pause
  	%end
end


