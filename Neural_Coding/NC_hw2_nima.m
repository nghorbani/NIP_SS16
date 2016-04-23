% Nima Ghorbani
% https://github.com/nimagh/NIP_SS16
% Neural Coding - Excercise 2
% goal: coefficient of variance of gamma dist. and fano factor of n. binomial
clear all; clc; close all;

%%
% task 4 coefficient of variance of gamma ditribution
% Cv = sqrt(vr)/mean
figure(101);
lambdas = 0.1:0.1:100;
Cvs = zeros(1,length(lambdas));
for i=1:length(lambdas)
    lambda = lambdas(i);
    a = lambda; b = lambda;
    g_mean = a/b; g_var = sqrt(a/(b*b));
    Cvs(1,i) = sqrt(g_var)/g_mean;
end
plot(lambdas,Cvs);
title('task 2. coefficient of variance of gamma ditribution');
xlabel('lambda = a = b');ylabel('Cv');

%%
figure(102);
% task 5 fano factor of negative binomial 
lambdas = 0.01:0.01:1;
Fs = zeros(1,length(lambdas));
for i=1:length(lambdas)
    lambda = lambdas(i);
    a = lambda; b = lambda;
    g_mean = (a*b)/(1-b); g_var = (a*b)/((1-b)^2);
    Fs(1,i) = g_var/g_mean;
end
plot(lambdas,Fs);
title('task 5. fano factor of negative binomial ');
xlabel('lambda = a = b');ylabel('F');