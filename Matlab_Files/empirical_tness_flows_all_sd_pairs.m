% examine each flow's approximate timeliness using empirically found values
% of TF and PL.
%clear; 

syms T;

% num_nodes_set = 25:25:250;
num_nodes = 125;
W=2000000;
CF=3;
DF=2;
image_size = 2*1000*8; % KBytes
P = 1500*8; % 1500 Bytes coverted to bits
num_images = 1;
B=num_images*image_size;

% tness = zeros(1,length(num_nodes_set));
tness = zeros(num_nodes);
d_1 = zeros(num_nodes);
d_2 = zeros(num_nodes);

i=1;
PL = zeros(num_nodes, num_nodes);
max_TF = zeros(num_nodes, num_nodes);

% first get average TF for each node...fills in mean_TF_per_node vector
[mean_TF_per_node, std_dev_TF_per_node] = get_avg_TF_line_net( num_nodes );

for source=1:num_nodes
    for dest=1:num_nodes
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
        
%         d_1(source, dest) = (B*(max_TF(source,dest)+std_dev_TF_per_node(max_index))*CF)/W;
        d_1(source, dest) = (B*(max_TF(source,dest))*CF)/W;
        if source < dest
            DF = 1;
            d_2(source, dest) = (P*DF*PL(source,dest))/W;
        else
            DF = 2;
            d_2(source, dest) = (P*DF*PL(source,dest))/W;
        end
        
        tness(source, dest) = d_1(source, dest) + d_2(source, dest);
%         sol = solve( (B*(max_TF(source,dest)+std_dev_TF_per_node(max_index))*CF)/W + (P*DF*PL(source,dest))/W == T, T );
%         sol = solve( (B*(max_TF(source,dest))*CF)/W + (P*DF*PL(source,dest))/W == T, T );
%         tness(source, dest) = real(sol);
    end
end

bar3(tness);
% colorbar
% caxis([0, max(max(tness))]);
% zlim([0, max(max(tness))]);

