% Goal: 2-dimentional gaussian process demonstration
corel_coef = -50;
k = @(x,y) exp(corel_coef*(x-y)'*(x-y)); % correlation of each point with every other points

pts = linspace(0,1,40)'; 
[U,V] = meshgrid(pts,pts);
x = [reshape(U,[numel(U),1]) reshape(V,[numel(V),1])]';
n = numel(U); 

% covariance matrix
C = zeros(n,n);
for i = 1:n 
    for j = 1:n 
        C(i,j) = k(x(:,i),x(:,j));
    end
end

z = real(sqrtm(C))*randn(n,1);

figure(204); hold on; 
Z = reshape(z,sqrt(n),sqrt(n));
surf(U,V,Z)