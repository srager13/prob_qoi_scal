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
image_size_kb = [48, 90, 180];
image_size_variance = [120, 120, 250];
exp_tness=[17, 30, 60];
num_nodes = 49;
timeliness = [17, 30, 60];
% max_buffer_size=500;
max_buffer_size=1000;
% rate_divisor=3;
rate_divisor=7;
ss_labels=[0.5, 1.0, 1.5];

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
    cdf_D = zeros(1, length(delay_set));
    max_cdf = zeros(1, length(delay_set));
    hold on;
    LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/query_rate_%i/grid_net/mbs_%i/rate_div_%i/npr_var_%i/', N, image_size_kb(x), exp_tness(x), max_buffer_size, rate_divisor, image_size_variance(x));
    if exist( sprintf('%s/cdf_values.csv', LOCAL_DIR), 'file') && cdf_from_file == 1
        cdf_D = csvread( sprintf('%s/cdf_values.csv', LOCAL_DIR) );
    else
        for i=1:N
            cdf_D_i = zeros(1, length(delay_set));
            zero_prob = 0;
            for j=1:N
                if i == j
                    continue;
                end
                pl = abs(i-j);

                if cdf_TF_ftn_grid(N, min(i,j), max(i,j), (delay_set-C_2*pl)/(C_1*I_s)) == 0
                    zero_prob = zero_prob + 1;
    %                 fprintf('zero_prob: N = %i, i = %i, j = %i\n', N, i, j);
                end
    %             for i_s=image_size_kb(x)-sqrt(image_size_variance(x))*2:image_size_kb(x)+sqrt(image_size_variance(x))*2
                for i_s=1:image_size_kb(x)*2
                    cdf_D = cdf_D + normpdf(i_s,image_size_kb(x),sqrt(image_size_variance(x))/10)*cdf_TF_ftn_grid(N, min(i,j), max(i,j), (delay_set-C_2*pl)/(C_1*i_s*1000*8));
    %                 cdf_D = cdf_D + normpdf(i_s,image_size_kb(x),sqrt(image_size_variance(x)))*cdf_TF_ftn_grid(N, min(i,j), max(i,j), (delay_set-C_2*pl)/(C_1*i_s*1000*8));
                    cdf_D_i = cdf_D_i + normpdf(i_s,image_size_kb(x),sqrt(image_size_variance(x)))*cdf_TF_ftn_grid(N, min(i,j), max(i,j), (delay_set-C_2*pl)/(C_1*i_s*1000*8));
        %             fprintf('i_s = %i\n', i_s);
        %             fprintf('input to cdf_TF = %f\n', (delay_set-C_2*pl)/(C_1*i_s));
        %             cdf_D
                end
            end
    %         fprintf('i = %i, zero_prob = %i\n', i, zero_prob');
    %         zero_prob = 0;
            cdf_D = cdf_D/(N-zero_prob);
            cdf_D_i = cdf_D_i/(N-zero_prob);

            if sum(i==plot_set) > 0
                plot( delay_set, cdf_D_i, char(linespec(i==plot_set)), 'MarkerSize', marker_size );
            end
        end
    end
    % cdf_D = cdf_D/(N-2)
    cdf_D

    plot(delay_set, cdf_D, char(linespec(end)), 'MarkerSize', marker_size );
    xlabel('Delay', 'FontSize', axes_font_size);
    ylabel('CDF', 'FontSize', axes_font_size);
    legendTitles{1} = 'Analytical';

    plot_exp_str = '';
    if plot_exp == 1
        if from_scal_exp == 1
            EXP_DIR = sprintf('~/Dropbox/data_files/prob_qoi_scal/num_nodes_%i/image_size_%i/not_cont_traffic/flush_queues/grid_net/query_rate_%i/timeliness_%i/mbs_%i/rate_div_%i/npr_var_%i/run_seed_1/', num_nodes, image_size_kb(x), exp_tness(x), exp_tness(x), max_buffer_size, rate_divisor, image_size_variance(x) );
            exp_vals = csvread( sprintf('%sExpDelayCDF.csv', EXP_DIR) );
        else
            EXP_DIR = sprintf('~/Dropbox/data_files/prob_qoi_scal/vary_timeliness/num_nodes_%i/image_size_%i/channel_rate_2/PS_1500/sumsim_0.5/query_rate_%i/not_cont_traffic/flush_queues/grid_net/mbs_%i/rate_div_%i/npr_var_%i/', num_nodes, image_size_kb(x), exp_tness(x), max_buffer_size, rate_divisor, image_size_variance(x) );
            exp_vals = csvread( sprintf('%sCompRatevsTimeliness.csv', EXP_DIR) );
        end
        timeliness_values = exp_vals(:,1);
        q_comp_values = exp_vals(:,2);
        plot(timeliness_values, q_comp_values, char(linespec(1)), 'MarkerSize', marker_size  );
        legendTitles{2} = 'Simulationmore ';
        plot_exp_str = '_vsExp';
    end
end

ylim([0.4, 1.0]);
x_offsets = [0.15, 0.27, 0.42];
y_offsets = [0.64, 0.5, 0.36];
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
saveas(gcf, sprintf('%s/delay_cdf_grid.pdf', SAVE_DIR));

