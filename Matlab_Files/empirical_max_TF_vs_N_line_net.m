net_size = 5:2:225;
num_trials = 100;
num_nodes = 9;
max_transit_factor = zeros(1,length(net_size));

for x=1:length(net_size)
    num_nodes = net_size(x);
    transit_factor = zeros(1,num_nodes);
    for trial=1:num_trials
        for source=1:num_nodes % i is source
            dest = source;
            while dest == source
                dest = randi(num_nodes);
            end

            if abs(dest-source) == 1 % if 1 apart, then no forwarding
                continue;
            end

            if dest > source
                transit_factor(source+1:dest-1) = transit_factor(source+1:dest-1) + 1;
            else
                transit_factor(dest+1:source-1) = transit_factor(dest+1:source-1) + 1;
            end
        end
    end
    transit_factor = transit_factor./num_trials;
    max_transit_factor(x) = max(transit_factor);
end

plot(net_size, max_transit_factor, '-bx');

analytical_tf = (net_size-1).^2./(2*(net_size-2));
hold on;
plot(net_size, analytical_tf, 'ko');
