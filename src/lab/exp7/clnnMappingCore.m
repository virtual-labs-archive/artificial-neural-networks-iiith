function [] = clnnMappingCore(iterationStepSize)

  	%X: Matrix of input vectors (N X d):
  	% Each input vector is a row vector.  
  	%N: Number of input vectors.
  	%d: Dimension of each input vector.
 
    	%gridLength: Number of neurons per side (assuming a square grid of neurons).
  	%numIterations: Total number of iterations / time-steps
          
	% SOM/Kohonen map K neurons arranged in a square LxL layout (K = L^2)
	% mapping a square

load("clnnState.dat");
maxIterationIndex = min(currentIterationIndex+iterationStepSize-1, numIterations);
currentIterationIndex
maxIterationIndex

% For each iteration
for i=currentIterationIndex:maxIterationIndex
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
      		dist = 1/(sqrt(2*piConst)*sigT).*exp( sum(( ([I( : ), J( : )]-  repmat([ri(j,1), ri(j,2)], K,1)) .^2) ,2)/(-2*sigT)) * etaT;

      		
		W = W + repmat(dist(:),1,d).*(repmat(X(j,:),K,1) - W);

		% Clear temp variables.
		clear j dist tsumdist mindist ind;
		
      	end
     
	clear ri rnd; 
  	% Update neighbourhood function.
  	sigT = sig0*exp(-i/tau1);
    
  	% Update the learning rate.
  	etaT = eta0*exp(-i/tau2);
end

currentIterationIndex = i+1;
clear iterationStepSize;

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
	k=currentIterationIndex-1;
	plot(W(:,1), W(:,2), 'r*', "markersize", 15);
	hold off;
        xlabel('x-coordinate of weight vector');
        ylabel('y-coordinate of weight vector');
	title(['SOM after iteration #' num2str(k)]);
        xlim([-0.1 1.1]);
        ylim([-0.1 1.1]);
        axis 'equal'


       % Save figure;
        print(sprintf('clnnState.png'));

	% Save state of variables.
        save("clnnState.dat");

