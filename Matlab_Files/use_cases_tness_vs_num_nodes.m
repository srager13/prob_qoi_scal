clear;

plot_color=0;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

N = 10:10:250;

channel_rate = 2;
IS = 12;

W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;

ss_requ = csvread('SumSimRequirements_PSU_Data_Set.csv');

sum_sim = 5;
x = find( ss_requ(:,1) > sum_sim );
if not( isempty(x) )
    num_images = ss_requ(x(1),2);
end

B = num_images*image_size;

T_clique = (B/W)*(N-1)+(P_s/W);
T_line = 1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P_s/W)*(N/4 -1 );
T_grid = 5*(sqrt(N)/W)*(B+(P_s/3));

hold on;
if plot_color == 1
    plot( N, T_grid, '-*', 'color', [0 0.5 0], 'MarkerSize', marker_size-2 );
    plot( N, T_line, '-ob', 'MarkerSize', marker_size );
    plot( N, T_clique, '-sr', 'MarkerSize', marker_size );
else
    plot( N, T_grid, '-*k', 'MarkerSize', marker_size-2 );
    plot( N, T_line, '-ok', 'MarkerSize', marker_size );
    plot( N, T_clique, '-sk', 'MarkerSize', marker_size );
end

leg = legend('Grid','Line','Clique', 'Location', 'North');
set(leg, 'FontSize', legend_font_size);
xlabel('Number of Nodes', 'FontSize', font_size);
ylabel('Minimum Satisfiable Timeliness', 'FontSize', font_size);
set(gca, 'FontSize', axes_font_size);

output_directory = sprintf('./use_case_examples/tness_vs_num_nodes/');
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end
if plot_color == 1
    saveas(gcf, sprintf('%stness_vs_num_nodes_%i_SS_%i_IS_%i_W_color.pdf', output_directory, sum_sim, IS, channel_rate));
else
    saveas(gcf, sprintf('%stness_vs_num_nodes_%i_SS_%i_IS_%i_W.pdf', output_directory, sum_sim, IS, channel_rate));
end