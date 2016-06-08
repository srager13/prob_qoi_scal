clear;

plot_color=1;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

channel_rate = 2;
IS = 2.5;
W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;
T = 10;
% prob_all_sets_cov = 0.1:0.1:0.99;
prob_all_sets_cov = linspace(0.1, 0.99, 30);

cluster_perc_requ = csvread('./Cluster_Perc_Sets_Covered.csv');

for i=1:length(prob_all_sets_cov)
    x = find( cluster_perc_requ(:,1) > prob_all_sets_cov(i) );
    if not( isempty(x) )
        num_images(i) = cluster_perc_requ(x(1),2);
    end
end

B = num_images*image_size;

N_clique = (W*T)./B;
N_line = (W*T)./(1.5*B + 1.5*P_s);
N_grid = ((W*T)./(5*B + 5*P_s)).^2;

hold on;
if plot_color == 1
    plot( prob_all_sets_cov, N_grid, '-*', 'color', [0 0.5 0], 'MarkerSize', marker_size-2 );
    plot( prob_all_sets_cov, N_line, '-ob', 'MarkerSize', marker_size );
    plot( prob_all_sets_cov, N_clique, '-sr', 'MarkerSize', marker_size );
else
    plot( prob_all_sets_cov, N_grid, '-*k', 'MarkerSize', marker_size-2 );
    plot( prob_all_sets_cov, N_line, '-ok', 'MarkerSize', marker_size );
    plot( prob_all_sets_cov, N_clique, '-sk', 'MarkerSize', marker_size );
end

leg = legend('Grid','Line','Clique', 'Location', 'NorthEast');
set(leg, 'FontSize', legend_font_size);
xlabel('Prob. All Sets Covered', 'FontSize', font_size);
ylabel('Maximum Network Size', 'FontSize', font_size);
set(gca, 'FontSize', axes_font_size);

output_directory = sprintf('./use_case_examples/num_nodes_vs_cluster_perc_cov/');
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end
if plot_color == 1
    saveas(gcf, sprintf('%snum_nodes_vs_cluster_perc_cov_%i_T_%i_IS_%i_W_color.pdf', output_directory, T, IS, channel_rate));
else
    saveas(gcf, sprintf('%snum_nodes_vs_cluster_perc_cov_%i_T_%i_IS_%i_W.pdf', output_directory, T, IS, channel_rate));
end
savefig(sprintf('%snum_nodes_vs_cluster_perc_cov_%i_T_%i_IS_%i_W_color.fig', output_directory, T, IS, channel_rate));