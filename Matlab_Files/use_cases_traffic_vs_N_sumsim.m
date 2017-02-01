clear;

plot_color=1;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

N = 5:5:100;

channel_rate = 2;
IS = 12;

W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;

ss_requ = csvread('SumSimRequirements_PSU_Data_Set.csv');

sum_sim = 1.5;
x = find( ss_requ(:,1) > sum_sim );
if not( isempty(x) )
    num_images = ss_requ(x(1),2);
end

B = num_images*image_size;

T_clique = (B/W)*(N-1)+(P_s/W);
T_line = 1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P_s/W)*(N/4 -1 );
T_grid = 5*(sqrt(N)/W)*(B+(P_s/3));
lambda_clique = 1./T_clique;
lambda_line = 1./T_line;
lambda_grid = 1./T_grid;

hold on;
if plot_color == 1
    plot( N, N.*lambda_grid, '-*', 'color', [0 0.5 0], 'MarkerSize', marker_size-2 );
    plot( N, N.*lambda_line, '-ob', 'MarkerSize', marker_size );
    plot( N, N.*lambda_clique, '-sr', 'MarkerSize', marker_size );
else
    plot( N, N.*lambda_grid, '-*k', 'MarkerSize', marker_size-2 );
    plot( N, N.*lambda_line, '-ok', 'MarkerSize', marker_size );
    plot( N, N.*lambda_clique, '-sk', 'MarkerSize', marker_size );
end

leg = legend('Grid','Line','Clique', 'Location', 'North');
set(leg, 'FontSize', legend_font_size);
xlabel('Number of Nodes', 'FontSize', font_size);
ylabel('Queries per Second', 'FontSize', font_size);
set(gca, 'FontSize', axes_font_size);

output_directory = sprintf('./use_case_examples/overall_traffic_vs_N_sum_sim/');
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end
if plot_color == 1
    saveas(gcf, sprintf('%soverall_traffic_vs_num_nodes_%i_SS_%i_IS_%i_W_color.pdf', output_directory, sum_sim, IS, channel_rate));
else
    saveas(gcf, sprintf('%soverall_traffic_vs_num_nodes_%i_SS_%i_IS_%i_W.pdf', output_directory, sum_sim, IS, channel_rate));
end
savefig(sprintf('%soverall_traffic_vs_num_nodes_%i_SS_%i_IS_%i_W.fig', output_directory, sum_sim, IS, channel_rate));