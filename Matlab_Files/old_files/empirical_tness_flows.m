% examine each flow's approximate timeliness using empirically found values
% of TF and PL.
%clear; 

syms T;

num_nodes_set = 25:25:250;
W=2000000;
CF=3;
DF=1.5;
image_size = 12000*8; % 12 KBytes
P = 1500*8; % 1500 Bytes coverted to bits
num_images = 1;
B=num_images*image_size;

tness = zeros(1,length(num_nodes_set));

i=1;
for num_nodes=num_nodes_set
    
PL = zeros(num_nodes, num_nodes);
max_TF = zeros(num_nodes, num_nodes);

% first get average TF for each node...fills in mean_TF_per_node vector
%empirical_TF_dist_line_net;
[mean_TF_per_node, std_dev_TF_per_node] = get_avg_TF_line_net( num_nodes );

% for source=1:num_nodes
    source=1;
%     for dest=1:num_nodes
        dest=num_nodes;
        % choose a destination that is not equal to source
        if dest == source
            continue;
        end

        % determine path length
        PL(source,dest) = abs(source-dest);
        
        % determine maximum TF along path
        if source < dest
            [max_TF(source, dest), max_index] = max(mean_TF_per_node(source:dest)); %get index of max to add STD DEV
            max_index = source + max_index - 1;
        else
            [max_TF(source, dest), max_index] = max(mean_TF_per_node(dest:source));
            max_index = dest + max_index - 1;
        end
        
%         sol = solve( (B*(max_TF(source,dest)+std_dev_TF_per_node(max_index))*CF)/W + (P*DF*PL(source,dest))/W == T, T );
        sol = solve( (B*(max_TF(source,dest))*CF)/W + (P*DF*PL(source,dest))/W == T, T );
%         tness(source, dest) = real(sol);
        tness(find(num_nodes_set==num_nodes)) = real(sol);
%     end
% end
end

plot(num_nodes_set, tness, '-kx');

N = num_nodes_set;
T_line = 1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P/W)*(N/4 -1 );
%T_line = 1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P/W)*N;

hold on;
plot(num_nodes_set, T_line, '-bo');
legend('Worst PL', 'Avg. PL');

tness - T_line
% bar3(tness);
% colorbar
% caxis([0, max(max(tness))]);
% zlim([0, max(max(tness))]);

