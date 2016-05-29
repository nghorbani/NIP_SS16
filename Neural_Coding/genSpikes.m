function spikeTrains = genSpikes(Lambda,numTrains,method)
if nargin<3; method = 'TemporalDistribution';end;
spikeTrains = cell(numTrains,1);
if strcmp(method,'TemporalDistribution')
    Ks = poissrnd(Lambda(1),1,numTrains);% drawing spike counts k
    for nTrain = 1:numTrains % generating 100 spike trains
        k = Ks(nTrain);
        spikeTrain = zeros(1,k);
        for spikeIdx = 1:k
            % using Lahirs's Method for sampling
            t = rand;
            if rand <= Lambda(t);
                spikeTrain(spikeIdx) = t;
            end
        end
        spikeTrains{nTrain} = sort(spikeTrain);  
    end
end
end
