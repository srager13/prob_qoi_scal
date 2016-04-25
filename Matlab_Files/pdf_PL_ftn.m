function [ pdf_PL ] = pdf_PL_ftn( N, i, x )
%pdf_PL_FTN Returns the PDF of path length for a line network
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           x = input to the cdf function - should be a vector

pdf_PL = 0;

for y=x
    if 1 <= y && y < i
        pdf_PL = 2/N;
    end
    if i <= y && y <= N-i
        pdf_PL = 1/N;
    end
    if y > N-1
        pdf_PL = 0;
    end
end

% if( i > 1 )
%     cdf_PL(1:i-1) = (2*(x(1:i-1)-1))./N;
% end
% cdf_PL(i:N-i) = (x(i:N-i)-1)./N;

end


