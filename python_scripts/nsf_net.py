#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Created on Wed Feb  1 11:11:37 2017

@author: srager
"""

import sys
import networkx as nx

num_nodes = 14
G = nx.Graph()
for i in range(num_nodes):
    G.add_node(i)

for i in range(num_nodes):
    for j in range(num_nodes):
        if j == i-1 or j == i+1:
            G.add_edge(i,j)
G.add_edge(0,1)
G.add_edge(0,2)
G.add_edge(0,3)
G.add_edge(1,2)
G.add_edge(1,7)
G.add_edge(2,5)
G.add_edge(3,4)
G.add_edge(3,11)
G.add_edge(4,5)
G.add_edge(4,6)
G.add_edge(5,8)
G.add_edge(5,9)
G.add_edge(6,7)
G.add_edge(7,10)
G.add_edge(8,10)
G.add_edge(9,12)
G.add_edge(9,13)
G.add_edge(10,12)
G.add_edge(10,13)
G.add_edge(11,12)
G.add_edge(11,13)

sys.stdout.write("Average path length = {}\n".format(nx.average_shortest_path_length(G)) )
degrees = list(G.degree().values())
sys.stdout.write("Average degree = {}\n".format(sum(degrees)/float(len(degrees))))

bc = nx.betweenness_centrality(G)
#bc = nx.betweenness_centrality(G, endpoints=True)

max_bc = 0
max_bc_node = -1
for node, node_bc in bc.items():
#    sys.stdout.write("{}: {}\n".format(node, node_bc))
    if node_bc > max_bc:
        max_bc = node_bc
        max_bc_node = node
        
sys.stdout.write("Node {} with max bc = {}\n".format(max_bc_node, max_bc))
sys.stdout.write("TF = {}\n".format(max_bc*num_nodes*(num_nodes-1))) 

max_pl = 0
for node_num in range(num_nodes):
    tf = 0
    p = nx.shortest_path(G)
    for src in p:
        for dst in p[src]:
            if src != dst:
                path = p[src][dst]
                if len(path) > max_pl:
                    max_pl = len(path)
#                sys.stdout.write("Path from {} to {}: ".format(src, dst))
#                print(p[src][dst])
                if node_num in path and node_num != path[-1] and node_num != path[0]:
#                    print ("included node {}".format(node_num))
                    tf += 1
    print("TF of node {} = {}".format(node_num, tf))
print("Max PL = {}".format(max_pl))
gc = nx.greedy_color(G)