clear;
clc;
figure;
font_size = 26;
legend_font_size = 22;
axes_font_size = 20;
marker_size = 11;
orig=1;
plot_exp=1;
from_scal_exp=1;
cdf_from_file=1;
num_nodes = 40;
% exp_tness=[18, 45, 85];
% timeliness = [18, 45, 85];
% image_size_kb = [36, 90, 180];
% image_size_variance = [48, 45, 250];
exp_tness=[18, 24, 45];
timeliness = [18, 24, 45];
image_size_kb = [36, 48, 90];
image_size_variance = [48, 64, 45];
max_buffer_size=1000;
rate_divisor=18;
ss_labels=[0.5, 1.0, 1.5, 2.0];

N = num_nodes;
k_req = 1;
j_set = 1:num_nodes;
i_set = 1:num_nodes;
% plot_set = [1,ceil(N/2)];
plot_set = [];
colors = ['g','b','r'];
linespec = {'xb', '+g', 'oc', '*r'};

for x=1:length(image_size_kb)
    I_s = image_size_kb(x)*1000*8;
    B=k_req*I_s/8000;
    CF = 5;
    DF = 2.5;
    channel_rate=2;
    W = 2*1000000;
    packet_size=1500;
    P_s = 1500*8;

    delay_set = 1.0:1.0:timeliness(x);
    % delay_set=1.0:5.0;
    C_1 = (k_req*CF)/W;
    C_2 = (P_s*DF)/W;

    orig_str = '';
    max_cdf = zeros(1, length(delay_set));
    hold on;
    LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/query_rate_%i/line_net/mbs_%i/rate_div_%i/npr_var_%i/', N, image_size_kb(x), exp_tness(x), max_buffer_size, rate_divisor, image_size_variance(x));

    cdf_D = csvread( sprintf('%s/cdf_values.csv', LOCAL_DIR) );
    

    plot(delay_set, cdf_D, char(linespec(end)), 'MarkerSize', marker_size );
    xlabel('Delay', 'FontSize',axes_font_size);
    ylabel('CDF', 'FontSize',axes_font_size);
    legendTitles{1} = 'Analytical';

    plot_exp_str = '';
    if plot_exp == 1
        if from_scal_exp == 1
            EXP_DIR = sprintf('~/Dropbox/data_files/prob_qoi_scal/num_nodes_%i/image_size_%i/not_cont_traffic/flush_queues/line_net/query_rate_%i/timeliness_%i/mbs_%i/rate_div_%i/npr_var_%i/run_seed_1/', num_nodes, image_size_kb(x), exp_tness(x), exp_tness(x), max_buffer_size, rate_divisor, image_size_variance(x) );
            exp_vals = csvread( sprintf('%sExpDelayCDF.csv', EXP_DIR) );
        else
            EXP_DIR = sprintf('~/Dropbox/data_files/prob_qoi_scal/vary_timeliness/num_nodes_%i/image_size_%i/channel_rate_2/PS_1500/sumsim_0.5/query_rate_%i/not_cont_traffic/flush_queues/line_net/mbs_%i/rate_div_%i/npr_var_%i/', num_nodes, image_size_kb(x), exp_tness(x), max_buffer_size, rate_divisor, image_size_variance(x) );
            exp_vals = csvread( sprintf('%sCompRatevsTimeliness.csv', EXP_DIR) );
        end
        timeliness_values = exp_vals(:,1);
        q_comp_values = exp_vals(:,2);
        plot(timeliness_values, q_comp_values, char(linespec(1)), 'MarkerSize', marker_size );
        legendTitles{2} = 'Simulation';
        plot_exp_str = '_vsExp';
    end
end

ylim([0.4, 1.0]);
x_offsets = [0.15, 0.27, 0.42, 0.5];
y_offsets = [0.64, 0.5, 0.36, 0.5];
for i=1:length(image_size_kb)
    ymax = get(gca, 'ylim');

%     x1 = (max_scal_values(1,2,1)-ymax(1))/(ymax(2)-ymax(1)) + y_offsets(i);
    x1 = x_offsets(i);
    y1 = y_offsets(i);

    str = sprintf('SS=%s', num2str(ss_labels(i)) );
    annotation('textbox', [x1,y1,0.1,0.1],'String',str, 'FontSize', 15, 'BackgroundColor', 'w' );
end

% legendTitles{1} = 'Node 1';
% legendTitles{2} = 'Node 25';
% legendTitles{3} = 'Avg all Nodes';
legend(cellstr(legendTitles), 'Location', 'SouthEast', 'FontSize', legend_font_size);
% h_legend = legend('Avg all flows');
% set(h_legend,'FontSize',14);

SAVE_DIR = sprintf('./num_nodes_%i/', N);
saveas(gcf, sprintf('%s/delay_cdf_line.pdf', SAVE_DIR));

