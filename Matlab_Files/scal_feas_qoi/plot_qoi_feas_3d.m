% need to run scal_feas_qoi_grid_flood first to generate data
line_net = 0;
grid_net = 1;
W=2*1000000;
channel_rate = 2000000; % 2 Mbps
T=10:1:50;
P_s = 1500*8;
IS = 18;
image_size = IS*8*1000;
ss_requ = csvread('SumSimRequirements_PSU_data_set.csv');
if line_net == 1
    output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i', IS, channel_rate/1000000, P_s/8);
else
    output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/PS_%i', IS, channel_rate/1000000, P_s/8);
end
max_num_nodes = csvread(sprintf('./%s/scalably_feasible_qoi_corner_sink.csv', output_directory));

sum_sim = 1.0:1:35.0;
num_images = zeros(length(T),length(sum_sim));
for i=1:length(sum_sim)
    x = find( ss_requ(:,1) > sum_sim(i) );
    if not( isempty(x) )
        num_images(:,i) = ss_requ(x(1),2);
    end
end

start = 1;
font_size=20;
h = mesh( T, sum_sim(start:end), max_num_nodes(start:end,:), 'FaceColor', 'b', 'FaceAlpha', 0.25);
hold on;
mesh( T, sum_sim(start:end), num_images(:,start:end)', 'Facecolor', 'y', 'FaceAlpha', 0.5);
xlabel('Timeliness', 'FontSize', font_size);
ylabel('Sum Similarity', 'FontSize', font_size);
zlabel('Number of Nodes', 'FontSize', font_size);

zdiff = max_num_nodes-num_images';
C = contours(T, sum_sim, zdiff, [0 0]);
% Extract the x- and y-locations from the contour matrix C.
xL = C(1, 2:end);
yL = C(2, 2:end);
% Interpolate on the first surface to find z-locations for the intersection
% line.
zL = interp2(T, sum_sim(start:end), max_num_nodes(start:end,:), xL, yL);
% Visualize the line.
line(xL, yL, zL, 'Color', 'r', 'LineWidth', 4);
ylim([0 15]);
zlim([0 60]);
legend({'N_{max}', 'k_{req}'}, 'FontSize', 14, 'Location', 'North');

%rotate(h,[0 0 1], 50);
if line_net == 1
    saveas(gcf, sprintf('./image_size_%i_KB/channel_rate_%i/line_net/scal_feas_qoi_region_3d_plot.pdf', IS, channel_rate/1000000));
    savefig(sprintf('./image_size_%i_KB/channel_rate_%i/line_net/scal_feas_qoi_region_3d_plot.fig', IS, channel_rate/1000000));
else
    saveas(gcf, sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/scal_feas_qoi_region_3d_plot.pdf', IS, channel_rate/1000000));
    savefig(sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/scal_feas_qoi_region_3d_plot.fig', IS, channel_rate/1000000));
end

