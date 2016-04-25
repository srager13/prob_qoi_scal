clear;
plot_PDFs = 1;

font_size = 20;

num_nodes = 125;
image_size = 18;
timeliness = 16;
i_set = [31,63];

if mod(timeliness,1)==0
    directory = sprintf('./ns3_data/delay_dists/num_nodes_%i/image_size_%i/timeliness_%i',num_nodes, image_size, timeliness);
else
    directory = sprintf('./ns3_data/delay_dists/num_nodes_%i/image_size_%i/timeliness_%.1f',num_nodes, image_size, timeliness);
end

all_data = csvread(sprintf('%s/Node_TFs.csv',directory));
all_data(:,1) = all_data(:,1)+1;

hold on;
for i=i_set
    cdfplot(all_data(all_data(:,1)==i,2));
end
xlabel('Traffic Factor', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:}, 'Location', 'NorthWest');
set(h_legend,'FontSize',14);
filename=sprintf('%s/Exper_CDF_TF_%i_line_net_B_%i_KB.pdf',directory,num_nodes,image_size);
saveas(gcf,filename );

if plot_PDFs == 1
    for i=i_set
        pdfplot(all_data(all_data(:,1)==i,2),50);
        
        xlabel('TF', 'FontSize',font_size);
        ylabel('PDF', 'FontSize',font_size);
        h_legend = legend(sprintf('Node %i', i));
        set(h_legend,'FontSize',14);

        filename=sprintf('%s/Exper_PDF_TF_%i_line_net_B_%i_KB.pdf',directory,num_nodes,image_size);
        saveas(gcf,filename );
    end
end

