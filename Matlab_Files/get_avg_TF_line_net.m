function [ mean_TF_per_node, std_dev_TF_per_node ] = get_avg_TF_line_net( num_nodes )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Visualize the Traffic Factor of the center node in a line network
%   script simulates source destination pairs and creates a histogram of TF over
%   a number of trials
num_trials = 1000;
TF_values = zeros(num_nodes,num_trials);

for trial=1:num_trials
    for source=1:num_nodes 
        % choose a destination that is not equal to source
        dest = source;
        while dest == source
            dest = randi(num_nodes);
        end

        for node = 1:num_nodes
            if (source < node && dest > node) || (source > node && dest < node)
                TF_values(node, trial) = TF_values(node, trial) + 1;
            end
        end

    end
end

% mean_TF_per_node = mean(TF_values, 2);

mean_TF_per_node = zeros(1,num_nodes);
std_dev_TF_per_node = zeros(1,num_nodes);

for i=1:num_nodes
    [mean_TF_per_node(i), std_dev_TF_per_node(i)] = normfit(TF_values(i,:));
end

