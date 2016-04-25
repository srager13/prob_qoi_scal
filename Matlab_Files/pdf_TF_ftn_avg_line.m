function [ pdf_TF ] = pdf_TF_ftn_avg_line( N, i, j, x )
%PDF_TF_FTN_2 Returns the value of the PDF of traffic factor for a line
%network for a given origin conditioned on the destination, i and j
%   Inputs:
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           j = the flow destination
%           x = input to the pdf function - should be a vector

pdf_TF = 0;

if j < i
    mu_1 = ((i-1)*(N-i))/(N-1);
    sigma_1 = sqrt((((i-1)*(N-i))/(N-1))*(1-(1.0/(N))));
    pdf_TF = normpdf(x, mu_1, sigma_1);
end

if i < j && j < ceil(N/2)
    mu_2 = ((j-1)*(N-j))/(N-1);
    sigma_2 = sqrt((((j-1)*(N-j))/(N-1))*(1-(1.0/(N))));
     pdf_TF = normpdf(x, mu_2, sigma_2);
end

if j >= ceil(N/2)
    mu_3 = ((ceil(N/2)-1)*ceil(N/2))/(N-1);
    sigma_3 = sqrt((((ceil(N/2)-1)*ceil(N/2))/(N-1))*(1-(1.0/(N))));
    pdf_TF = normpdf(x, mu_3, sigma_3);
end

end
