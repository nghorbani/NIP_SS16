% Goal: 1d gaussian process
close all; clear;clc

corel_coef = -50;
k = @(x,y) exp(-1*(x-y)'*(x-y)); % correlation of each point with every other points

x = linspace(-1,1,500); 
n = length(x); 

% covariance matrix
C = zeros(n,n);
for i = 1:n 
    for j = 1:n 
        C(i,j) = k(x(i),x(j));
    end
end

figure(100); hold on; 
z = mvnrnd(zeros(1,n),C);
plot(x,z,'r.-');