% Nima Ghorbani
% Neural Coding - Excercise 1
% goal: Spike trains as random processes
clear all; clc; close all;
T = 10; %s total time interval
tavs = [1 0.1 0.01];


% %% Task 5.a
% spikeTrains = zeros(20,length(tavs));
% for tavIdx = 1:length(tavs)
%     tav=tavs(tavIdx);
%     t=exprnd(tav);
%     spikeIdx = 0;
%     while 1
%         spikeIdx = spikeIdx + 1;
%         if t>T; break; end;
%         spikeTrains(spikeIdx,tavIdx) = t;
%         t = t + exp(tav);
%     end
% end 
% figure(100);
% for tavIdx = 1:length(tavs)
%     spikeTrain = spikeTrains(:,tavIdx)';
%     spikeTrain(spikeTrain==0)=[];
%     subplot(310+tavIdx);
%    % plot(spikeTrain,ones(1,length(spikeTrain)),'.'); 
%     line([spikeTrain;spikeTrain],[0;.5]*ones(size(spikeTrain)),'Color','k');
%     legend(sprintf('\\tau = %2.2f sec',tavs(tavIdx)))
%     xlim([0,T]);ylim([0,1]);
% 
% end
% suptitle('Task 5.a')

%% Task 5.b
numSpikeTrains = 100000;
spikeCounts = zeros(numSpikeTrains,1,length(tavs));
spikeTrains = zeros(numSpikeTrains,20,length(tavs));
for tavIdx = 1:length(tavs)
    tav=tavs(tavIdx);
    t=exprnd(tav);
    spikeIdx = 0;
    for spikeTrainIdx=1:numSpikeTrains
        while 1
            spikeIdx = spikeIdx + 1;
            if t>T; break; end;
            spikeTrains(spikeTrainIdx,spikeIdx,tavIdx) = t;
            t = t + exp(tav);
        end
       spikeCounts(spikeTrainIdx,1,tavIdx) = length(find(spikeTrains(spikeTrainIdx,:,tavIdx)));

    end
end 
% figure(100);
% for tavIdx = 1:length(tavs)
%     spikeTrain = spikeTrains(:,tavIdx)';
%     spikeTrain(spikeTrain==0)=[];
%     subplot(310+tavIdx);
%    % plot(spikeTrain,ones(1,length(spikeTrain)),'.'); 
%     line([spikeTrain;spikeTrain],[0;.5]*ones(size(spikeTrain)),'Color','k');
%     legend(sprintf('\\tau = %2.2f sec',tavs(tavIdx)))
%     xlim([0,T]);ylim([0,1]);
% 
% end
% suptitle('Task 5.a')