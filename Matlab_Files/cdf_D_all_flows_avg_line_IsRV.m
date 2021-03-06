clear;
clc;
figure;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;
orig=1;
plot_exp=1;
from_scal_exp=1;
% exp_tness=18;
% exp_tness=24;
exp_tness=45;
% exp_tness=85;

% num_nodes = 20;
% num_nodes = 30;
num_nodes = 40;
% image_size_kb = 36;
% image_size_kb = 48;
image_size_kb = 90;
% image_size_kb = 180;
% image_size_variance = 48;
% image_size_variance = 64;
image_size_variance = 45;
% timeliness = 18;
% timeliness = 24;
timeliness = 45;
% max_buffer_size=250;
% max_buffer_size=500;
max_buffer_size=1000;
% rate_divisor=9;
rate_divisor=18;
% rate_divisor=28;

N = num_nodes;
k_req = 1;
j_set = 1:num_nodes;
i_set = 1:num_nodes;
% plot_set = [1,ceil(N/2)];
plot_set = [];
colors = ['g','b','r'];
linespec = {'xb', '+g', 'oc', '*r'};
I_s = image_size_kb*1000*8;
B=k_req*I_s/8000;
CF = 3;
DF = 1.5;
channel_rate=2;
W = 2*1000000;
packet_size=1500;
P_s = 1500*8;
P_n = (B*8000)/P_s;

delay_set = 1.0:1.0:timeliness;
C_1 = (k_req*CF)/W;
C_2 = (P_s*DF)/W;

orig_str = '';
cdf_D = zeros(1, length(delay_set));
max_cdf = zeros(1, length(delay_set));
hold on;
for i=1:N
    cdf_D_i = zeros(1, length(delay_set));
    zero_prob = 0;
    for j=1:N
        if i == j
            continue;
        end
        pl = abs(i-j);

        m_factor = 1;
        a_factor = 0;
        if cdf_TF_ftn_2_line(N, min(i,j), max(i,j), (delay_set-a_factor-m_factor*C_2*pl)/C_1) == 0
            zero_prob = zero_prob + 1;
        end
%         for i_s=image_size_kb-sqrt(image_size_variance)*2:image_size_kb+sqrt(image_size_variance)*2
        for i_s=1:image_size_kb*2
%             cdf_D = cdf_D + normpdf(i_s,image_size_kb,sqrt(image_size_variance))*cdf_TF_ftn_2_line(N, min(i,j), max(i,j), (delay_set-a_factor-m_factor*C_2*pl)/(C_1*i_s*1000*8));
%             cdf_D_i = cdf_D_i + normpdf(i_s,image_size_kb,sqrt(image_size_variance))*cdf_TF_ftn_2_line(N, min(i,j), max(i,j), (delay_set-a_factor-m_factor*C_2*pl)/(C_1*i_s*1000*8));
            cdf_D = cdf_D + normpdf(i_s,image_size_kb,sqrt(image_size_variance))*cdf_TF_ftn_poisson_line(N, min(i,j), max(i,j), (delay_set-a_factor-m_factor*C_2*pl)/(C_1*i_s*1000*8));
            cdf_D_i = cdf_D_i + normpdf(i_s,image_size_kb,sqrt(image_size_variance))*cdf_TF_ftn_poisson_line(N, min(i,j), max(i,j), (delay_set-a_factor-m_factor*C_2*pl)/(C_1*i_s*1000*8));
%             fprintf('i_s = %i\n', i_s);
%             fprintf('input to cdf_TF = %f\n', (delay_set-a_factor-m_factor*C_2*pl)/(C_1*i_s));
%             cdf_D
        end
    end
%     fprintf('i = %i, zero_prob = %i\n', i, zero_prob');
    cdf_D = cdf_D/(N-zero_prob);
    cdf_D_i = cdf_D_i/(N-zero_prob);
%     cdf_D = cdf_D/(sqrt(image_size_variance)*4);
%     cdf_D_i = cdf_D_i/(sqrt(image_size_variance)*4);
%     cdf_D = cdf_D/(image_size_kb);
%     cdf_D_i = cdf_D_i/(image_size_kb);
    
    if sum(i==plot_set) > 0
        plot( delay_set, cdf_D_i, char(linespec(i==plot_set)) );
    end
end
% cdf_D = cdf_D/(N-2)
cdf_D

plot(delay_set, cdf_D, char(linespec(end)) );
xlabel('Delay', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);
legendTitles{1} = 'Analytical';

plot_exp_str = '';
if plot_exp == 1
    if from_scal_exp == 1
        EXP_DIR = sprintf('~/Dropbox/data_files/prob_qoi_scal/num_nodes_%i/image_size_%i/not_cont_traffic/flush_queues/line_net/query_rate_%i/timeliness_%i/mbs_%i/rate_div_%i/npr_var_%i/run_seed_1/', num_nodes, image_size_kb, exp_tness, exp_tness, max_buffer_size, rate_divisor, image_size_variance );
        exp_vals = csvread( sprintf('%sExpDelayCDF.csv', EXP_DIR) );
    else
        EXP_DIR = sprintf('/home/grads/str5004/Dropbox/data_files/prob_qoi_scal/vary_timeliness/num_nodes_%i/image_size_%i/channel_rate_2/PS_1500/sumsim_0.5/query_rate_%i/not_cont_traffic/flush_queues/line_net/mbs_%i/rate_div_%i/', num_nodes, image_size_kb, exp_tness, max_buffer_size, rate_divisor );
        exp_vals = csvread( sprintf('%sCompRatevsTimeliness.csv', EXP_DIR) );
    end
    timeliness_values = exp_vals(:,1);
    q_comp_values = exp_vals(:,2);
    plot(timeliness_values, q_comp_values, char(linespec(1)) );
    legendTitles{2} = 'Experimental';
    plot_exp_str = '_vsExp';
end

% legendTitles{1} = 'Node 1';
% legendTitles{2} = 'Node 25';
% legendTitles{3} = 'Avg all Nodes';
legend(cellstr(legendTitles), 'Location', 'Best', 'FontSize', legend_font_size);
% h_legend = legend('Avg all flows');
% set(h_legend,'FontSize',14);

% LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/exp_tness_%i/line_net/mbs_%i/rate_div_%i', N, image_size_kb, floor(timeliness), exp_tness, max_buffer_size, rate_divisor);
LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/query_rate_%i/line_net/mbs_%i/rate_div_%i/npr_var_%i', N, image_size_kb, exp_tness, max_buffer_size, rate_divisor, image_size_variance);
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR);
end
if plot_exp == 1
    saveas(gcf, sprintf('%s/all_flows_avg_delay_cdf%s%s.pdf', LOCAL_DIR, orig_str, plot_exp_str));
else
    saveas(gcf, sprintf('%s/all_flows_avg_delay_cdf.pdf', LOCAL_DIR));
end
csvwrite( sprintf('%s/cdf_values.csv', LOCAL_DIR), cdf_D );

