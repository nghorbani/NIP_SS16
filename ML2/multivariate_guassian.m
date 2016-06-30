clc; close all;
X2 = @(x1) (abs(x1)<=1)*x1 + (abs(x1)>1)*-1*x1;
x1 = randn(1,1000);
plot(x1,zeros(1,1000),'r.');hold on;
x2 = arrayfun(@(x) X2(x),x1);
plot(x2, x1,'b.')
plot(zeros(1,1000),x2,'y.')
[x1_counts, x1_bins] = hist(x1);
bar(x1_bins,x1_counts/diff(x1_bins(1:2))/1000,1)
[x2_counts, x2_bins] = hist(x2);
barh(x2_bins, x2_counts/diff(x2_bins(1:2))/1000,1)