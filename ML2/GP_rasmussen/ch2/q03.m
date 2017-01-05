% Goal: exccercise 3.ch2 Rasmussen
% Brownian bridge process
% For nearestPSD get it from https://goo.gl/pnj7Df
% For shadedErrorBar get it from https://goo.gl/TyQtJH

close all;clear;clc

sigmaf = 1; l = 1; sigman = 0; % parameters

x = -1:0.01:1;
K = get_kernel(x, x, sigmaf, l, sigman); 

figure(103); 

%K = make_PD(K);%for numerical stability
K = nearestSPD(K);

L = chol(K,'lower');
for i=1:3
    z = L*randn([numel(x),1]);
    subplot(121);plot(x,z,'k--');hold on;
end
subplot(121);shadedErrorBar(x,zeros(size(x)),2*sqrt(diag(K)),':k',1);
xlim([-1,1]);ylim([-2,2]);
title('prior');xlabel('x');ylabel('y');
%%
x = [-0.8871   -0.3387   -0.0530    0.3065    0.8088];
y = [-0.8309    0.3790    0.3061   -0.3499    0.6851];

x_predict = -1:0.01:1;

K = get_kernel(x, x, sigmaf, l, sigman);
K_s = get_kernel(x_predict, x, sigmaf, l, 0);
K_ss = get_kernel(x_predict, x_predict, sigmaf, l, sigman);

y_predict_mean = K_s*(K\y');
y_predict_var = K_ss - K_s*(K\K_s');

%y_predict_var = make_PD(y_predict_var);%for numerical stability
y_predict_var = nearestSPD(y_predict_var);

L = chol(y_predict_var,'lower');
for i=1:3
    u = randn([numel(y_predict_mean),1]);
    z = y_predict_mean + L*u;
    subplot(122);plot(x_predict,z,'r-');hold on;
end

subplot(122);shadedErrorBar(x_predict,y_predict_mean,2*sqrt(diag(y_predict_var)),'k',1);hold on;

subplot(122);plot(x,y,'rO');
title('posterior');
xlim([-1,1]);ylim([-2,2]);
xlabel('x');
suptitle(sprintf('Chapter 2. Excercise 3 \n Brownian bridge process'));

%%
function K = get_kernel(x1,x2,sigmaf,l,sigman)
% brownian bridge process
k = @(x1,x2,sigmaf,l,sigman) min(x1,x2)-x1*x2;
K = zeros(numel(x1),numel(x2));
for i = 1:numel(x1)
    for j = 1:numel(x2)
        if i==j;K(i,j) = k(x1(i),x2(j),sigmaf,l,sigman);
        else;K(i,j) = k(x1(i),x2(j),sigmaf,l,0);end
    end
end
end
