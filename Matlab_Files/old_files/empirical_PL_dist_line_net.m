% Visualize the average path length of nodes in a line network
%   script simulates source destination pairs 
clear; 

num_nodes = 125;
x_vals = 1:num_nodes;
num_trials = 10000;
emp_PL_pdf = zeros(1,num_nodes);
PL_values = zeros(num_nodes, num_trials);
avg_PL_flows_thru_center = 0;
num_flows_thru_center = 0;
font_size = 20;

for trial=1:num_trials
    for source=1:num_nodes 
        % choose a destination that is not equal to source
        dest = source;
        while dest == source
            dest = randi(num_nodes);
        end
        
        % collect path length values to process later
        PL_values(source,trial) = abs(source-dest);
        
        % gather number and sum of path length for all flow that go through
        % center (max TF)
        center_node = ceil(num_nodes/2);
        if (source < center_node && dest > center_node) || (source > center_node && dest < center_node)
            avg_PL_flows_thru_center = avg_PL_flows_thru_center + abs(source-dest);
            num_flows_thru_center = num_flows_thru_center + 1;
        end
    end
end
avg_PL_flows_thru_center = avg_PL_flows_thru_center/num_flows_thru_center;

mean_PL_per_node = mean(PL_values, 2);
plot(x_vals, mean_PL_per_node);
title('Average PL per Node', 'FontSize',font_size);
xlabel('Number of Node in Line Network', 'FontSize',font_size);
ylabel('Average Path Length (hops)', 'FontSize',font_size);
saveas(gcf, sprintf('./PL_figures/mean_PL_each_node_line_net_%i.pdf',num_nodes));

figure;

hold on;
% nodes_to_plot = ceil((num_nodes/max(i))*i);
% nodes_to_plot = [1,132,263];
nodes_to_plot = [1,ceil(num_nodes/4),ceil(num_nodes/2), 3*ceil(num_nodes/4)];
PL_pdf = zeros(length(nodes_to_plot), num_nodes);
x=1;
for node=nodes_to_plot(1:end)
    for i=1:num_trials
        PL_pdf(x, PL_values(node,i)) = PL_pdf(x, PL_values(node,i)) + 1;
    end
    PL_pdf(x,:) = PL_pdf(x,:)./num_trials;
    plot(x_vals, PL_pdf(x,:));
    x = x + 1;
%     PL_pdf = PL_values(node,:);% - mean_PL_per_node(node);
%     ksdensity(PL_pdf);
end
title(sprintf('PDF of PL at Various Nodes (Network Size = %i)',num_nodes), 'FontSize',font_size);
xlabel('Path Length (hops)', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);
t = cellstr(num2str(nodes_to_plot(1:end)'));
legend(t{:});
hold off;
saveas(gcf, sprintf('./PL_figures/PL_PDFs_each_node_line_net_%i.pdf',num_nodes));

% emp_PL_pdf = emp_PL_pdf./num_trials;
% plot(1:num_nodes, emp_PL_pdf);
% 
% [mean_PL, sig_PL] = normfit(PL_values);
% 
% PL_norm_pdf = normpdf(1:num_nodes, mean_PL, sig_PL);
% hold on;
% plot(1:num_nodes,PL_norm_pdf);
