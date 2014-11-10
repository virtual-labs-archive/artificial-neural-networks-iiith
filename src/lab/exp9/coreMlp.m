function coreMlp(numSamplesPerClass, numIterations, sampleFlag,  iterationFlag, sampleStep, iterationStep)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters obtained from the user.

% Global variables which dont change.

% Global variables which change.

% currentSampleIndex % To start from this index.
% currentIterationIndex % To start from this index.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( (iterationFlag==0) & (sampleFlag == 0) )
	[X, X1, X2, w, W, P, T, N, d, r, eta0, etaT, indexArray, currentSampleIndex, trainingSample, currentIterationIndex, globalCount, updateFlag] = initMlp(numSamplesPerClass, numIterations);
	
else

	load("tmp/mlpState.dat");

	if (iterationFlag==1)
		% Honour the iterationStep.
		iterationIndexUpperLimit = min(currentIterationIndex+iterationStep-1, T);
		sampleIndexUpperLimit = N+1;
	else
		iterationIndexUpperLimit = currentIterationIndex;
		sampleIndexUpperLimit = min(currentSampleIndex+sampleStep,N+1);
	end

	currentIterationIndex
	iterationIndexUpperLimit
	currentSampleIndex
	sampleIndexUpperLimit
		
	% Each iteration covers all sample indices in the index array.
	iterationIndex=currentIterationIndex;
	while iterationIndex <= iterationIndexUpperLimit

		if(currentSampleIndex>N) 
			currentSampleIndex=1;
		end

		sampleIndex = currentSampleIndex;

		% For each sample
		while sampleIndex < sampleIndexUpperLimit

				if (updateFlag == 1) % 

					sampleIndex
	
					i = indexArray(sampleIndex);
					trainingSample = X(i, 1:d);
					trainingSampleIndex = sampleIndex;
	   
					% Augmented input vector;
					a = [-1 X(i,1:d)]';

					% Inner product of augmented input weight vector and augmented weight vector.
					s = sum(w(:).*a(:));
		
					% Adjustment of weights
					if ( (X(i,r) == 1) & (s <= 0) )
					w(:) = w(:) + etaT*a(:);
					disp('Weights are adjusted');
					end

					if ( (X(i,r) == 2) & (s > 0) )
						w(:) = w(:) - etaT*a(:);	
					disp('Weights are adjusted');
					end

					% After each adjustment of weights, check if the line
					% can separate thw two clusters.
			
					A1(1:P,1) = repmat(-1, P,1);
					A1(1:P,2:d+1) = X1(:,1:d);
			
					A2(1:P,1) = repmat(-1, P,1);
					A2(1:P,2:d+1) = X2(:,1:d);
		
					Wmat = repmat( (w(:))', P,1);
					flag1 = sum(sum(A1.*Wmat,2) > 0);
					flag2 = sum(sum(A2.*Wmat,2) <= 0);
			
					if ( (flag1 == 0) & (flag2 == 0) ) % Indicates 100% misclassification
						updateFlag = 0;
					end

					if ( (flag1 == P) & (flag2 == P) ) % Indicates 100% classification
						updateFlag = 0;
					end
			
					W(:,globalCount) = w(:);
					globalCount = globalCount + 1;
 					sampleIndex = sampleIndex + 1;
				else				
					break;
				end

		end % End of inner while loop.
		
		currentSampleIndex = sampleIndex;

		iterationIndex = iterationIndex + 1;

		if (currentSampleIndex > N)
			currentSampleIndex = 1;
			currentIterationIndex = iterationIndex;
			indexArray = randperm(N);	
			% Update learning rate.
			etaT = eta0*exp(-2*iterationIndex/T);
		end
	 
	end % End of outer while loop.

end % end of if ( (iterationFlag==0) & (sampleFlag == 0) )

	% Show the points of two classes and draw the line described
	% by weights.
	close all;

	if globalCount == 1
		% For initial conditions.
		[row,col] = size(W);
		wp = W(:,col);
	
		x1 = -0.5;
		y1 = (wp(1) - wp(2)*x1)/wp(3);
		x2 = 1.5;
		y2 = (wp(1) - wp(2)*x2)/wp(3);

		figure;
		axes('FontSize', 14);
		plot(X1(:,1), X1(:,2), 'b*', "markersize", 10);
		hold on;
		plot(X2(:,1), X2(:,2), 'r*', "markersize", 10);
		line([x1 x2]', [y1 y2]', 'Color', [0 0 0]);
		%title(['Iteration #: ' num2str(currentIterationIndex) ' ; Sample #: ' num2str(currentSampleIndex)]);
		title('Points of two classes and the line described by initial weights');
		hold off;
		xlabel('x-coordinate of input sample');
		ylabel('y-coordinate of input sample');
		xlim([-0.1 1.2]);
		ylim([-0.2 1.2]);

	else
		% Before the training sample is presented.
		[row,col] = size(W);
		wp = W(:,col-1);
	
		figure;	
		axes('FontSize', 25);
		subplot(1,2,1);
		x1 = -0.5;
		y1 = (wp(1) - wp(2)*x1)/wp(3);
		x2 = 1.5;
		y2 = (wp(1) - wp(2)*x2)/wp(3);
	
		plot(X1(:,1), X1(:,2), 'b*', "markersize", 10);
		hold on;
		plot(X2(:,1), X2(:,2), 'r*', "markersize", 10);
		line([x1 x2]', [y1 y2]', 'Color', [0 0 0]);
		plot(trainingSample(1), trainingSample(2), 'k*', "markersize", 15);
		%title(['Iteration #: ' num2str(currentIterationIndex) ' ; Sample #: ' num2str(currentSampleIndex)]);
		title(['Iteration #: ' num2str(currentIterationIndex) ': BEFORE presenting sample #: ' num2str(trainingSampleIndex)]);
		hold off;
		xlabel('x-coordinate of input sample');
		ylabel('y-coordinate of input sample');
		xlim([-0.1 1.2]);
		ylim([-0.2 1.2]);

		axis 'equal'

		dW = sum(abs(W(:,col-1) - W(:,col)));

		clear x1 y1 x2 y2 wp;
		% After the training sample is presented.
		subplot(1,2,2);
		wp = W(:,col);
		x1 = -0.5;
		y1 = (wp(1) - wp(2)*x1)/wp(3);
		x2 = 1.5;
		y2 = (wp(1) - wp(2)*x2)/wp(3);

		plot(X1(:,1), X1(:,2), 'b*', "markersize", 10);
		hold on;
		plot(X2(:,1), X2(:,2), 'r*', "markersize", 10);
		line([x1 x2]', [y1 y2]', 'Color', [0 0 0]);
		plot(trainingSample(1), trainingSample(2), 'k*', "markersize", 15);
		% title(['Iteration #: ' num2str(currentIterationIndex) ' ; Sample #: ' num2str(currentSampleIndex)]);
		title(['Iteration #: ' num2str(currentIterationIndex) ': AFTER presenting sample #: ' num2str(trainingSampleIndex)]);

		if (dW == 0)
			text(0.2, 1.08, 'Weights are NOT updated.');
		else
			text(0.2, 1.08, 'Weights ARE updated.');
		end

		if (updateFlag == 0)
			text(0.2, 1.0, 'A separating line is achieved.');
			text(0.2, 0.9, 'No more update of weights.');
			
		end
		

		hold off;
		xlabel('x-coordinate of input sample');
		ylabel('y-coordinate of input sample');

		xlim([-0.1 1.2]);
		ylim([-0.2 1.2]);
		axis 'equal'
		clear x1 y1 x2 y2 wp;
	end

	% Save figure;
	print(sprintf('tmp/mlpState.png'));

	clear numSamplesPerClass numIterations sampleFlag  iterationFlag sampleStep iterationStep wp;
	clear i a s row col;

	save("tmp/mlpState.dat");

return;
