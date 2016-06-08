clear;

plot_color = 1;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

ss_plot_index = [1];
ss_labels = [0.5, 1.0, 1.5];
tness_plot_index = [1,2,3];
topology = 'line';


% image_size = [36, 48, 90]; % in KB
% image_size = [36, 48, 72];
% image_size = [18, 36, 72];
image_size = 48;
packet_size = 1500; % in Bytes
channel_rate = 2; %in Mbps
plot_perc_diff = 1;
small_queues = 0;

hold on;
for h=1:length(image_size)
    directory = sprintf( './scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/line_net', image_size(h), channel_rate, packet_size );
    values_1 = csvread( sprintf('%s/Scalability.csv', directory) );
%     values_2 = csvread( sprintf('%s/initial_guesses.csv', directory) );
    values_2 = csvread( sprintf('%s/initial_guesses_max.csv', directory) );

    sum_sim_values = unique(values_1(:,1));
    timeliness_values = unique(values_1(:,2));
    q_comp_thresh_values = unique(values_1(:,3));

    % GET EXPERIMENTAL VALUES
    max_scal_values = zeros(length(sum_sim_values),length(timeliness_values), length(q_comp_thresh_values));
    for x=1:length(values_1)
        ss_index = values_1(x,1)==sum_sim_values;
        t_index = values_1(x,2)==timeliness_values;
        thresh_index = values_1(x,3)==q_comp_thresh_values;
        max_scal_values( ss_index, t_index, thresh_index ) = values_1(x,4);
    end
    a_values = zeros(length(sum_sim_values),length(timeliness_values), length(q_comp_thresh_values));
    for x=1:length(values_2)
        ss_index = values_2(x,1)==sum_sim_values;
        t_index = values_2(x,2)==timeliness_values;
        thresh_index = values_2(x,3)==q_comp_thresh_values;
        a_values( ss_index, t_index, thresh_index ) = values_2(x,4);
    end

    x = 1;
    for i=ss_plot_index
            y=zeros(1,length(timeliness_values));
            for k=1:length(timeliness_values)
                y(k) = a_values(i,k,1);
            end
            plot(timeliness_values', y, '+-b', 'MarkerSize', marker_size);
            y=zeros(1,length(timeliness_values));
            for k=1:length(timeliness_values)
                y(k) = max_scal_values(i,k,1);
            end
            plot(timeliness_values', y, 'x--r', 'MarkerSize', marker_size);
    %         plot(q_comp_thresh_values', a_values(i,j,:), '+b', 'MarkerSize', marker_size);
    %         plot(q_comp_thresh_values', max_scal_values(i,j,:), 'xr', 'MarkerSize', marker_size); 
    end
end
set(gca, 'FontSize', axes_font_size);

y_offsets = [0.56, 0.37, 0.18];
for i=1:length(image_size)
    ymax = get(gca, 'ylim');

    x1 = 0.75;
    y1 = (max_scal_values(1,2,1)-ymax(1))/(ymax(2)-ymax(1)) + y_offsets(i);

    str = sprintf('SS=%s', num2str(ss_labels(i)) );
    annotation('textbox', [x1,y1,0.1,0.1],'String',str, 'FontSize', 15, 'BackgroundColor', 'w' );
end

xlabel('Timeliness', 'FontSize', font_size);
ylabel('Maximum Number of Nodes', 'FontSize', font_size);
legendTitles{1} = 'Analytical';
legendTitles{2} = 'Simulation';
% legend(cellstr(legendTitles), 'Location', 'Best', 'FontSize', legend_font_size);
legend(cellstr(legendTitles), 'Location', 'NorthWest', 'FontSize', legend_font_size);

SAVE_DIR = sprintf('./scal_predictions');
if plot_color == 1
    saveas(gcf, sprintf('%s/line_scal_anal_vs_sim_color.pdf', SAVE_DIR));
    savefig(sprintf('%s/line_scal_anal_vs_sim_color.fig', SAVE_DIR));
end


