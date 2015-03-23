% plot the empirical std dev of the TF against network size

net_size = 10:10:500;
num_trials = 500;
TF_mean = zeros(1,length(net_size));
TF_std_dev = zeros(1,length(net_size));
TF_values = zeros(length(net_size), num_trials);

for x=1:length(net_size)
    num_nodes = net_size(x);
    center_node = ceil(num_nodes/2);
    for trial=1:num_trials
        for source=1:num_nodes % i is source
            dest = source;
            while dest == source
                dest = randi(num_nodes);
            end

            if abs(dest-source) == 1 % if 1 apart, then no forwarding
                continue;
            end

            if (source < center_node && dest > center_node) || (source > center_node && dest < center_node)
                TF_values(x,trial) = TF_values(x,trial) + 1;
            end
        end
    end
    
    [TF_mean(x), TF_std_dev(x)] = normfit(TF_values(x,:));
end

plot(net_size, TF_mean, ':ko');
figure;
plot(net_size, TF_std_dev, '-bx');
