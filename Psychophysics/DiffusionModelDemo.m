function DiffusionModelDemo(myDriftRate, myRandom_drift_std, myRandom_starting_std)
% (c)       FAW     10.11.2012  Basic version ready.
%                               Not implemented: Random variation in drift
%                               rate and starting point (see Ratcliff &
%                               Rouder, 1998).
%                   02.07.2013  Implemented random drift rates and starting
%                               points. Changed input variables and some
%                               names.
%           DHJ     02.07.2014  Cleaned up the code a bit


%% Setup constants and parameters

% parameters
NUMBER_OF_RUNS = 1000;
TIME_SCALER = 0.001;
LOWER_BOUND = 0;
UPPER_BOUND = 1;

% argument defaults
if nargin < 1, myDriftRate = 3; end
if nargin < 2, myRandom_drift_std = 0; end
if nargin < 3, myRandom_starting_std = 0; end

% derived parameters
myStartPoint = 0.5*(LOWER_BOUND + UPPER_BOUND);
nBin = min(100, mean(sqrt(NUMBER_OF_RUNS)));


%% Calculate 'per-trial' parameters
% Since drift rate and starting point can have a variance, we generate the
% random vectors containing the 'per-trial' values.

deviance = myRandom_drift_std .* randn(NUMBER_OF_RUNS, 1);
myDriftRateVector = myDriftRate + deviance;
deviance = myRandom_starting_std .* randn(NUMBER_OF_RUNS, 1);
myStartingPointVector = myStartPoint + deviance;
clear deviance


%% Run the simulations

tic
for j = 1:NUMBER_OF_RUNS
    % Run a model
    tmp = DiffusionModel(myDriftRateVector(j), TIME_SCALER, ...
                         UPPER_BOUND, myStartingPointVector(j));

    % Store the stimulation results
    correctVector(j) = tmp.correct;     % Correct: 1, Incorrect: 0
    stepVector(j) = tmp.steps;          % Amount of steps
    timeVector(j) = tmp.time;           % Elapsed simulated time: (steps * TIME_SCALER)
    stateMatrix{j, :} = tmp.states;     % The full path taken
end
elapsedTime = toc;
clear tmp


%% Plot 1: Results summary

% Make a histogram of the elapsed times
figure(1), clf

[n, x] = hist(timeVector, nBin);
bar(x, n, 'c')
title(['Drift rate = ' num2str(myDriftRate) ...
       ' -- bounds = [' num2str(LOWER_BOUND) ' ' num2str(UPPER_BOUND) ']' ...
       ' -- startpoint = ' num2str(myStartPoint) ])
xlabel('Time to reach bound [in seconds]')
ylabel('# per bin')

% Calculate result summaries
percentCorrect = round(100 * mean(correctVector));
meanTime = round(100 * mean(timeVector)) / 100;
stdTime = round(1000*std(timeVector))/1000;
skewTime = skewness(timeVector);
meanSteps = round(mean(stepVector));
stdSteps = round(std(stepVector));

% Print summary of results as text
text(mean(x), 0.9*max(n), ['Correct = ' num2str(percentCorrect) ' %.'])
text(mean(x), 0.85*max(n), ['Mean time = ' num2str(meanTime) ...
                            ' s \pm '  num2str(stdTime), ' s'])
text(mean(x), 0.8*max(n), ['skew = ' num2str(skewTime)])
text(mean(x), 0.75*max(n), ['Simulation steps K = ' num2str(meanSteps) ...
                            '\pm ' num2str(stdSteps)])
text(mean(x), 0.7*max(n), ['T = ' num2str(round(100*elapsedTime)/100) ' s '...
                           'for N = ' num2str(NUMBER_OF_RUNS) ' repetitions'])


%% Plot 2: Example runs
% Plot 5 runs from the state matrix:
% 1. shortest
% 2. 10th percentile
% 3. 90th percentile
% 4. longest
% 5. median

figure(2), clf

% Get sorted indices of shortest-to-longest runs
[stepVector index] = sort(stepVector);

% Grab the state-data for each run we want to plot
shortestRun = stateMatrix{index(1), :};
shortRun = stateMatrix{index(round(0.1 * NUMBER_OF_RUNS)), :};
medianRun = stateMatrix{index(round(NUMBER_OF_RUNS / 2)), :};
longRun = stateMatrix{index(round(0.9 * NUMBER_OF_RUNS)), :};
longestRun = stateMatrix{index(end), :};


% Plot the 5 runs
hold on
h_shortest = plot(shortestRun, 'g--');
h_short = plot(shortRun, 'g-');
h_median = plot(medianRun, 'b-');
h_long = plot(longRun, 'r-');
h_longest = plot(longestRun, 'r--');

hold off

% Format the lines
set(h_short, 'LineWidth', 3);
set(h_long, 'LineWidth', 3);
set(h_median, 'LineWidth', 3);

% Format the axes
set(gca, 'ylim', [LOWER_BOUND, UPPER_BOUND], ...
         'xlim', [0 stepVector(end)]);

% Add a legend
legend({'Shortest', ...
        '10th percentile', ...
        'Median', ...
        '90th percentile', ...
        'Longest'});



%% Plot 3: Elapsed time: correct vs error
% Analyse the data separately for correct and incorrect trials

figure(3), clf

% Get indices to the correct and error runs
correctIndex = find(correctVector == 1);
errorIndex = find(correctVector == 0);

% Bin the durations for correct and error seperately
[nCorrect, x] = hist(timeVector(correctIndex), nBin);
nError = hist(timeVector(errorIndex), x);

% Plot both histograms
hold on
bar(x, nCorrect, 'g');
bar(x, -nError, 'r');
hold off

% Calculate mean-times seperately
meanTimeCorrect = mean(timeVector(correctIndex));
meanTimeError = mean(timeVector(errorIndex));

% Add these times to the plot
text(mean(x), 0.85*max(nCorrect), ...
     ['Mean time correct = ' num2str(meanTimeCorrect) ' s'])
text(mean(x), 0.80*max(nCorrect), ...
     ['Mean time error    = ' num2str(meanTimeError) ' s'])


%% Plot 4: drift rate analysis

figure(4), clf

% Plot the histogram of the drift rate data
[nDrift, x] = hist(myDriftRateVector, nBin);
bar(x, nDrift, 'y')

% Label the axes
xlabel('drift rates')
ylabel('# per bin')

% Calculate summary statistics
meanDriftRate = mean(myDriftRateVector);
stdDriftRate = std(myDriftRateVector);

% Add these statistics to the plot
text(0.5*(max(x)+mean(x)), 0.85*max(nDrift), ...
     ['Mean drift rate = ' num2str(meanDriftRate)])
text(0.5*(max(x)+mean(x)), 0.8*max(nDrift), ...
     ['SD drift rate = ' num2str(stdDriftRate)])


%% Plot 5: starting point analysis

figure(5), clf

% Plot the histogram of the starting point data
[nStartPoint, x] = hist(myStartingPointVector, nBin);
bar(x, nStartPoint, 'm')

% Label the axes
xlabel('starting points')
ylabel('# per bin')

% Calculate summary statistics
meanStartPoint = mean(myStartingPointVector);
stdStartPoint = std(myStartingPointVector);

% Add these statistics to the plot
text(0.5*(max(x)+mean(x)), 0.85*max(nStartPoint), ...
     ['Mean starting point = ' num2str(meanStartPoint)])
text(0.5*(max(x)+mean(x)), 0.8*max(nStartPoint), ...
     ['SD starting point = ' num2str(stdStartPoint)])


%% Plot 6: path density

max_steps = stepVector(end);
N_BIN_Y = min(512, max_steps);
density = zeros(max_steps, N_BIN_Y);

for i = 1 : length(stateMatrix)
    % Extract the state, cut off the last value (it is out of bounds)
    state = stateMatrix{i}(1:end-1);

    % normalize state
    state = (state - LOWER_BOUND) ./ UPPER_BOUND;

    % convert to indices
    state = round(state * N_BIN_Y);

    state(state < 1) = 1;
    state(state > N_BIN_Y) = N_BIN_Y;

    for j = 1 : length(state)
        density(j, state(j)) = density(j, state(j)) + 1;
    end
end

figure(6)
imagesc(log(density)')
title('Log density')
