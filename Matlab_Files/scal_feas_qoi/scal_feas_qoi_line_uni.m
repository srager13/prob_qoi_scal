clear;

plot_3d = 1;

syms N;

W=2*1000000;
C=3;

channel_rate = 2000000; % 2 Mbps
T=1:2:51;

P_s = 1500*8;
IS = 12;
image_size = IS*8*1000;

ss_requ = csvread('SumSimRequirements_PSU_data_set.csv');

sum_sim = 1.0:0.2:35.0;
num_images = zeros(length(T),length(sum_sim));

for i=1:length(sum_sim)
    x = find( ss_requ(:,1) > sum_sim(i) );
    if not( isempty(x) )
        num_images(:,i) = ss_requ(x(1),2);
    end
end

output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i', IS, channel_rate/1000000, P_s/8);

if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end

max_num_nodes = zeros(size(num_images,2),length(T));
max_feasible_qoi = zeros(1,length(T));
max_num_images = zeros(1,length(T));
i = 1;
for i=1:size(num_images,2)
    for j=1:length(T)
        
        %B=num_images(i)*image_size;
        B=image_size;
        
        % including multihop considerations 
        sol_1 = solve( W*T(j) - C*(num_images(1,i))*B*(N/2 + 3*(sqrt(N/2))) - (1.5*C*(N-1)*P_s) == 0, N );
        
        if double(sol_1) >= 2
            max_num_nodes(i,j) = floor(real(double(sol_1)));
        end
        
        if max_num_nodes(i,j)-1 >= num_images(1,i)
            max_feasible_qoi(j) = ss_requ(ss_requ(:,2)==num_images(1,i),1);
            max_num_images(j) = num_images(1,i);
        end
%         if double(sol_1(1)) >= 9
%             mhop_cf(i,j) = floor(real(double(sol_1(1))));
%         else if double(sol_1(2)) >=9
%             mhop_cf(i,j) = floor(real(double(sol_1(2))));
%             end
%         end

%         init_guesses = floor(sqrt(mhop_cf)).^2;
%         fprintf( init_guess_file, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), init_guesses(i,j) );
    end
end
% max_feasible_qoi
% max_num_images

csvwrite( sprintf('./%s/scalably_feasible_qoi.csv', output_directory), max_num_nodes );

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

    saveas(gcf, sprintf('./image_size_%i_KB/channel_rate_%i/line_net/scal_feas_qoi_region_3d_plot.pdf', IS, channel_rate/1000000));
    savefig(sprintf('./image_size_%i_KB/channel_rate_%i/line_net/scal_feas_qoi_region_3d_plot.fig', IS, channel_rate/1000000));
end

if plot_3d == 0
    plot(T, max_feasible_qoi, '-sk');
    font_size=20;
    xlabel('Timeliness (S)', 'FontSize', font_size);
    ylabel('Max Feasible QoI', 'FontSize', font_size);

    saveas(gcf, sprintf('./image_size_%i_KB/channel_rate_%i/line_net/scal_feasible_reg_line_uni.pdf', IS, channel_rate/1000000));
end
