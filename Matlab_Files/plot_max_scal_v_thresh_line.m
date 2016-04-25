clear;

plot_color = 1;
font_size = 26;
legend_font_size = 22;
axes_font_size = 13;
marker_size = 15;

ss_plot_index = [1];
tness_plot_index = [1,2,3];
topology = 'line';

sat_all_queries = '';
% sat_all_queries = '_satAllQueries';
% avg_all_flows = '';
avg_all_flows = '_avg_all_flows';

% image_size = 12; % in KB
image_size = 18; % in KB
% image_size = 360; % in KB

% packet_size = 250; % in Bytes
packet_size = 1500; % in Bytes

% channel_rate = 1; %in Mbps
channel_rate = 2; %in Mbps
plot_perc_diff = 1;
small_queues = 0;

directory = sprintf( './scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/line_net', image_size, channel_rate, packet_size );
values_1 = csvread( sprintf('%s/Scalability%s.csv', directory, sat_all_queries) );
values_2 = csvread( sprintf('%s/initial_guesses%s.csv', directory, avg_all_flows) );

% values_1 = sortrows(values_1);

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

hold on;
x = 1;
for i=ss_plot_index
    for j=tness_plot_index
        y=zeros(1,length(q_comp_thresh_values));
        for k=1:length(q_comp_thresh_values)
            y(k) = a_values(i,j,k);
        end
        plot(q_comp_thresh_values', y, '+-b', 'MarkerSize', marker_size);
        y=zeros(1,length(q_comp_thresh_values));
        for k=1:length(q_comp_thresh_values)
            y(k) = max_scal_values(i,j,k);
        end
        plot(q_comp_thresh_values', y, 'x--r', 'MarkerSize', marker_size);
%         plot(q_comp_thresh_values', a_values(i,j,:), '+b', 'MarkerSize', marker_size);
%         plot(q_comp_thresh_values', max_scal_values(i,j,:), 'xr', 'MarkerSize', marker_size); 
    end
end
set(gca, 'FontSize', axes_font_size);

for i=ss_plot_index
    for j=tness_plot_index
        ymax = get(gca, 'ylim');

        x1 = 0.67;
        y1 = (max_scal_values(i,j,3)-ymax(1))/(ymax(2)-ymax(1)) - 0.03*j;
        
        str = sprintf('SS=%s,T=%s', num2str(sum_sim_values(i)), num2str(timeliness_values(j)) );
        annotation('textbox', [x1,y1,0.1,0.1],'String',str, 'FontSize', 15, 'BackgroundColor', 'w' );
    end
end

xlabel('Completion Percentage', 'FontSize', font_size);
ylabel('Maximum Number of Nodes', 'FontSize', font_size);
legendTitles{1} = 'Analytical';
legendTitles{2} = 'Simulation';
% legendTitles{3} = 'Simulation';
% legendTitles{3} = 'Analytical w/ PN';
legend(cellstr(legendTitles), 'Location', 'Best', 'FontSize', legend_font_size);

if plot_color == 1
    saveas(gcf, sprintf('%s/line_scal_anal_vs_sim_color_ss_%.1f%s.pdf', directory, sum_sim_values(ss_plot_index), avg_all_flows));
    savefig(sprintf('%s/line_scal_anal_vs_sim_color_ss_%.1f%s.fig', directory, sum_sim_values(ss_plot_index), avg_all_flows));
end


