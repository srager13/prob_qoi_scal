clear;
clc;

plot_exp=0;
linespec = {'xb', '+g', 'oc', '*r'};
font_size = 20;

W=2*1000*1000;
N=50:2:85;
% N=40:2:80;
T=70;
% T=50;
% q_comp_thresh = 0.65:0.10:0.95;
% q_comp_thresh = 0.99;
num_images = 1;
% num_images =1:6;
% image_size_kb = 48;
image_size_kb = 90;
% max_buffer_size = 100;
% max_buffer_size = 250;
max_buffer_size = 1000;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
CF = 3;
DF = 1.5;

q_comp_thresh = zeros(length(num_images), length(N));

output_directory = sprintf('./scal_predictions/comp_perc_vs_N/image_size_%i_KB/timeliness_%i/line_net/', image_size_kb, T );
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

init_guess_file = fopen( sprintf('%s/comp_per_vs_N.csv', output_directory), 'w' );

for i=1:length(num_images)
    
    for n=1:length(N)
        C_1 = (num_images(i)*I_s*CF)/W;
        C_2 = (P_s*DF)/W;

        prob = 0;
        for x=1:N(n)
            zero_prob = 0;
            for y=1:N(n)
                if x==y
                    continue;
                end
                pl = abs(x-y);
                k = (T-C_2*pl)/C_1;
                if cdf_TF_ftn_2_line(N(n), min(x,y), max(x,y), (T-C_2*pl)/C_1) == 0
                    zero_prob = zero_prob + 1;
                end
                m_factor = 1.0;
                m_factor_2 = 1.0;
                a_factor = 0;
                prob_this_flow = cdf_TF_ftn_2_line(N(n), x, y, m_factor*(T-a_factor-m_factor_2*C_2*pl)/C_1);
                prob = prob + cdf_TF_ftn_2_line(N(n), x, y, m_factor*(T-a_factor-m_factor_2*C_2*pl)/C_1);
%                 fprintf( 'x = %i, y = %i, N = %i, T = %i, num_images = %i, k = %f, prob this flow = %f, total_prob = %f\n', x, y, N(n), T, num_images(i), k, prob_this_flow, prob );
            end
            prob_this_flow = prob_this_flow/(N(n)-zero_prob);
            prob = prob/(N(n)-zero_prob);
        end
%         prob = prob/(N(n)-2);

        q_comp_thresh(i,n) = prob;
        fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T, q_comp_thresh(n), q_comp_thresh(i,n) );
        fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', N(n), T, num_images(i), q_comp_thresh(n) );
    end
end
q_comp_thresh

plot(N, q_comp_thresh, char(linespec(end)) );
xlabel('Number of Nodes', 'FontSize',font_size);
ylabel('Query Completion Perc.', 'FontSize',font_size);
legendTitles{1} = 'Analytical';

if plot_exp == 1
    hold on;
    EXP_DIR = sprintf('/home/grads/str5004/Dropbox/data_files/prob_qoi_scal/vary_num_nodes/image_size_%i/query_rate_%i/timeliness_%i/sumsim_0.5/mbs_%i/not_cont_traffic/flush_queues/line_net/', image_size_kb, T, T, max_buffer_size );
    exp_vals = csvread( sprintf('%sCompRateVsNumNodes.csv', EXP_DIR) );
%     exp_vals = csvread( sprintf('%sPercPacketsRcvdVsNumNodes.csv', EXP_DIR) );
    num_node_values = exp_vals(:,1);
    q_comp_values = exp_vals(:,2);
    plot(num_node_values, q_comp_values, char(linespec(1)) );
    legendTitles{2} = 'Experimental';
    plot_exp_str = '_vsExp';
end
legend_font_size = 14;
legend(cellstr(legendTitles), 'Location', 'Best', 'FontSize', legend_font_size);
saveas(gcf, sprintf('%s/CompRateVsNumNodes_AnalVsExp.pdf', output_directory));

% csvwrite( sprintf('./%s/analytical_scalability_qoi.csv', output_directory), scal_vals );
% scal_vals_w_pn
% plot(T, mhop_cf_vals(1,:), '-kx');
% hold on;
% plot(T, worst_PL(1,:), ':bo');
% legend('Avg. PL', 'Worst PL');
% plot(T, mhop_cf_vals(3,:), '-kx');
% plot(T, worst_PL(3,:), ':bo');
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop.csv', image_size/8000, W/1000000, P/8), mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), no_mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop_2.csv', image_size/8000, W/1000000, P/8), mhop_cf_vals );

