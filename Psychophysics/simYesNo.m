function [nHit, nFA, nMiss, nCR] = simYesNo(pH,pFA,nsignal_tirals,nnoise_trials)
nHit = binornd(nsignal_tirals, pH);
nFA = binornd(nnoise_trials, pFA);

nMiss = nsignal_tirals - nHit;%(nHit/pH) - nHit;
nCR = nnoise_trials - nFA;%(nFA/pFA) - nFA;
end