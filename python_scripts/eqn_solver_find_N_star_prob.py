#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  4 13:52:30 2017

@author: srager
"""
import numpy as np
import matplotlib.pyplot as plt
import math
from scipy.optimize import fsolve
from scipy.stats import norm

def cdf_TF_ftn_star( N, i, j, x ):
#CDF_TF_FTN Returns the CDF of traffic factor for a grid network
#   Inputs:  
#           N = the network size
#           i = the flow origin (bottleneck flow)
#           x = input to the cdf function - should be a vector
    if i == 1 or j == 1:
        pl = 1
    else:
        pl = 2
    if pl == 1:
        cdf_TF = 0
    else:
        cdf_TF = norm.cdf( x, 1.0*(N-1)*(N-2), 1.0*math.sqrt((N-1)*(N-2)) )
    return cdf_TF

avg_all_flows = 1 

W=2*1000*1000 
T=[i for i in range(100,200,10)]
q_comp_thresh = 0.999999 
num_images = 1 
 # num_images =1:6 
image_size_kb = 12
 # image_size_kb = 54 
#image_size_kb = 90 
 # image_size_kb = 120 
image_size_variance = 1 
I_s = image_size_kb*1000*8 
P_s = 1500*8   # 1500 Bytes coverted to bits
P_n = image_size_kb/P_s   # number of packets

#scal_vals = np.zeros( len(num_images), len(T), len(q_comp_thresh) ) 
scal_vals = np.zeros( [1, len(T), 1] ) 

output_directory = "./star_net/"
init_guess_file = open( "{}initial_guesses.csv".format(output_directory), 'w' )

last_N = 4
for i in range(1):
    for j in range(len(T)):
        for q in range(1):
            N = last_N + 1
            CF = N-2.0
            DF = N/2.0
            C_1 = (num_images*CF)/W 
            C_2 = (P_s*DF)/W 
            prob = 1.1 
            while prob > q_comp_thresh:
                N = N + 1
                prob = 0 
                for x in range(N):
                    zero_prob = 0 
                    for y in range(N):
                        if x==y:
                            continue 
 #                           sol_1 = solve( W - ( (C*(sqrt(N)+1)*(B+(2/3)*sqrt(N)*P))/T(j) ) == 0, N ) 
                        pl = 2
                        k = (W*T[j] - DF*P_s*pl)/(num_images*I_s*CF) 
 #                         prob = prob + binocdf( floor(k), floor(0.5*N^2), 1/N ) 
 #                         prob = prob + cdf_TF_ftn_star( N, x, y, k )*(1/(N-1)) 
 #                 fprintf( 'N =  #i, T =  #i, num_images =  #i, k =  #f, prob =  #f\n', N, T(j), num_images(i), k, prob ) 

                        if cdf_TF_ftn_star(N, min(x,y), max(x,y), (T[j]-C_2*pl)/(C_1*I_s)) == 0:
 #                             fprintf('zero prob =  #i: N =  #i, x =  #i, y =  #i\n', zero_prob, N, x, y) 
                            zero_prob = zero_prob + 1 
                        for i_s in range(1,image_size_kb*2+1):
                            prob = prob + norm.pdf(i_s,image_size_kb,math.sqrt(image_size_variance))*cdf_TF_ftn_star(N, min(x,y), max(x,y), (T[j]-C_2*pl)/(C_1*i_s*1000*8)) 
                            
#                            print( "cdf star (i_s = {}), x = {}: {}\n".format(i_s, (T[j]-C_2*pl)/(C_1*i_s*1000*8), cdf_TF_ftn_star(N, min(x,y), max(x,y), (T[j]-C_2*pl)/(C_1*i_s*1000*8) ) ) )
                    prob = prob/(N-zero_prob) 
                print( "N =  {}, T =  {}, num_images =  {}, k =  {}, prob =  {}\n".format(N, T[j], num_images, 0, prob) )
                if N > 50:
                    print( "N > 2500.  Giving up on this one...\n" ) 
                    prob = 0.0 
            if N < 50:
                last_N = N-1 
            scal_vals[i][j][q] = N 
            init_guess_file.write( "{},  {},  {},  {}\n".format(num_images/2.0, T[j], q_comp_thresh, scal_vals[i][j][q]) )
            print( "N =  {}, T =  {}, num_images =  {}, thresh =  {}\n".format(N, T[j], num_images, q_comp_thresh ) ) 
print(scal_vals)

 # scal_vals_w_pn
 # plot(T, mhop_cf_vals(1,:), '-kx') 
 # hold on 
 # plot(T, worst_PL(1,:), ':bo') 
 # legend('Avg. PL', 'Worst PL') 
 # plot(T, mhop_cf_vals(3,:), '-kx') 
 # plot(T, worst_PL(3,:), ':bo') 
 # csvwrite( sprintf('./image_size_ #i_KB/channel_rate_ #i/line_net/PS_ #i/analytical_scalability_mhop.csv', image_size/8000, W/1000000, P/8), mhop_vals ) 
 # csvwrite( sprintf('./image_size_ #i_KB/channel_rate_ #i/line_net/PS_ #i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), no_mhop_vals ) 
 # csvwrite( sprintf('./image_size_ #i_KB/channel_rate_ #i/line_net/PS_ #i/analytical_scalability_mhop_2.csv', image_size/8000, W/1000000, P/8), mhop_cf_vals ) 

