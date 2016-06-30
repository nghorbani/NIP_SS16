function dPrimeVariability
observers=[0.81, 0.19; 0.96 ,0.50; 0.50, 0.04; 0.77, 0.23; 0.96, 0.42];
nTrials = [100,1000,10000];
for obsIdx = 1:5
    pH = observers(obsIdx,1);
    pFA = observers(obsIdx,2);
    for trialIdx = 1:3
        nTiral = nTrials(trialIdx);
        [dprimes, lambdas] = SDTboot(pH,pFA,nTiral,nTiral,1000);
        dp95 = prctile(dprimes,92);dp25 = prctile(dprimes,25);
        lamp95 = prctile(lambdas,92);lamp25 = prctile(lambdas,25);

        d_CI = dp95 - dp25;
        lam_CI = lamp95 - lamp25;
        
        display(sprintf('%d - nTrials = %d, d_CI = %2.2f, <d">=%2.2f', obsIdx, nTiral, d_CI, mean(dprimes)));
    end
end