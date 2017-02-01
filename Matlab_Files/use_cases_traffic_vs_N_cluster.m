clear;
syms T;
plot_color=1;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

N = 5:5:100;
T_grid = zeros(1,length(N));
T_line = zeros(1, length(N));
T_clique = zeros(1,length(N));

channel_rate = 2;
IS = 12;

W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;

ccp_requ = csvread('Cluster_Perc_Sets_Covered.csv');

cluster_cov_perc = 0.8;
x = find( ccp_requ(:,1) > cluster_cov_perc );
if not( isempty(x) )
    num_images = ccp_requ(x(1),2);
end

B = num_images*image_size;
epsilon = 0.999;
sol_index = 1;

for i=1:length(N)
    %grid
    CF=5;
    DF=2.5;
    sol_1 = solve( W*T - CF*1.0*image_size*( sqrt(N(i))*(1 - log(epsilon)/(2*sqrt(N(i))) + sqrt( log(epsilon)^2/(4*N(i)) - (2*log(epsilon))/sqrt(N(i)) ) ) ) - P_s*DF*2*sqrt(N(i)) == 0, T );
    T_grid(i) = real(sol_1(sol_index));
    
    %line
    CF=3;
    DF=1.5;
    sol_1 = solve( W*T - CF*1.0*image_size*( ((N(i)-1)/2)*(1 - log(epsilon)/(N(i)-1) + sqrt( log(epsilon)^2/((N(i)-1)*(N(i)-1)) - (4*log(epsilon))/(N(i)-1) ) ) ) - P_s*DF*(N(i)-1) == 0, T );
    T_line(i) = real(sol_1(sol_index));

    sol_1 = solve( W*T - B*N(i) == 0, T );
    T_clique(i) = real(sol_1(sol_index));
    
end

% T_clique = (B/W)*(N-1)+(P_s/W);
% T_line = 1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P_s/W)*(N/4 -1 );
% T_grid = 5*(sqrt(N)/W)*(B+(P_s/3));
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

output_directory = sprintf('./use_case_examples/overall_traffic_vs_N_cluster/');
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end
if plot_color == 1
    saveas(gcf, sprintf('%soverall_traffic_vs_num_nodes_%i_CCP_%i_IS_%i_W_color.pdf', output_directory, cluster_cov_perc, IS, channel_rate));
else
    saveas(gcf, sprintf('%soverall_traffic_vs_num_nodes_%i_CCP_%i_IS_%i_W.pdf', output_directory, cluster_cov_perc, IS, channel_rate));
end
savefig(sprintf('%soverall_traffic_vs_num_nodes_%i_CCP_%i_IS_%i_W.fig', output_directory, cluster_cov_perc, IS, channel_rate));