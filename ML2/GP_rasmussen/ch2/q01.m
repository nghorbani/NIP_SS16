% Goal: exccercise 1.ch2 Rasmussen
% replication of figure 2.2
close all;clear;clc
figure(101); 

sigmaf = 1; l = 1; sigman = 0; % parameters

x_train = [-5:0.1:5]';
K = get_kernel(x_train, x_train, sigmaf, l, sigman); 
%% sampling random functions
% using the hint in appendix A

K = make_PD(K);%for numerical stability
L = chol(K,'lower');
for i=1:3
    z = L*randn([size(x_train,1),1]);
    subplot(121);plot(x_train,z,'k--');hold on;
end
subplot(121);shadedErrorBar(x_train,zeros(size(x_train)),2*sqrt(diag(K)),':k',1);
xlim([-5,5]);ylim([-2.5,2.5]);
title('prior');xlabel('x');ylabel('y');

%% sampling functions that go through our training points
% before we didnt have any target points (y_train) for our x_train 
x_train = [-4.0438   -2.2696   -1.2327   -0.2419    2.1774]';
y_train = [-1.4461    0.3732    0.6414    1.1079   -0.4665]';

x_test = [-5:0.1:5]';%predict at this points

% computing the kernels to form the prior
K = get_kernel(x_train, x_train, sigmaf, l, sigman);
K_s = get_kernel(x_test, x_train, sigmaf, l, 0);
K_ss = get_kernel(x_test, x_test, sigmaf, l, sigman);

y_test_mean = K_s*(K\y_train);% best prediction
y_test_var = K_ss - K_s*(K\K_s');% uncertainty

y_test_var = make_PD(y_test_var);%for numerical stability

L = chol(y_test_var,'lower');
for i=1:3
    u = randn([size(y_test_mean,1),1]);% sampling functions that go through our training points
    z = y_test_mean + L*u;
    subplot(122);plot(x_test,z,'r-');hold on;
end

subplot(122);shadedErrorBar(x_test,y_test_mean,2*sqrt(diag(y_test_var)),'k',1);hold on;

subplot(122);plot(x_train,y_train,'rO');
title('posterior');
xlim([-5,5]);ylim([-2.5,2.5]);
xlabel('x');
suptitle('Chapter 2. Excercise 1');

function K = get_kernel(X1,X2,sigmaf,l,sigman)
k = @(x1,x2,sigmaf,l,sigman) (sigmaf^2)*exp(-(1/(2*l^2))*(x1-x2)*(x1-x2)') + (sigman^2);
K = zeros(size(X1,1),size(X2,1));
for i = 1:size(X1,1)
    for j = 1:size(X2,1)
        if i==j;K(i,j) = k(X1(i,:),X2(j,:),sigmaf,l,sigman);
        else;K(i,j) = k(X1(i,:),X2(j,:),sigmaf,l,0);end
    end
end
end
%% we can also sample from multivariate gaussian with matlab mvnrnd
% figure; hold on;
%for i=1:1000
%z = mvnrnd(zeros(1,numel(x)),K);
% plot(x,z,'r-');
% end