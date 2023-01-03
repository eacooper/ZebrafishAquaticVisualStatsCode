function entropy_bits = entropy_from_histogram(input_histogram,bin_width)
% COMPUTE_ENTROPY measures entropy of an input distribution array in bits.
% The input should be a vector that is the probability density function of
% the random variable of interest (e.g., intensity, contrast, power, speed)
%
% Entropy is often used to measure two things regarding a system: 
% - (1) the amount of input information; 
% - (2) the amount of output information after transmission via the system. 
% Regarding the comparison between terrestrial and aquatic environmental 
% visual statistics, we refer to the first meaning of entropy. 
% 
% For a given random variable that describe visual regularities 
% (e.g., light intensity, contrast, power, or speed), the entropy is 
% defined as
%    H(X) = - \sum_{i} P_{X}(x_{i}) .* log_{b} [ P_{X}(x_{i}) ]
%         = \sum_{i} P_{X}(x_{i}) .* I_{X}(x_{i})
%         = E[I_{X}],
% where X is the random variable, P_{X} is the pdf, x_{i} is the i-th 
% outcome, and I_{X}(x_{i}) is the amount of information carried by 
% the i-th outcome. E[I_{X}] is the expectation of I_{X}. The logarithmic 
% base b depends on the desired unit. Here we measure entropy in bits and 
% set b = 2.
%
% This function takes a histogram as input (along with the bin widths), and use
% the method described here for a discrete entropy calculation:
%
% A note on the calculation of entropy from histograms
% Kenneth F. Wallis 
%
% Analyzing bin-width effect on the computed entropy
% Sri Purwani, Julita Nahar, and Carole Twining
%
% -lanya 4/17/2020

% check that bin widths are not too small, which leads to instability (see Purwani et al)
if bin_width < 0.1
    error('histogram bins too small for reliable entropy calculation');
end
    
% convert histogram values to pdfs
input_pdf = input_histogram/sum(input_histogram);

% Compute value at each bin
%bin_val = (input_pdf .* log2(input_pdf)) + log2(bin_width);
bin_val = (input_pdf .* log2(input_pdf./bin_width));

% Make sure values = 0 for events with 0 probability
bin_val(input_pdf == 0) = 0;

% Compute H(X)
entropy_bits = -sum(bin_val);

% confirmation using gaussian (exact and approx should be the similar):
%
% sigma = 5;
% bin_width = 0.1;
% 
% exact = log2(sigma*sqrt(2*pi*exp(1)))
% 
% x = histcounts(randn(1,1000)*sigma,-50:bin_width:50);
% 
% approx = compute_entropy_from_histogram(x,bin_width)

% Lanya's original calculation

% Compute I_{X}(x_{i}
% information_pdf = - log2(input_pdf);

% Compute H(X)
% entropy_bits = sum(input_pdf .* information_pdf);





