function [ pdf_TF ] = pdf_TF_ftn_grid( N, i, j, x )
%PDF_TF_FTN_2 Returns the value of the PDF of traffic factor for a line
%network for a given origin conditioned on the destination, i and j
%   Inputs:
%           N = the network size
%           i = the flow origin (bottleneck flow)
%           j = the flow destination
%           x = input to the pdf function - should be a vector


pdf_TF = normpdf( x, sqrt(N), 0.25*sqrt(N)*(1-(1.0/(sqrt(N)))) );
