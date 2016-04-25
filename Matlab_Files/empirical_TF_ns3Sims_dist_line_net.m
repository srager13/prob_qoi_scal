% Visualize the Traffic Factor of the center node in a line network
%   This script opens Traffic Factor logs from ns3 simulations and 
%   fits them to a normal distribution
clear;
font_size = 20;

num_nodes = 125;
image_size = 18;
timeliness = 16;
%i_set = [31,63];

if mod(timeliness,1)==0
    directory = sprintf('./ns3_data/delay_dists/num_nodes_%i/image_size_%i/timeliness_%i',num_nodes, image_size, timeliness);
else
    directory = sprintf('./ns3_data/delay_dists/num_nodes_%i/image_size_%i/timeliness_%.1f',num_nodes, image_size, timeliness);
end

all_data = csvread(sprintf('%s/Node_TFs.csv',directory));
all_data(:,1) = all_data(:,1)+1;

x_vals = 1:num_nodes;
emp_TF_pdf = zeros(1,num_nodes);
%TF_values = zeros(num_nodes,num_trials);
%for i=1:num_nodes
%    TF_values(i,:) = TF_values(node, trial) + 1;
%end

mean_TF_per_node = zeros(1,num_nodes);
std_dev_TF_per_node = zeros(1,num_nodes);
for i=1:num_nodes
    [mean_TF_per_node(i), std_dev_TF_per_node(i)] = normfit(all_data(all_data(:,1)==i,2));
end

plot(x_vals, mean_TF_per_node);
title('Average TF per Node', 'FontSize',font_size);
xlabel('Number of Node in Line Network', 'FontSize',font_size);
ylabel('Average TF', 'FontSize',font_size);
saveas(gcf, sprintf('./TF_figures/mean_TFs_ns3data_line_net_%i_nodes.pdf',num_nodes));

figure;

plot(x_vals, std_dev_TF_per_node);
title('Std Dev of TF per Node', 'FontSize',font_size);
xlabel('Number of Node in Line Network', 'FontSize',font_size);
ylabel('Std Dev of TF', 'FontSize',font_size);
saveas(gcf, sprintf('./TF_figures/std_dev_TFs_ns3data_line_net_%i_nodes.pdf',num_nodes));

figure;

hold all;
i=1:6;
nodes_to_plot = ceil((num_nodes/max(i))*i);
for node=nodes_to_plot(1:3)
    TF_pdf = all_data(all_data(:,1)==node,2);% - mean_TF_per_node(node);
    ksdensity(TF_pdf);
end
title(sprintf('PDF of TF at Various Nodes (Network Size = %i)', num_nodes), 'FontSize',font_size);
xlabel('Number of Flows being Forwarded (TF)', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);
t = cellstr(num2str(nodes_to_plot(1:3)'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);
hold off;

saveas(gcf, sprintf('./TF_figures/Node_TFs_PDFs_line_net_%i.pdf',num_nodes));
saveas(gcf, sprintf('./%s/Node_TFs_PDFs_line_net_%i.pdf', directory, num_nodes));


all_data = csvread(sprintf('%s/Flow_TFs.csv',directory));
all_data(:,1) = all_data(:,1)+1;
figure;

hold all;
i=1:6;
nodes_to_plot = ceil((num_nodes/max(i))*i);
for node=nodes_to_plot(1:3)
    TF_pdf = all_data(all_data(:,1)==node,2);% - mean_TF_per_node(node);
    ksdensity(TF_pdf);
end
title(sprintf('PDF of Flows" Max TFs (Network Size = %i)', num_nodes), 'FontSize',font_size);
xlabel('Max TF for Flows from node i', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);
t = cellstr(num2str(nodes_to_plot(1:3)'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);
hold off;

saveas(gcf, sprintf('./TF_figures/Flow_TFs_PDFs_line_net_%i.pdf',num_nodes));
saveas(gcf, sprintf('./%s/PDF_Flow_TFs_line_net_%i.pdf', directory, num_nodes));