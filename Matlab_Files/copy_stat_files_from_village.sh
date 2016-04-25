#!/bin/bash

num_nodes=125
image_size=18

scp -r str5004@village.cse.psu.edu:/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/data_files/prob_qoi_scal/delay_dists/num_nodes_${num_nodes}/image_size_${image_size}/* ./ns3_data/delay_dists/num_nodes_${num_nodes}/image_size_${image_size}/
