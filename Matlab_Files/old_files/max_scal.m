% examine each flow's approximate timeliness using empirically found values
% of TF and PL.
%clear; 

syms N;

tness = 10:10:50;
W=2000000;
CF=3;
DF=1.5;
image_size = 12000*8; % 12 KBytes
P = 1500*8; % 1500 Bytes coverted to bits
num_images = 1:5;
B=num_images*image_size;

PL = zeros(num_nodes, num_nodes);
max_TF = zeros(num_nodes, num_nodes);

% first get average TF for each node...fills in mean_TF_per_node vector
%empirical_TF_dist_line_net;
[mean_TF_per_node, std_dev_TF_per_node] = get_avg_TF_line_net( num_nodes );

for source=1:num_nodes
    for dest=1:num_nodes
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
        
        sol = solve( (B*(max_TF(source,dest)+std_dev_TF_per_node(max_index))*CF)/W + (P*DF*PL(source,dest))/W == T, T );
        max_scal(source, dest) = real(sol);
    end
end

bar3(max_scal);
% colorbar
% caxis([0, max(max(tness))]);
% zlim([0, max(max(tness))]);

