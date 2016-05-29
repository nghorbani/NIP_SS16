function spikeCounts = countFun(time, spikeTimes)
if nargin<3;numTrains = 1;end;
spikeCounts = zeros(1,numel(time));
for tIdx = 1:numel(time)
    spikeCounts(tIdx) = length(find(spikeTimes<=time(tIdx)));
end

end