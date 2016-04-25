clear;
plot_PDFs = 1;

font_size = 20;

num_nodes = 125;
image_size = 18;
timeliness = 16;
i_set = [1,63];
x_vals = 0:0.1:timeliness;

if mod(timeliness,1)==0
    directory = sprintf('./ns3_data/delay_dists/num_nodes_%i/image_size_%i/timeliness_%i',num_nodes, image_size, timeliness);
else
    directory = sprintf('./ns3_data/delay_dists/num_nodes_%i/image_size_%i/timeliness_%.1f',num_nodes, image_size, timeliness);
end

all_data = csvread(sprintf('%s/Node_delays.csv',directory));
all_data(:,1) = all_data(:,1)+1;

hold all;
for i=i_set
    cdfplot(all_data(all_data(:,1)==i,2));
end
xlabel('Delay', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:}, 'Location', 'NorthWest');
set(h_legend,'FontSize',14);
filename=sprintf('%s/Exper_CDF_D_%i_line_net_B_%i_KB.pdf',directory,num_nodes,image_size);
saveas(gcf,filename );
hold off;

if plot_PDFs == 1
    for i=i_set
        %pdfplot(all_data(all_data(:,1)==i,2), 25);
        figure;
        [f, xi] = ksdensity(all_data(all_data(:,1)==i,2));
        plot(xi, f);
        xlabel('Delay', 'FontSize',font_size);
        ylabel('PDF', 'FontSize',font_size);
        h_legend = legend(sprintf('Node %i',i), 'Location', 'NorthWest');
        set(h_legend,'FontSize',14);    
        filename=sprintf('%s/Exper_PDF_D_%i_line_net_B_%i_KB.pdf',directory,num_nodes,image_size);
        saveas(gcf,filename );
    end
end

