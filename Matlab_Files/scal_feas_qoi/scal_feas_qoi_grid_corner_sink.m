clear;

plot_3d = 1;
plot_2d = 1;
read_from_file = 1;

syms N

W=2*1000000;
C=5;

channel_rate = 2000000; % 2 Mbps

P_s = 1500*8;
IS = 18;
image_size = IS*8*1000;

ss_requ = csvread('SumSimRequirements_PSU_data_set.csv');

T=10:1:50;
sum_sim = 1.0:1:35.0;
num_images = zeros(length(T),length(sum_sim));

for i=1:length(sum_sim)
    x = find( ss_requ(:,1) > sum_sim(i) );
    if not( isempty(x) )
        num_images(:,i) = ss_requ(x(1),2);
    end
end

output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/PS_%i', IS, channel_rate/1000000, P_s/8);

if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end

max_num_nodes = zeros(size(num_images,2),length(T));
max_feasible_qoi = zeros(1,length(T));
max_num_images = zeros(1,length(T));

if read_from_file == 0
    i = 1;
    for i=1:size(num_images,2)
        for j=1:length(T)

            %B=num_images(i)*image_size;
            B=image_size;

            % including multihop considerations 
            sol_1 = solve( W*T(j) - C*(0.5*(N-1)*num_images(1,i))*B - (2.5*C*(2*sqrt(N))*P_s) == 0, N );

            if double(sol_1) >= 9
                max_num_nodes(i,j) = floor(real(double(sol_1)));
            end

            if max_num_nodes(i,j)-1 >= num_images(1,i)
                max_feasible_qoi(j) = ss_requ(ss_requ(:,2)==num_images(1,i),1);
                max_num_images(j) = num_images(1,i);
            end
        end
    end
    csvwrite( sprintf('./%s/scalably_feasible_qoi_corner_sink.csv', output_directory), max_num_nodes );
else
    max_num_nodes = csvread( sprintf('./%s/scalably_feasible_qoi_corner_sink.csv', output_directory) );
    i = 1;
    for i=1:size(num_images,2)
        for j=1:length(T)

            B=image_size;

            if max_num_nodes(i,j)-1 >= num_images(1,i)
                max_feasible_qoi(j) = ss_requ(ss_requ(:,2)==num_images(1,i),1);
                max_num_images(j) = num_images(1,i);
            end
        end
    end
end

if plot_3d == 1 
    mesh( T, sum_sim, max_num_nodes, 'FaceColor', 'b');
    hold on;
    mesh( T, sum_sim, num_images', 'Facecolor', 'y', 'FaceAlpha', 0.5);
    font_size = 20;
    xlabel('Timeliness', 'FontSize', font_size);
    ylabel('Sum Similarity', 'FontSize', font_size);
    zlabel('Max Scalability', 'FontSize', font_size);

    zdiff = max_num_nodes-num_images';
    C = contours(T, sum_sim, zdiff, [0 0]);
    % Extract the x- and y-locations from the contour matrix C.
    xL = C(1, 2:end);
    yL = C(2, 2:end);
    % Interpolate on the first surface to find z-locations for the intersection
    % line.
    zL = interp2(T, sum_sim, max_num_nodes, xL, yL);
    % Visualize the line.
    line(xL, yL, zL, 'Color', 'k', 'LineWidth', 4);
    zlim([0 200]);
    legend('N_{max}', 'k_{req}');

    saveas(gcf, sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/scal_feas_qoi_grid_corner_sink_3d_plot.pdf', IS, channel_rate/1000000));
    savefig(sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/scal_feas_qoi_grid_corner_sink_3d_plot.fig', IS, channel_rate/1000000));
end

if plot_2d == 1
%     plot(T, max_feasible_qoi, '-sk');
    a = area(xL, yL);
    a.FaceColor = [0 0 0];
    font_size=20;
    xlabel('Timeliness (S)', 'FontSize', font_size);
    ylabel('Max Feasible Completeness (Sum Sim.)', 'FontSize', font_size);

    saveas(gcf, sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/scal_feas_qoi_grid_corner_sink_2d.pdf', IS, channel_rate/1000000));
    savefig(sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/scal_feas_qoi_grid_corner_sink_2d.fig', IS, channel_rate/1000000));
end
