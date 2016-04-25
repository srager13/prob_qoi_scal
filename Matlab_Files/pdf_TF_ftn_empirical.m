function [ pdf_TF ] = pdf_TF_ftn_empirical( N, i, j, x )
%PDF_TF_FTN_2 Returns the value of the PDF of traffic factor for a line
%network for a given origin conditioned on the destination, i and j
%   Inputs:  
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           j = the flow destination
%           x = input to the pdf function - should be a vector

if i < N/4 || i > (3/4)*N
    % multimodal dist
    mu_1 = 11;
    sigma_1 = 2.5;
    mu_2 = 4;
    sigma_2 = 1;
    
    pdf_TF = 2*normpdf(x, mu_1, sigma_1) + 0.5*normpdf(x, mu_2, sigma_2);

else
    % single normal dist
    mu_1 = 11;
    sigma_1 = 3;
    pdf_TF = normpdf(x, mu_1, sigma_1);
end

% if j < i
%     mu_1 = (2*(i-1)*(N-i))/(N);
%     sigma_1 = sqrt(((2*(i-1)*(N-i))/(N))*(1-(1.0/(N))));
%     pdf_TF = normpdf(x, mu_1, sigma_1);
% end
% 
% if i < j && j < ceil(N/2)
%     mu_2 = (2*(j-1)*(N-j))/(N);
%     sigma_2 = sqrt(((2*(j-1)*(N-j))/(N))*(1-(1.0/(N))));
%     pdf_TF = normpdf(x, mu_2, sigma_2);
% end
% 
% if j >= ceil(N/2)
%     mu_3 = (2*(ceil(N/2)-1)*ceil(N/2))/(N);
%     sigma_3 = sqrt(((2*(ceil(N/2)-1)*ceil(N/2))/(N))*(1-(1.0/(N))));
%     pdf_TF = normpdf(x, mu_3, sigma_3);
% end

end
