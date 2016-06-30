function out = DiffusionModel(myDriftRate, myTimeScaler, myUpperBound, myStartPoint)

LOWER_BOUND = 0;

if nargin < 1, myDriftRate = 0.1; end
if nargin < 2, myTimeScaler = 0.001; end
if nargin < 3, myUpperBound = 1.0; end
if nargin < 4, myStartPoint = 0.5*(LOWER_BOUND + myUpperBound); end

state(1) = myStartPoint;
counter = 1;

% The diffusion process---in the limit---works in continuous time. To approximate
% the process we need a "nuisance" variable "varianceScaler" ensuring that the
% (mean) time to reach the bound is independent of the fine grained-ness of the
% samples: for very small time scales ("myTimeScaler" very small) each step and
% the probability of the step need to be small
varianceScaler = sqrt(myTimeScaler);
while (state(counter) > LOWER_BOUND && state(counter) < myUpperBound)
    % MATLAB's "randn" function generates samples from N(0,1). For the diffusion
    % model we need samples from N(myDriftRage*myTimeScaler, myTimeScaler*var). 
    diffusionStep =  myTimeScaler*myDriftRate + varianceScaler*randn(1,1);
    state(counter+1) = state(counter) + diffusionStep;
    counter = counter + 1;
end

% Now we need to decide whether the trial ended 
if state(end) > myUpperBound, correct = 1;
else correct = 0;
end

% Collect all the calculated and input values in a struct
time = counter*myTimeScaler;
out.correct = correct;
out.time = time;
out.steps = counter;
out.states = state;
out.driftRate = myDriftRate;
out.timeScale = myTimeScaler;
out.bounds = [LOWER_BOUND myUpperBound];
out.startPoint = myStartPoint;