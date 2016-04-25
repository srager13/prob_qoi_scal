#!/bin/bash
grid=0
line=0

if [ $# -lt 2 ]
	then 
	echo "USAGE: copy_scalability_to_village.sh -g (grid) -l (line) -i image_size -r channel_rate -p packet_size -q q_comp_thresh"
	exit -1
fi

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
    -r|--channelRate)
		shift
    channel_rate=$1
    ;;
    -p|--packetSize)
		shift
    packet_size=$1
    ;;
    -q|--qCompThresh)
		shift
    q_comp_thresh=$1
    if [[ $q_comp_thresh -eq 100 ]]; then
			q_comp_thresh="`echo "scale=2; $q_comp_thresh/100.0" | bc`"
		else
			q_comp_thresh="0`echo "scale=2; $q_comp_thresh/100.0" | bc`"
		fi
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

REMOTE_DIR=/home/moby/str5004/ns-3-working-directory/ns-allinone-3.21/ns-3.21/data_files/topk_query/
LOCAL_DIR=./scal_predictions/image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/PS_${packet_size}/

#LINE NET
if [ $line -ge "1" ]; then
  REMOTE_DIR=${REMOTE_DIR}line_net/
  LOCAL_DIR=${LOCAL_DIR}line_net/
  echo "Transferring line scalability"
fi	
#GRID NET
if [ $grid -ge "1" ]; then
  REMOTE_DIR=${REMOTE_DIR}grid_net/
  LOCAL_DIR=${LOCAL_DIR}grid_net/
  echo "Transferring grid scalability"
fi	
REMOTE_DIR=${REMOTE_DIR}data_set_SumSimRequirements_USC_data_set/image_size_${image_size_KB}_KB/channel_rate_${channel_rate}/PS_${packet_size}/q_comp_thresh_${q_comp_thresh}/

echo "LOCAL_DIR = $LOCAL_DIR"
echo "REMOTE_DIR = $REMOTE_DIR"
ssh str5004@village.cse.psu.edu "mkdir -p ${REMOTE_DIR}"
scp ${LOCAL_DIR}/initial_guesses*.csv village:${REMOTE_DIR}


