function margin = computeCountMargin(t, Mu, L)
pois = @(dL,dMu) (dMu^dL*exp(-dMu))/factorial(dL);
margin = 1;
for j = 2:numel(t)
    dMu = Mu(t(j)) - Mu(t(j-1));
    dL = L(j)-L(j-1);
    margin = margin * pois(dL,dMu);
end
end