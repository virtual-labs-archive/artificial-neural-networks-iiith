function coreSom(numCities, numNodes, numIterations, cityFlag,  iterationFlag, cityStep, iterationStep)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters obtained from the user.
% cityFlag iterationFlag cityStep iterationStep
% Global variables which dont change.
% X N d K T
% Global variables which change.
% W tauT
% currentCityIndex % To start from this index.
% currentIterationIndex % To start from this index.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( (iterationFlag==0) & (cityFlag == 0) )
	[X, W, K, T, N,d,tau0,tauT, currentCityIndex, currentIterationIndex, WBeforeUpdate] = initSom(numCities, numNodes, numIterations);
	WAfterUpdate = WBeforeUpdate;

else

	load("somState.dat");

	if (iterationFlag==1)
		% Honour the iterationStep.
		%cityStep = N - currentCityIndex + 1;
		iterationIndexUpperLimit = min(currentIterationIndex+iterationStep-1, T);
		cityIndexUpperLimit = N+1;
	else
		iterationIndexUpperLimit = currentIterationIndex;
		cityIndexUpperLimit = min(currentCityIndex+cityStep,N+1);
	end

	currentCityIndex	
	currentIterationIndex
	cityIndexUpperLimit
	iterationIndexUpperLimit
		
	% Each iteration covers all cities.
	iterationIndex=currentIterationIndex;
	while iterationIndex <= iterationIndexUpperLimit

		% For each city
		if(currentCityIndex>N) currentCityIndex=1; end
	%	currentCityIndex = mod(currentCityIndex,N);

		cityIndex = currentCityIndex;
		starCity = cityIndex;

		while cityIndex < cityIndexUpperLimit
	    
			% Compute distance between given city and all nodes.
			dist = sum((W(:,3:4) - repmat(X(cityIndex,:),K,1) ).^2, 2) ;
	    
			% Find winning node.
			[mindist, ind] = min(dist);
	    
			% Physical distance of other nodes from the winning node.
			pdist = sqrt(sum((W(:,1:2) - repmat(W(ind,1:2),K,1)).^2,2));
			factor = (1/sqrt(2))*exp(-pdist.*pdist/tauT/tauT);

			% Updating weights of all nodes.
			W(:,3:4) = W(:,3:4) + repmat(factor(:),1,2).*(repmat(X(cityIndex,:),K,1) - W(:,3:4));
			cityIndex = cityIndex + 1
		end
		
		currentCityIndex = cityIndex;

		iterationIndex = iterationIndex + 1;

		if (currentCityIndex > N)
			currentCityIndex = 1;
			currentIterationIndex = iterationIndex;
			% Update learning rate.
			tauT = tau0*exp(-10*iterationIndex/T);
		end
	 
	end

	WBeforeUpdate = WAfterUpdate;
	WAfterUpdate = W;
	
end % end of if ( (iterationFlag==0) & (cityFlag == 0) )


if ( (iterationFlag==0) & (cityFlag == 0) )


	% Generate figure;
	%figure;
	axes('FontSize', 25);

	subplot(1,2,1);
	plot(X(:,1), X(:,2), 'b*', "markersize", 15);
	xlabel('x-coordinate of city location');
	ylabel('y-coordinate of city location');
	title('Coordinates of cities');
	xlim([-0.1 1.1]);
	ylim([-0.1 1.1]);
	axis 'equal'
	
	
	axes('FontSize', 25);
	subplot(1,2,2);
	Wmod = W;
	Wmod(K+1,3:4) = Wmod(1,3:4);
	%plot(Wmod(:,3), Wmod(:,4), 'ko', "markersize", 10);
	plot(Wmod(:,3), Wmod(:,4), 'k.');
	hold on;
	%plot(Wmod(:,3), Wmod(:,4),'k');
	for ii=1:K
		text(Wmod(ii,3), Wmod(ii,4), num2str(ii));
	end
	hold off;
	xlabel('w_1');
	ylabel('w_2');
	title('Weight vectors coordinates of nodes');
	xlim([-0.1 1.1]);
	ylim([-0.1 1.1]);
	axis 'equal'

else

	%figure;

	axes('FontSize', 25);
	% Before update.
	subplot(1,2,1);
	Wmod = WBeforeUpdate;
	Wmod(K+1,3:4) = Wmod(1,3:4);
	%axes('FontSize', 15);
	plot(X(:,1), X(:,2), 'b*', "markersize", 15);
	hold on;
	plot(X(starCity,1), X(starCity,2), 'r*', "markersize", 20);
	%plot(Wmod(:,3), Wmod(:,4), 'ko', "markersize", 10);
	plot(Wmod(:,3), Wmod(:,4), 'k.');
	plot(Wmod(:,3), Wmod(:,4), 'k');

	for ii=1:K
		text(Wmod(ii,3), Wmod(ii,4), num2str(ii));
	end

	hold off;
	xlabel('x-coordinate of city location');
	ylabel('y-coordinate of city location');
	%title('Coordinates of cities and weights');
	title(['Before iteration # ' num2str(currentIterationIndex) ' , city # ' num2str(currentCityIndex)]);
	xlim([-0.1 1.1]);
	ylim([-0.1 1.1]);
	axis 'equal'


	% After update.
	axes('FontSize', 25);
	subplot(1,2,2);
	Wmod = WAfterUpdate;
	Wmod(K+1,3:4) = Wmod(1,3:4);
	%axes('FontSize', 25);
	plot(X(:,1), X(:,2), 'b*', "markersize", 15);
	hold on;
	plot(X(starCity,1), X(starCity,2), 'r*', "markersize", 20);
	%plot(Wmod(:,3), Wmod(:,4), 'ko', "markersize", 10);
	plot(Wmod(:,3), Wmod(:,4), 'k.');
	plot(Wmod(:,3), Wmod(:,4), 'k');

	for ii=1:K
		text(Wmod(ii,3), Wmod(ii,4), num2str(ii));
	end

	hold off;
	xlabel('x-coordinate of city location');
	ylabel('y-coordinate of city location');
	%title('Coordinates of cities and weights');
	title(['After iteration # ' num2str(currentIterationIndex) ' , city # ' num2str(currentCityIndex)]);
	xlim([-0.1 1.1]);
	ylim([-0.1 1.1]);
	axis 'equal'

	%title(['Itern #: ' num2str(currentIterationIndex) ' ; City #: ' num2str(currentCityIndex)]);


end

	% Save figure;
	print(sprintf('somState.png'));
	clear numCities numNodes numIterations cityFlag  iterationFlag cityStep iterationStep;

	save("somState.dat");

return;
