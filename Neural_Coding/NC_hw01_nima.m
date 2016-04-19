% Nima Ghorbani
% Neural Coding - Excercise 1
% goal: Spike trains as random processes
clear all; clc; close all;
T = 10; %s total time interval
tavs = [1 0.1 0.01];
lambdas = [0.1 0.01 0.001];


%% Task 5.a
figure(100);
for Idx = 1:length(tavs)
    tav=tavs(Idx);
    spikeTrain = exprnd(tav,[1,2*T/tav]);
    spikeTrain = cumsum(spikeTrain);
    spikeTrain(spikeTrain>10)=[];
    
    subplot(310+Idx);
    line([spikeTrain;spikeTrain],[0;.5]*ones(size(spikeTrain)),'Color','k');
    legend(sprintf('\\tau = %2.2f sec',tavs(Idx)))
    xlim([0,T]);ylim([0,1]);
end 
suptitle('Task 5.a')

%% Task 5.b
numSpikeTrains = 100000;
spikeCounts = zeros(numSpikeTrains,1,length(tavs));
for Idx = 1:length(tavs)
    tav=tavs(Idx);
    for spikeTrainIdx=1:numSpikeTrains
        spikeTrain = exprnd(tav,[1,2*T/tav]);
        spikeTrain = cumsum(spikeTrain);
        spikeTrain(spikeTrain>10)=[];
        spikeCounts(spikeTrainIdx,1,Idx) = nnz(spikeTrain);
    end
end 
figure(101);
for Idx = 1:length(tavs)
    subplot(310+Idx);
    hist(spikeCounts(:,1,Idx));
    legend(sprintf('\\tau = %2.2f sec',tavs(Idx)))

end
suptitle('Task 5.b')

%% Task 5.c
numSamples = 10000;

figure(102);
for Idx = 1:length(lambdas)
    lambda=lambdas(Idx);
    
    spikeTrain = binornd(1,lambda,1,numSamples);

    spikeTrain = spikeTrain.*linspace(0,T,numSamples);
    spikeTrain = spikeTrain(spikeTrain>0);
    subplot(310+Idx);
    line([spikeTrain;spikeTrain],[0;.5]*ones(size(spikeTrain)),'Color','k');
    legend(sprintf('\\lambda = %2.3f sec',lambdas(Idx)))
    xlim([0,T]);ylim([0,1]);

end
suptitle('Task 5.c')

%% Task 5.d
numSamples = 10000;
numSpikeTrains = 100000;

spikeCounts = zeros(numSpikeTrains,1,length(tavs));
for Idx = 1:length(lambdas)
    lambda=lambdas(Idx);
    for spikeTrainIdx=1:numSpikeTrains
        spikeTrain = binornd(1,lambda,1,numSamples);
        spikeCounts(spikeTrainIdx,1,Idx) = nnz(spikeTrain);
    end
end 
figure(103);
for Idx = 1:length(tavs)
    subplot(310+Idx);
    hist(spikeCounts(:,1,Idx));
    legend(sprintf('\\lambda = %2.3f sec',lambdas(Idx)))
end

suptitle('Task 5.d')