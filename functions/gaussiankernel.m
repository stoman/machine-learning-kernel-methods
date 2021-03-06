%This function returns a function handle for a Gaussian kernel using a
%given parameter gamma. The argument nrinputs is optional and defaults to
%2. If nrinputs is 1 the function will take one argument, if nrinputs is 2
%it will take two arguments and call the function for one argument with the
%difference of the arguments. The argument nonormalization is also optional
%and defaults to false. If it is true then the factor (2*pi)^(-size(x,2)/2)
%is ignored.
% Author: Stefan Toman (toman@tum.de)
function K = gaussiankernel(gamma, nrinputs, nonormalization)
    %optional arguments
    if nargin < 2
        nrinputs = 2;
    end
    if nargin < 3
        nonormalization = false;
    end
    
    %create function
    if nrinputs == 1 && nonormalization
        K = @(x) exp(-gamma/2.*sum(x.^2,2));
    elseif nrinputs == 1
        K1 = gaussiankernel(gamma, 1, true);
        K = @(x) (2*pi)^(-size(x,2)/2)*K1(x);
    elseif nrinputs == 2
        K1 = gaussiankernel(gamma, 1, nonormalization);
        K = @(x,z) K1(bsxfun(@minus, x, z));
    else
        error('parameter nrinputs should be 1 or 2');
    end
end
