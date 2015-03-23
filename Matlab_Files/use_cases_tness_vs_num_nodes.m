clear;

N = 25:5:250;

channel_rate = 2;
IS = 12;

W=channel_rate*1000000;
P_s = 1500*8;
image_size = IS*8*1000;

ss_requ = csvread('SumSimRequirements_USC_Data_Set.csv');

sum_sim = 5;
x = find( ss_requ(:,1) > sum_sim );
if not( isempty(x) )
    num_images = ss_requ(x(1),2);
end

B = num_images*image_size;

T_clique = (B/W)*(N-1)+(P_s/W);
T_line = 1.5*(B/W)*((N-1).^2./(N-2))+1.5*(P_s/W)*(N/4 -1 );
T_grid = 5*(sqrt(N)/W)*(B+(P_s/3));

plot( N, T_clique, '-*k' );
hold on;
plot( N, T_line, '-.ok' );
plot( N, T_grid, '--xk' );

leg = legend('Clique','Line','Grid', 'Location', 'North');
set(leg, 'FontSize', 16);
%title('Time Required vs. Sum Similarity', 'FontSize', 22);
xlabel('Number of Nodes', 'FontSize', 20);
ylabel('Minimum Satisfiable Timeliness', 'FontSize', 20);
saveas(gcf, sprintf('./use_case_examples/tness_vs_num_nodes/tness_vs_num_nodes_%i_SS_%i_IS_%i_W.pdf', sum_sim, IS, channel_rate));