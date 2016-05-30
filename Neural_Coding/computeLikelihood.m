function likelihood = computeLikelihood(t, spikeTimes, Mu)
L = countFun(t, spikeTimes);

P = @(dL,dMu) ((dMu^dL)*exp(-dMu))/factorial(dL);
likelihood = 1;
for j = 2:numel(t)
    dMu = Mu(t(j)) - Mu(t(j-1));
    dL = L(j)-L(j-1);
    likelihood = likelihood * P(dL,dMu);
end
end