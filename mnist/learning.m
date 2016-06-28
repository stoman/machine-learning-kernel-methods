%load training data and test data (one object per row)
load('mnist_all.mat')
traina = double(train3);
trainb = double(train8);
testa = double(test3);
testb = double(test8);
a = -1;%value for the inputs in traina and testa
b = 1;%value for the inputs in trainb and testb

%visualize data like this
%surf(reshape(traina(1,:),[28 28]))
%imshow(reshape(traina(1,:),[28 28]))

%attach ones
traina = [traina ones(size(traina,1),1)];
trainb = [trainb ones(size(trainb,1),1)];
testa = [testa ones(size(testa,1),1)];
testb = [testb ones(size(testb,1),1)];

%compute x, y, and sample solution 
x = [traina; trainb];
y = [ones(size(traina,1),1)*a; ones(size(trainb,1),1)*b];
tx = [testa; testb];
ty = [ones(size(testa,1),1)*a; ones(size(testb,1),1)*b];

%shuffle training data
perm = randperm(size(x,1));
x = x(perm,:);
y = y(perm);
perm = randperm(size(tx,1));
tx = tx(perm,:);
ty = ty(perm);

%gradient descent (fminunc)
L = @(w) gradient(w, x, y);
w = fminunc(L, zeros(size(x,2),1), optimoptions('fminunc','Display','off','Algorithm','quasi-newton','SpecifyObjectiveGradient',true));
printResults(tx, ty, w, 'fminunc', a, b);

%manual gradient descent
w = zeros(size(x,2),1);
for i = 1:20
    w = w - 1e-7/size(x,1)*x'*(x*w-y);
end
printResults(tx, ty, w, 'manual gradient descent', a, b);

%solve (x'*x)*w = x'*y
w = pinv(x'*x)*(x'*y);
printResults(tx, ty, w, 'inverting x''*x', a, b);

%drop some training data to make the running time acceptable
maxsize = 1000;
if size(x,1) > maxsize
    x = x(1:maxsize,:);
    y = y(1:maxsize);
end

%solve (x*x')*c = y
c = pinv(x*x')*y;
w = x'*c;
printResults(tx, ty, w, sprintf('inverting x*x'', truncated to %d rows', maxsize), a, b);