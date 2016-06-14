% Nima ghorbani
% Neural Coding - HW5
close all; clear all; clc

ns = [1,10,100];
lams = 0:0.1:1;
a0=1;b0=1;

%% Risk
% Analytical Risk
figure(101);
for figIdx=1:3
    n = ns(figIdx);
    rMS = ((n.*lams.*(1-lams)+(1-2*lams).^2))./(n+2).^2;
    rML = (1/n).*lams.*(1-lams);

    subplot(230+figIdx);hold on;
    plot(lams,rML,'r');plot(lams,rMS,'b');
    if figIdx == 1;ylabel(sprintf('Analytical \nRisk'));end
    legend('r_{ML}','r_{MS}');
    title(['n = ' num2str(n) ]);
end

% Emperical Risk 
nTrials = 1000;
        
meanrML = zeros(1,numel(ns));
meanrMS = zeros(1,numel(ns));
meanrMM = zeros(1,numel(ns));
    
for nIdx = 1:numel(ns)
    n = ns(nIdx);
    rML = zeros(1,numel(lams));
    rMS = zeros(1,numel(lams));
    rMM = zeros(1,numel(lams));
    for lamIdx = 1:numel(lams)
        trueLam = lams(lamIdx);
        squaredErrorML = zeros(1,nTrials);
        squaredErrorMS = zeros(1,nTrials);
        squaredErrorMM = zeros(1,nTrials);
        for trialIdx = 1:nTrials
            k = binornd(n,trueLam);
            lamML = k/n;
            squaredErrorML(trialIdx) = (lamML-trueLam)^2;
            
            lamMS = (k+a0)/(a0+b0+n);
            squaredErrorMS(trialIdx) = (lamMS-trueLam)^2;
            
            lamMM = (k+0.5*sqrt(n)) / (n+sqrt(n));
            squaredErrorMM(trialIdx) = (lamMM-trueLam)^2;
        end
        rML(lamIdx) = mean(squaredErrorML);
        rMS(lamIdx) = mean(squaredErrorMS);
        rMM(lamIdx) = mean(squaredErrorMM);
    end
    subplot(233+nIdx); hold on;
    plot(lams,rML);plot(lams,rMS);plot(lams,rMM)

    xlabel('\lambda');
    legend('r_{ML}','r_{MS}','r_{MM}');
    meanrML(nIdx) = mean(rML);
    meanrMS(nIdx) = mean(rMS);
    meanrMM(nIdx) = mean(rMM);
end
subplot(234);ylabel(sprintf('Emperical \nRisk'));
suptitle('Estimators Risk Comparison');
%% Average Risk
% Analytical
figure(102);

ns = 1:100;

ErML = zeros(1,numel(ns));
ErMS = zeros(1,numel(ns));

for n = ns
    ErMS(n) = (n/6 + 1/3)/(n + 2)^2;
    ErML(n) = (1/(6*n));
end
subplot(211);hold on;
plot(ns,ErML,'r');plot(ns,ErMS,'b');
ylabel(sprintf('Analytical \n<Risk>'));
legend('<r_{ML}>','<r_{MS}>');

% Emperical
subplot(212);hold on;
plot([1,10,100],meanrML);
plot([1,10,100],meanrMS);
plot([1,10,100],meanrMM);
legend('<r_{ML}>','<r_{MS}>','<r_{MM}>');
xlabel('n');
ylabel(sprintf('Emperical \n<Risk>'));
suptitle('Estimators Average Risk Comparison');
