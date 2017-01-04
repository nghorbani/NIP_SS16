function K = get_kernel(x1,x2,sigmaf,l,sigman)
k = @(x1,x2,sigmaf,l,sigman) (sigmaf^2)*exp(-(1/(2*l^2))*(x1-x2)^2) + (sigman^2);
K = zeros(numel(x1),numel(x2));
for i = 1:numel(x1)
    for j = 1:numel(x2)
        if i==j;K(i,j) = k(x1(i),x2(j),sigmaf,l,sigman);
        else;K(i,j) = k(x1(i),x2(j),sigmaf,l,0);end
    end
end