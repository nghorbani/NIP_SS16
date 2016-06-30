function [dprimes, lambdas] = SDTboot(pH,pFA,nsignal_tirals,nnoise_trials,nExperiments)
    dprimes = zeros(1,nExperiments);
    lambdas = zeros(1,nExperiments);

    for i = 1:nExperiments
        [nHit, nFA, nMiss, nCR] = simYesNo(pH,pFA,nsignal_tirals,nnoise_trials);
        [dprimes(i), lambdas(i)] = SDT(nHit, nFA, nMiss, nCR);
    end
end