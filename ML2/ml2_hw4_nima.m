% Nima Ghorbani
% Machine Learing 2 - HW 4
% Goal: sampling from a cauchy distribution
clear all; clc; close all;
rng(100);

nsamples = 1000;

invCauchyCDF = @(x) tan(pi*(x-0.5));
CauchyCDF = @(y) (1/pi)*atan(y) + 0.5;
CauchyPDF = @(y) (1/pi)*(1./(1+y.^2));

%% Rejection sampling on the interval -20 and 20
figure(100);
subplot(131);hold on;title('Rejection Sampling');
samples = zeros(1,nsamples);
sIdx = 1;
while sIdx < nsamples
    x_current = -20 + 40*rand;
    if (rand/pi) <= CauchyPDF(x_current)
        samples(sIdx) = x_current;
        sIdx = sIdx + 1;
    end
end
[bincounts,bincenters] = hist(samples,50);
bincounts = bincounts/sum(bincounts);
bar(bincenters,bincounts,1,'r');
plot(-20:0.1:20,CauchyPDF(-20:0.1:20),'k--');% theoretical
xlim([-20,20]);
%% Inverse CDF sampling
subplot(132);hold on;title('Inverse CDF Sampling');
samples = rand(1,nsamples);
samples = arrayfun(invCauchyCDF,samples);

[bincounts,bincenters] = hist(samples,nsamples*2);
bincounts = bincounts/sum(bincounts);
bar(bincenters,bincounts,1,'b');

plot(-20:0.1:20,CauchyPDF(-20:0.1:20),'k--');% theoretical
xlim([-20,20]);
%% Metropolis-Hastings Sampler
subplot(133);hold on;title('MCMC MH Sampler')
q = @(x) (1/sqrt(2*pi))*exp(-0.5*x^2); % proposal distribution
%q = @(x) normpdf(x,0,1)
x_current = 0;
sIdx = 1;
while sIdx < nsamples
    x_cand = normrnd(x_current,1); % normal centered around current x
    alpha = q(x_cand)/q(x_current);% acceptnce ratio
    if alpha >= 1
       samples(sIdx) = x_cand;
       x_current = x_cand;
       sIdx = sIdx + 1
    else
        u = rand;
        if u < alpha
           samples(sIdx) = x_cand;
           x_current = x_cand;
           sIdx = sIdx + 1          
        end
    end
end
[bincounts,bincenters] = hist(samples,10);
bincounts = bincounts/sum(bincounts);
bar(bincenters,bincounts,1,'r');
plot(-20:0.1:20,CauchyPDF(-20:0.1:20),'k--');% theoretical
xlim([-20,20]);

