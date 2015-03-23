% Visualize the Traffic Factor of the center node in a line network
%   script simulates source destination pairs and creates a histogram of TF over
%   a number of trials
num_nodes = 100;
x_vals = 1:num_nodes;
num_trials = 10000;
emp_TF_pdf = zeros(1,num_nodes);
TF_values = zeros(num_nodes,num_trials);
font_size = 20;

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

mean_TF_per_node = zeros(1,num_nodes);
std_dev_TF_per_node = zeros(1,num_nodes);
for i=1:num_nodes
    [mean_TF_per_node(i), std_dev_TF_per_node(i)] = normfit(TF_values(i,:));
end
% mean_TF_per_node = mean(TF_values, 2);

plot(x_vals, mean_TF_per_node);
title('Average TF per Node', 'FontSize',font_size);
xlabel('Number of Node in Line Network', 'FontSize',font_size);
ylabel('Average TF', 'FontSize',font_size);
saveas(gcf, sprintf('./TF_figures/mean_TF_each_node_line_net_%i.pdf',num_nodes));

figure;

plot(x_vals, std_dev_TF_per_node);
title('Std Dev of TF per Node', 'FontSize',font_size);
xlabel('Number of Node in Line Network', 'FontSize',font_size);
ylabel('Std Dev of TF', 'FontSize',font_size);
saveas(gcf, sprintf('./TF_figures/std_dev_TF_each_node_line_net_%i.pdf',num_nodes));

figure;

hold on;
i=1:10;
nodes_to_plot = ceil((num_nodes/max(i))*i);
for node=nodes_to_plot(1:end-1)
    TF_pdf = TF_values(node,:);% - mean_TF_per_node(node);
    ksdensity(TF_pdf);
end
title(sprintf('PDF of TF at Various Nodes (Network Size = %i)', num_nodes), 'FontSize',font_size);
xlabel('Number of Flows being Forwarded (TF)', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);
t = cellstr(num2str(nodes_to_plot(1:end-1)'));
legend(t{:});
hold off;
saveas(gcf, sprintf('./TF_figures/TF_PDFs_line_net_%i.pdf',num_nodes));

% emp_TF_pdf = emp_TF_pdf./num_trials;
% plot(1:num_nodes, emp_TF_pdf);
% 
% [mean_TF, sig_TF] = normfit(TF_values);
% 
% TF_norm_pdf = normpdf(1:num_nodes, mean_TF, sig_TF);

%plot(1:num_nodes,TF_norm_pdf);