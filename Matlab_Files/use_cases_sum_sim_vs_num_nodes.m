clear;

plot_color=0;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

N = 20:10:250;

channel_rate = 2;
IS = 12;
W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;
T = 50;

B_clique = (W*T - P_s)./(N-1);%(B/W)*(N-1)+(P_s/W);
B_line = (W*T - 1.5*P_s*N)./(1.5*N);%1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P_s/W)*(N/4 -1 );
B_grid = (W*T - 2.5*P_s*sqrt(N))./(5*sqrt(N));%5*(sqrt(N)/W)*(B+(P_s/3));

ss_requ = csvread('SumSimRequirements_PSU_Data_Set.csv');

for i=1:length(N)
    x = find( ss_requ(:,2) > B_clique(i)/image_size );
    if not( isempty(x) )
        SS_clique(i) = ss_requ(x(1),1);
    end
end
for i=1:length(N)
    x = find( ss_requ(:,2) > B_line(i)/image_size );
    if not( isempty(x) )
        SS_line(i) = ss_requ(x(1),1);
    end
end
for i=1:length(N)
    x = find( ss_requ(:,2) > B_grid(i)/image_size );
    if not( isempty(x) )
        SS_grid(i) = ss_requ(x(1),1);
    end
end

hold on;
if plot_color == 1
    plot( N, SS_grid, '-*', 'color', [0 0.5 0], 'MarkerSize', marker_size );
    plot( N, SS_line, '-ob', 'MarkerSize', marker_size );
    plot( N, SS_clique, '-sr', 'MarkerSize', marker_size );
else
    plot( N, SS_grid, '-*k', 'MarkerSize', marker_size );
    plot( N, SS_line, '-ok', 'MarkerSize', marker_size );
    plot( N, SS_clique, '-sk', 'MarkerSize', marker_size );
end

leg = legend('Grid','Line','Clique', 'Location', 'NorthEast');
set(leg, 'FontSize', legend_font_size);
xlabel('Number of Nodes', 'FontSize', font_size);
ylabel('Max Satisfiable Sum Similarity', 'FontSize', font_size);
set(gca, 'FontSize', axes_font_size);

output_directory = sprintf('./use_case_examples/sum_sim_vs_num_nodes/');
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end
if plot_color == 1
    saveas(gcf, sprintf('%ssum_sim_vs_num_nodes_%i_T_%i_IS_%i_W_color.pdf', output_directory, T, IS, channel_rate));
else
    saveas(gcf, sprintf('%ssum_sim_vs_num_nodes_%i_T_%i_IS_%i_W.pdf', output_directory, T, IS, channel_rate));
end