function [ cdf_TF ] = cdf_TF_ftn_poisson_line( N, i, j, x )
%CDF_TF_FTN Returns the CDF of traffic factor for a line network
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           x = input to the cdf function - should be a vector

if abs(i-j) == 1
    cdf_TF = zeros(1,length(x));
else
%     mu_3 = (2*(ceil(N/2)-1)*ceil(N/2))/(N-1);
    mu_3 = (N-1)/2;
%     sigma_3 = sqrt(((2*(ceil(N/2)-1)*ceil(N/2))/(N-1))*(1-(1.0/(N-1))));
    cdf_TF = poisscdf(x, mu_3);
end

end

