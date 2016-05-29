% Nima Ghorbani
% https://github.com/nimagh/NIP_SS16
% Neural Coding - Excercise 2
% goal: Generation of inhomogeneous Poisson random processes
clear all; clc; close all;
set(0,'DefaultFigureWindowStyle','docked')

T = 1;
Lmax = 100; %Hz
Lamt = @(t) Lmax .* t .* (1-t);
temporalDist = @(t) 3*t.^2 - 2*t.^3;

mu = @(t) Lmax * ((.5*t^2 - (1/3)*t^3));
muinv = @(t) fzero( @(x)(mu(x)-t), 0.5);

numTrains = 100;
 
% Task 3
%% 3.a Temporal Distribution Method
figure(101); hold on;
Ks = poissrnd(50/3,1,numTrains);% drawing spike counts k
meanFR = zeros(100,1);
for sample = 1:numTrains % generating 100 spike trains
    k = Ks(sample);
    spikeTrain = zeros(1,k);
    for spikeIdx = 1:k
        % since temporal distribution is not invertible, using Lahirs's Method
        % William G. Cochran; Sampling Techniques, 3rd Edition
        x = rand;
        if rand <= Lamt(x);
            spikeTrain(spikeIdx) = x;
        end
    end
    meanFR(sample) = length(find(spikeTrain>0));
    spikeTrain = sort(spikeTrain);
    line([spikeTrain;spikeTrain],[sample*0.1;sample*0.1+.08]*ones(size(spikeTrain)),'Color','k');
end
title(sprintf('Task 3.a Temporal Distribution Method - MFR = %2.2f',mean(meanFR)));
xlabel('Time - [s]');ylabel('Spike Trains');
xlim([0,1]);ylim([0,10]);
%% 3.b Bernoulli Method I
ms = [10,100,1000];
for Idx= 1:length(ms)
    figure(101+Idx);hold on;
    meanFR = zeros(100,1);
    for sample = 1:100
        m = ms(Idx);
        randnums = rand(2,m);
        spikeTrain = zeros(1,m);
        for i=1/m:1/m:1
            spikeIdx = int32(i*m);
            t1 = i-1/m; t2 = i;
            lambda = Lmax * ((.5*t2^2 - (1/3)*t2^3)-(.5*t1^2 - (1/3)*t1^3));
            kj = poissrnd(lambda);
            if kj >= 1;
                spikeTrain(spikeIdx) = t1+randnums(2,spikeIdx)*(t2-t1);
            end;
        end
        spikeTrain(spikeTrain==0)=[];
        meanFR(sample) = length(find(spikeTrain>0));

        line([spikeTrain;spikeTrain],[sample*0.1;sample*0.1+.08]*ones(size(spikeTrain)),'Color','k');

    end
    title(sprintf('Task 3.b Bernoulli Method I - MFR = %2.2f',mean(meanFR)));
    xlabel('Time - [s]');ylabel('Spike Trains');
    xlim([0,1]);ylim([0,10]);
end
%% 3.c Bernoulli Method II
ms = [10,100,1000];
for Idx= 1:length(ms)
    figure(104+Idx);hold on;
    meanFR = zeros(100,1);
    for sample = 1:100
        m = ms(Idx);
        spikeTrain = zeros(1,m);
        for i=1/m:1/m:1
            spikeIdx = int32(i*m);
            t1 = i-1/m; t2 = i;
            lambda = Lmax * ((.5*t2^2 - (1/3)*t2^3)-(.5*t1^2 - (1/3)*t1^3));
            kj = poissrnd(lambda);
            if kj >= 1;
                spikeTrain(spikeIdx) = t1+1/(2*m);%seting spike to the middle of the bin
            end;
        end
        spikeTrain(spikeTrain==0)=[];
        meanFR(sample) = length(find(spikeTrain>0));
        line([spikeTrain;spikeTrain],[sample*0.1;sample*0.1+.08]*ones(size(spikeTrain)),'Color','k');
    end
    title(sprintf('Task 3.b Bernoulli Method II - MFR = %2.2f',mean(meanFR)));
    xlabel('Time - [s]');ylabel('Spike Trains');
    xlim([0,1]);ylim([0,10]);
end
%% 3.d Thining Method
figure(108);hold on;
meanFR = zeros(100,1);
for sample = 1:100
    spikeTrain = exprnd(1/Lmax,[1,2*T*Lmax]);
    spikeTrain = cumsum(spikeTrain);
    spikeTrain(spikeTrain>1)=[];
    newTrain = zeros(size(spikeTrain));
    for Idx = 1:length(spikeTrain)
        rejectProb = 1 - (Lamt(spikeTrain(Idx))/Lmax);
        if ~(rejectProb>rand);newTrain(Idx)=spikeTrain(Idx);end
    end
    spikeTrain=newTrain(newTrain~=0);
    meanFR(sample) = length(find(spikeTrain>0));
    line([spikeTrain;spikeTrain],[sample*0.1;sample*0.1+.08]*ones(size(spikeTrain)),'Color','k');
end
title(sprintf('Task 3.d Thining Method - MFR = %2.2f',mean(meanFR)));
xlabel('Time - [s]');ylabel('Spike Trains');
xlim([0,1]);ylim([0,10]);
%% 3.e part 1 - Renewal & Rescaling Method
figure(109);hold on;

meanFR = zeros(100,1);
for sample = 1:100
    
    spikeTrain = exprnd(1,[1,2*T*Lmax]);%exponential rnd with rate 1
    spikeTrain = cumsum(spikeTrain);
    spikeTrain(spikeTrain>16.66)=[];% interval [0,u(t)]
    

    spikeTrain = arrayfun(muinv,spikeTrain);
    meanFR(sample) = length(find(spikeTrain>0));
    line([spikeTrain;spikeTrain],[sample*0.1;sample*0.1+.08]*ones(size(spikeTrain)),'Color','k');
end
title(sprintf('Task 3.e-1 Renewal & Rescaling Method - MFR = %2.2f',mean(meanFR)));
xlabel('Time - [s]');ylabel('Spike Trains');
xlim([0,1]);ylim([0,10]);

%% 3.e part 2 - Renewal & Rescaling Method
figure(110);hold on;
rndNumbers = rand([100,100]);
meanFR = zeros(100,1);
for sample = 1:100
    
    spikeTrain = rndNumbers(sample,:)*2;%interspike interval from U(0,2)
    
    spikeTrain = cumsum(spikeTrain);
    spikeTrain(spikeTrain>50/3)=[];% interval [0,u(t)]

    spikeTrain = arrayfun(muinv,spikeTrain);
    meanFR(sample) = length(find(spikeTrain>0));
    line([spikeTrain;spikeTrain],[sample*0.1;sample*0.1+.08]*ones(size(spikeTrain)),'Color','k');
end
title(sprintf('Task 3.e-2 Renewal & Rescaling Method - MFR = %2.2f',mean(meanFR)));
xlabel('Time - [s]');ylabel('Spike Trains');
xlim([0,1]);ylim([0,10]);


