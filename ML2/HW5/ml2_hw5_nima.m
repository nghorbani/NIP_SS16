clear all;clc; close all;
load('hw5_data.mat')
clc; close all;
M = 30; % using a 50 dimentional basis
N = length(Xtrain);

sigma_phis = [.1 1 10]; % width parameter

basis_fun = @(x,j,s_phi) exp(-(0.5*(x-j).^2)/(s_phi^2));
for alpha = [1, 10^-8]
    figure();i=0;
    for sigma_phi = sigma_phis
        i=i+1;subplot(2,2,i);
        ML_yPrediction = ML_linear_regression(Xtrain,Ytrain,Xtest,M,@(x,j) basis_fun(x,j,sigma_phi));
        [bayes_yPrediction, var_Prediction ]= bayes_linear_regression(Xtrain,Ytrain,Xtest,M,@(x,j) basis_fun(x,j,sigma_phi),alpha);
        plot(Xtest,Ytest,'g');hold on;
        plot(Xtest,ML_yPrediction,'r');
        errorbar(Xtest,bayes_yPrediction,var_Prediction,'m')
        xlim([0,7]);ylim([-3,3]);
        title(sprintf('\\sigma=%1.1f, \\alpha=%1.0e',sigma_phi,alpha));
        legend('original','MLE','bayes','Location','southwest')
    end
end
