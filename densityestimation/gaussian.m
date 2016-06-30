%In this file we sample N random points in d dimensions using a normal
%distribution. We then compute the error of the estimated density
%function in comparison to the real density function. Two estimators are
%used: a naive estimation and a Gaussian estimator. To get a relative error
%of 10% at 0 for the Gussian estimator we need approximately N=100 for d=1,
%N=300 for d=2, and N=500.000 for d=5.

%number of samples
N = 100;
%dimension
d = 2;

%sample data
X = randn(N, d);

%kernel function and h value
%naive estimator
Knaive = @(r) (sum(r.^2,2)<1)./2;
hnaive= 5e-1;

%gaussian
Kgauss = @(r) (2*pi)^(-d/2)*exp((-0.5).*sum(r.^2,2));
hgauss = (4/(d+2))^(1/(d+4))*N^(-1/(d+4));

%density functions
pnaive = @(z) 1/(N*hnaive^d)*sum(Knaive(bsxfun(@minus, z, X)./hnaive));
pgauss = @(z) 1/(N*hgauss^d)*sum(Kgauss(bsxfun(@minus, z, X)./hgauss));
p = Kgauss;

%compute deviation
zero = zeros(1, size(X,2));
fprintf('deviation at 0 of the naive estimator: %d\n', abs(pnaive(zero) - p(zero)) / p(zero));
fprintf('deviation at 0 of the Gaussian estimator: %d\n', abs(pgauss(zero) - p(zero)) / p(zero));

%plot densities if one-dimensional
if d == 1
    warning('off', 'MATLAB:fplot:NotVectorized');
    hold on;
    fplot(p);
    fplot(pnaive);
    fplot(pgauss);
    legend('actual density function', 'naive estimator', 'Gaussian estimator');
    hold off;
%plot densities if two-dimensional
elseif d == 2
    warning('off', 'MATLAB:fplot:NotVectorized');
    fsurf(subplot(1,3,1), @(x,y) p([x y])); title('actual density function');
    fsurf(subplot(1,3,2), @(x,y) pnaive([x y])); title('naive estimator');
    fsurf(subplot(1,3,3), @(x,y) pgauss([x y])); title('Gaussian estimator');
end
