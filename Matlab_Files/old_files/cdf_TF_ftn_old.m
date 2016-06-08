function [ cdf_TF ] = cdf_TF_ftn_old( N, i, x )
%CDF_TF_FTN Returns the CDF of traffic factor for a line network
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           x = input to the cdf function - should be a vector

cdf_TF = zeros(1, length(x));

x_1 = i;
c_1 = i/N;
mu_1 = -0.016*x_1^2 + 2*x_1 - 2;
sigma_1 = -0.0011*x_1^2 + 0.128*x_1 + 1.42;
cdf_TF = cdf_TF + c_1*normcdf(x, mu_1, sigma_1);

for k=i:ceil(N/2)-1
    x_1 = k;
    c_1 = (0.5-1/N)/(ceil(N/2)-1);
    mu_1 = -0.016*x_1^2 + 2*x_1 - 2;
    sigma_1 = -0.0011*x_1^2 + 0.128*x_1 + 1.42;
    cdf_TF = cdf_TF +  c_1*normcdf(x, mu_1, sigma_1);
end

x_2 = N/2;
mu_2 = -0.016*x_2^2 + 2*x_2 - 2;
sigma_2 = -0.0011*x_2^2 + 0.128*x_2 + 1.42;
cdf_TF = cdf_TF + (1/2)*normcdf(x,mu_2,sigma_2);

end

