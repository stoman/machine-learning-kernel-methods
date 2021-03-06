%This function computes a decomposition of the Gram matrix according to the
%Nystr�m method. Arguments are the training data X, the kernel function K
%and the sample size. The sample size should be a constant multiple of the
%rank of the Gram matrix. The fourth boolean argument debug is optional and
%can enable debug messages regarding the quality of the estimation. Its
%default value is false. Enabling this option makes this function compute
%the actual Gram matrix which is very costly. Without the debug flag the
%full Gram matrix will never be computed. The Gram matrix is approximated
%by F*F'. The sampling is done by taking the first rows of X. Therefore,
%you need to shuffle it before giving it to this function. This function
%dies not shuffle the data since the labels need to be adjusted
%accordingly
%Author: Stefan Toman (toman@tum.de)
function F = createnystrom(X, K, samplesize, debug)
    %set debug variable
    if nargin < 4
        debug = false;
    end

    %select submatrices
    X1 = X(1:samplesize,:);
    X2 = X(samplesize+1:end,:);
    K11 = pdist2(X1, X1, K);
    K12 = pdist2(X1, X2, K);

    %The rank of the Gram matrix can be computed like this. Note that this
    %computation is not possible in general due to the size of the Gram
    %matrix.
    if debug
        fprintf('rank of the Gram matrix: %d (%d points sampled)\n', rank(pdist2([X1; X2], [X1; X2], K)), samplesize);
    end

    %compute the eigendecomposition of pinv(K11)
    [V,D] = eig(pinv(K11));
    M = V*(D.^(1/2))*inv(V);
    
    %compute the deomposition matrices
    F = [K11; K12']*M;

    %estimate the error
    if debug
        K22 = pdist2(X2, X2, K);
        error = norm(K22 - K12'*pinv(K11)*K12);
        fprintf('norm of the error at K22: %d, relative error: %d\n', error, error/norm(K22));
    end
end