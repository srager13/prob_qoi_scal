function [ cdf_TF ] = cdf_TF_ftn_poisson_grid( N, i, j, x )
%CDF_TF_FTN Returns the CDF of traffic factor for a grid network
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           x = input to the cdf function - should be a vector

pl = abs(mod(i-1,sqrt(N))-mod(j-1,sqrt(N))) + abs(floor((i-1)/sqrt(N))-floor((j-1)/sqrt(N)));
if pl == 1
    cdf_TF = zeros(1, length(x));
else
    cdf_TF = poisscdf( x, 1.0*sqrt(N) );
end
