function [ cdf_PL ] = cdf_PL_ftn( N, i, x )
%CDF_PL_FTN Returns the CDF of path length for a line network
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           x = input to the cdf function - should be a vector

% cdf_PL = zeros(1, length(x));
cdf_PL = 0;

for y=x
    if 1 <= y && y < i-1
        cdf_PL = 2*(y-1)/N;
    end
    if i <= y && y <= N-i
        cdf_PL = (y-i)/N;
    end
    if y > N-1
        cdf_PL = 1;
    end
end

% if( i > 1 )
%     cdf_PL(1:i-1) = (2*(x(1:i-1)-1))./N;
% end
% cdf_PL(i:N-i) = (x(i:N-i)-1)./N;

end

