function loglikelihood = computePoisLogLikelihood(spikeTrain, Mu, L)
loglikelihood = -Mu(1) + sum(arrayfun(@log, arrayfun(L, spikeTrain)));

end