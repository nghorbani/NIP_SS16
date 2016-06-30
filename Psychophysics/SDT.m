function [dprime, lambda] = SDT(nHit, nFA, nMiss, nCR)

pH = nHit/(nHit + nMiss); %pM = 1 - pH;
pFA = nFA/(nFA+nCR); %pCR = 1 - pFA;

lambda = norminv(1-pFA,0,1);
%syms x; dprime = double(solve(norminv(1-pH,x,1) == lambda,x));
dprime = lambda - norminv(1 - pH, 0, 1);
end