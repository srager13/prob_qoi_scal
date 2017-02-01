clear;
syms N;
plot_color=1;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

T = 5:1:25;
lambda = 1./T;
N_grid = zeros(1,length(T));
N_line = zeros(1, length(T));
N_clique = zeros(1,length(T));

channel_rate = 2;
IS = 3;

W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;
epsilon=0.1;

ccp_requ = csvread('Cluster_Perc_Sets_Covered.csv');

cluster_cov_perc = 0.5;
x = find( ccp_requ(:,1) > cluster_cov_perc );
if not( isempty(x) )
    num_images = ccp_requ(x(1),2);
end
B = num_images*image_size;
sol_index = 1;

for i=1:length(T)
    %grid
    CF=5;
    DF=2.5;
    sol_1 = solve( W*T(i) - CF*1.0*B*( sqrt(N)*(1 - log(epsilon)/(2*sqrt(N)) + sqrt( log(epsilon)^2/(4*N) - (2*log(epsilon))/sqrt(N) ) ) ) - P_s*DF*2*sqrt(N) == 0, N );
    N_grid(i) = floor(real(sol_1(sol_index)));
    
    %line
    CF=3;
    DF=1.5;
    sol_1 = solve( W*T(i) - CF*1.0*B*( ((N-1)/2)*(1 - log(epsilon)/(N-1) + sqrt( log(epsilon)^2/((N-1)*(N-1)) - (4*log(epsilon))/(N-1) ) ) ) - P_s*DF*(N-1) == 0, N );
    N_line(i) = floor(real(sol_1(sol_index)));

    %clique
    sol_1 = solve( W*T(i) - B*N == 0, N );
    N_clique(i) = floor(real(sol_1(sol_index)));
    
end

hold on;
if plot_color == 1
    plot( T, N_grid.*lambda, '-*', 'color', [0 0.5 0], 'MarkerSize', marker_size-2 );
    plot( T, N_line.*lambda, '-ob', 'MarkerSize', marker_size );
    plot( T, N_clique.*lambda, '-sr', 'MarkerSize', marker_size );
else
    plot( T, N_grid.*lambda, '-*k', 'MarkerSize', marker_size-2 );
    plot( T, N_line.*lambda, '-ok', 'MarkerSize', marker_size );
    plot( T, N_clique.*lambda, '-sk', 'MarkerSize', marker_size );
end

leg = legend('Grid','Line','Clique', 'Location', 'North');
set(leg, 'FontSize', legend_font_size);
xlabel('Timeliness', 'FontSize', font_size);
ylabel('Queries per Second', 'FontSize', font_size);
set(gca, 'FontSize', axes_font_size);

output_directory = sprintf('./use_case_examples/overall_traffic_vs_T_cluster/');
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end
if plot_color == 1
    saveas(gcf, sprintf('%soverall_traffic_vs_tness_%i_CCP_%i_IS_%i_W_color.pdf', output_directory, cluster_cov_perc, IS, channel_rate));
else
    saveas(gcf, sprintf('%soverall_traffic_vs_tness_%i_CCP_%i_IS_%i_W.pdf', output_directory, cluster_cov_perc, IS, channel_rate));
end
savefig(sprintf('%soverall_traffic_vs_tness_%i_CCP_%i_IS_%i_W.fig', output_directory, cluster_cov_perc, IS, channel_rate));