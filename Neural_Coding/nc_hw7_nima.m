numL = 1000;
s = 5;
numN = 1000;

mutual_d1 = zeros(numL,numN);
mutual_d2 = zeros(numL,numN);
mutual_d3 = zeros(numL,numN);
mutual_d4 = zeros(numL,numN);

N = 1:numN;
for L = 1:numL
    mutual_d1(L,:) = (N./2).*log(1+s.^2./L);
    mutual_d2(L,:) = (1./2).*log(1+N.*s.^2./L);
    a = (N-N.^(2.*L-1))./(1-N.^2);
    b = (N.^(2.*L-1).*s.^2+1);
    mutual_d3(L,:) = 0.5.*log(N.*a./b+1).*b.^N - 0.5.*log(N.*a+1);
    a = ((N-N.^(2.*L-1))./(1-N.^2));
    c = N.^(2.*L-3).*s.^2;
    mutual_d4(L,:) = 0.5.*log(N.*(a+c)+1)-.5.*log(N.*a+1);
end
L = 1:numL;

figure(101);
subplot(221);surf(mutual_d1,'FaceColor','interp','FaceLighting','gouraud')
subplot(222);surf(mutual_d2)
subplot(223);surf(mutual_d3)
subplot(224);surf(mutual_d4)
