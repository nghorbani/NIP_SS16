% Goal: exccercise 1.ch2 Rasmussen
% replication of figure 2.2
close all;clear;clc

sigmaf = 1; l = 1; sigman = 0; % parameters

x = -5:0.1:5;
K = get_kernel(x, x, sigmaf, l, sigman); 

figure(101); 

%% using matlab mvnrnd
% figure; hold on;
%for i=1:1000
%z = mvnrnd(zeros(1,numel(x)),K);
% plot(x,z,'r-');
% end
%% using the hint in the appendix A
K = make_PD(K);%for numerical stability
L = chol(K,'lower');
for i=1:3
    z = L*randn([numel(x),1]);
    subplot(121);plot(x,z,'k--');hold on;
end
subplot(121);shadedErrorBar(x,zeros(size(x)),2*sqrt(diag(K)),':k',1);
xlim([-5,5]);ylim([-2.5,2.5]);
title('prior');xlabel('x');ylabel('y');
%%
x = [-4.0438   -2.2696   -1.2327   -0.2419    2.1774];
y = [-1.4461    0.3732    0.6414    1.1079   -0.4665];

x_predict = -5:0.1:5;

K = get_kernel(x, x, sigmaf, l, sigman);
K_s = get_kernel(x_predict, x, sigmaf, l, 0);
K_ss = get_kernel(x_predict, x_predict, sigmaf, l, sigman);

y_predict_mean = K_s*(K\y');
y_predict_var = K_ss - K_s*(K\K_s');

y_predict_var = make_PD(y_predict_var);%for numerical stability

L = chol(y_predict_var,'lower');
for i=1:3
    u = randn([numel(y_predict_mean),1]);
    z = y_predict_mean + L*u;
    subplot(122);plot(x_predict,z,'r-');hold on;
end

subplot(122);shadedErrorBar(x_predict,y_predict_mean,2*sqrt(diag(y_predict_var)),'k',1);hold on;

subplot(122);plot(x,y,'rO');
title('posterior');
xlim([-5,5]);ylim([-2.5,2.5]);
xlabel('x');
suptitle('Chapter 2. Excercise 1');
