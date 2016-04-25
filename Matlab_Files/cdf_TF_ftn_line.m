function [ cdf_TF ] = cdf_TF_ftn_line( N, i, j, x )
%CDF_TF_FTN Returns the CDF of traffic factor for a line network
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           x = input to the cdf function - should be a vector

cdf_TF = zeros(1,length(x));
if abs(i-j) == 1
    return;
end
if i < ceil(N/2) 
    if j < i
        mu_1 = (2*(i-1)*(N-i))/(N-1);
        sigma_1 = sqrt(((2*(i-1)*(N-i))/(N-1))*(1-(1.0/(N-1))));
        cdf_TF = normcdf(x, mu_1, sigma_1);
    end

    if i < j && j < ceil(N/2)
        mu_2 = (2*(j-1)*(N-j))/(N-1);
        sigma_2 = sqrt(((2*(j-1)*(N-j))/(N-1))*(1-(1.0/(N-1))));
        cdf_TF = normcdf(x, mu_2, sigma_2);
    end

    if j >= ceil(N/2)
        mu_3 = (2*(ceil(N/2)-1)*ceil(N/2))/(N-1);
        sigma_3 = sqrt(((2*(ceil(N/2)-1)*ceil(N/2))/(N-1))*(1-(1.0/(N-1))));
        cdf_TF = normcdf(x, mu_3, sigma_3);
    end
else
    if j > i
        mu_1 = (2*(i-1)*(N-i))/(N-1);
        sigma_1 = sqrt(((2*(i-1)*(N-i))/(N-1))*(1-(1.0/(N-1))));
        cdf_TF = normcdf(x, mu_1, sigma_1);
    end

    if i > j && j > ceil(N/2)
        mu_2 = (2*(j-1)*(N-j))/(N-1);
        sigma_2 = sqrt(((2*(j-1)*(N-j))/(N-1))*(1-(1.0/(N-1))));
        cdf_TF = normcdf(x, mu_2, sigma_2);
    end

    if j <= ceil(N/2)
        mu_3 = (2*(ceil(N/2)-1)*ceil(N/2))/(N-1);
        sigma_3 = sqrt(((2*(ceil(N/2)-1)*ceil(N/2))/(N-1))*(1-(1.0/(N-1))));
        cdf_TF = normcdf(x, mu_3, sigma_3);
    end
end   

end

