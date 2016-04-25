#!/bin/bash
if [ $# -lt 2 ]
	then 
	echo "USAGE: copy_from_village.sh -g (grid) -l (line) -i image_size -r channel_rate -p packet_size" # -q q_comp_thresh"
	exit -1
fi

grid=0
line=0
channel_rate=2
packet_size=1500

while [[ $# > 0 ]]
do
key="$1"

case $key in
    -g|--grid)
		grid=1
    ;;
    -l|--line)
		line=1
    ;;
    -i|--imageSize)
		shift
    image_size_KB=$1
    ;;
    -p|--packetSize)
		shift
    packet_size=$1
    ;;
#    -q|--qCompThresh)
#		shift
#    q_comp_thresh=$1
#		q_comp_thresh="0`echo "scale=2; $q_comp_thresh/100.0" | bc`"
#    ;;
    -r|--channelRate)
		shift
    channel_rate=$1
    ;;
    --default)
    DEFAULT=YES
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

echo "image size = ${image_size_KB}"
echo "channel rate = ${channel_rate}"
echo "packet size = ${packet_size}"

if [ ! -d ./image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/line_net/PS_${packet_size}/q_comp_thresh_${q_comp_thresh} ]; then
	mkdir -p ./image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/line_net/PS_${packet_size}/q_comp_thresh_${q_comp_thresh}
fi

LOCAL_DIR="./scal_predictions/image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/PS_${packet_size}/"
#REMOTE_DIR="/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/data_files/vary_q_comp_thresh/"
REMOTE_DIR="/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/data_files/topk_query/"

#LINE NET
if [ $line -ge "1" ]; then
  echo "Transferring line scalability"
	LOCAL_DIR="${LOCAL_DIR}line_net/"
  REMOTE_DIR="${REMOTE_DIR}line_net/"
fi
#GRID NET
if [ $grid -ge 1 ]; then
  echo "Transferring grid scalability"
	LOCAL_DIR="${LOCAL_DIR}grid_net/"
  REMOTE_DIR="${REMOTE_DIR}grid_net/"
fi
REMOTE_DIR="${REMOTE_DIR}data_set_SumSimRequirements_USC_data_set/image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/PS_${packet_size}/q_comp_thresh_1.00"

scp str5004@village.cse.psu.edu:${REMOTE_DIR}/Scalability*.csv ${LOCAL_DIR} 


#CLIQUE NET
#scp str5004@village.cse.psu.edu:/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/data_files/topk_query/clique_net/data_set_SumSimRequirements_USC_data_set/image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/TopkQueryClientStats*.csv ./image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/clique_net/
#scp str5004@village.cse.psu.edu:/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/data_files/topk_query/clique_net/data_set_SumSimRequirements_USC_data_set/image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/Scalability*.csv ./image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/clique_net/

#TDMA Stats - for transit factor - #GRID
#scp str5004@village.cse.psu.edu:/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/TdmaQueueStats.csv ./image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/grid_net/

