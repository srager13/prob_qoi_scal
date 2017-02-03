#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  1 20:06:27 2017

@author: srager
"""

import csv
import matplotlib.pyplot as plt
import numpy as np
from sympy import *

plot_color=1
font_size = 26
font_weight = 550
legend_font_size = 22
axes_font_size = 16
marker_size = 15

num_data_points = 25
channel_rate = 2
IS = 12
W=channel_rate*1000000
P_s = 1500*8
image_size = IS*8*1000
perc_cov_values = np.linspace(0.1,1,num_data_points)
perc_cov_requ = []

#ss_requ = csvread('SumSimRequirements_PSU_Data_Set.csv')
with open('Matlab_Files/Cluster_Perc_Sets_Covered.csv', 'r') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
#        print(row)
        perc_cov_requ.append(float(row[0]))

num_images = [0 for i in range(len(perc_cov_values))]
for p in range(len(perc_cov_values)):
    for i in range(len(perc_cov_requ)):
        if perc_cov_requ[i] >= perc_cov_values[p]:
            num_images[p] = i
            break

#
#B = num_images*image_size;
#
T = np.zeros(num_data_points)
for i in range(num_data_points):
    B = num_images[i]*image_size
    T[i] = (B*4*2.15 + P_s*2*4)/(W)

fig = plt.figure()
ax = fig.add_subplot(111)          
plt.plot(perc_cov_values, T, 'bx-', markersize=10, label="NSFNET Topology")
#plt.plot(perc_cov_values, num_images)
ax.set_xlabel('Prob. All Sets Covered', fontsize=axes_font_size, family='Arial', weight=font_weight) #, fontweight='bold'
ax.set_ylabel('Minimum Satisfiable Timeliness ', fontsize=axes_font_size, family='Arial', weight=font_weight) #, fontweight='bold'
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
plt.legend(loc='best', fontsize=12)
plt.savefig('./figures/use_cases_examples/nsf_net/prob_sets_cov_vs_tness.pdf');

#hold on;
#if plot_color == 1
#    plot( T, N_grid, '-*', 'color', [0 0.5 0], 'MarkerSize', marker_size-2 );
#    plot( T, N_line, '-ob', 'MarkerSize', marker_size );
#    plot( T, N_clique, '-sr', 'MarkerSize', marker_size );
#else
#    plot( T, N_grid, '-*k', 'MarkerSize', marker_size-2 );
#    plot( T, N_line, '-ok', 'MarkerSize', marker_size );
#    plot( T, N_clique, '-sk', 'MarkerSize', marker_size );
#end
#
#leg = legend('Grid','Line','Clique', 'Location', 'North');
#set(leg, 'FontSize', legend_font_size);
#xlabel('Timeliness', 'FontSize', font_size);
#ylabel('Maximum Network Size', 'FontSize', font_size);
#set(gca, 'FontSize', axes_font_size);
#
#output_directory = sprintf('./use_case_examples/num_nodes_vs_tness/');
#if ~exist(output_directory, 'dir')
#  mkdir(output_directory);
#end
#if plot_color == 1
#    saveas(gcf, sprintf('%snum_nodes_vs_tness_%i_SS_%i_IS_%i_W_color.pdf', output_directory, SS, IS, channel_rate));
#else
#    saveas(gcf, sprintf('%snum_nodes_vs_tness_%i_SS_%i_IS_%i_W.pdf', output_directory, SS, IS, channel_rate));
#end