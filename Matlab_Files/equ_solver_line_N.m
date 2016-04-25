clear;
syms N

% W=1000000;
W=2*1000*1000;
C=3;
DF=1.5;

% image_size = 3*1000*8; % 3 KBytes
% image_size = 12000*8; % 12 KBytes
% image_size = 51000*8; % 51 KB
image_size = 18*8000; % 18 KBytes
% image_size = 360*1000*8; % 360 KBytes
% image_size = 1440*1000*8; % 1440 KBytes

% T=5:5:25;
T=10:10:50;
% T=125:25:200;
% T=125:25:300;
% T=600:100:1000;
% T=1000:500:3000;
q_comp_thresh=0.98;
num_images = 1:3;
% num_images =1:6;
P = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size/P; % number of packets
mhop_cf_vals = zeros(length(num_images),length(T));
scal_vals_w_tf_p = zeros(length(num_images),length(T));
scal_vals_full_pl = zeros(length(num_images),length(T));

output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/q_comp_thresh_%.2f', image_size/8000, W/1000000, P/8, q_comp_thresh);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );
init_guess_file_w_tf_p = fopen( sprintf('%s/initial_guesses_w_tf_p.csv', output_directory), 'w' );
init_guess_file_full_pl = fopen( sprintf('%s/initial_guesses_full_pl.csv', output_directory), 'w' );
anal_vals_file = fopen( sprintf('%s/analytical_scalability_qoi.csv', output_directory), 'w' );
anal_vals_w_tf_p_file = fopen( sprintf('%s/analytical_scalability_w_tf_p.csv', output_directory), 'w' );

for i=1:length(num_images)
    for j=1:length(T)
        
        B=num_images(i)*image_size;
        % multi-hop
        % orig:
        sol = solve( W*T(j) - ( C*((N-1)^2/(2*N-4))*B ) - (DF*((N/4.0)-1.0)*P) == 0, N );
        
        if double(sol(1)) >= 3
            mhop_cf_vals(i,j) = floor(real(double(sol(1))));
        else if double(sol(2)) >=3
            mhop_cf_vals(i,j) = floor(real(double(sol(2))));
            end
        end
        fprintf( init_guess_file, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), mhop_cf_vals(i,j) );
        
        % new (with TF_p)
        sol = solve( W*T(j) - ( C*((N-1)^2/(2*N-4))*B ) - (DF*(N-1)*P) == 0, N );
%          sol = solve( W*T(j) - ( C*((N-1)^2/(2*N-4))*B ) - (DF*(N-1)*P*N) == 0, N );
%         sol = solve( W*T(j) - ( C*((N-1)^2/(2*N-4))*B ) - (DF*(N-1)*P*P_n*0.5) == 0, N );
         
        if double(sol(1)) >= 3
            scal_vals_w_tf_p(i,j) = floor(real(double(sol(1))));
        else if double(sol(2)) >=3
            scal_vals_w_tf_p(i,j) = floor(real(double(sol(2))));
            end
        end
        fprintf( init_guess_file_w_tf_p, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), scal_vals_w_tf_p(i,j) );

%         % full path length
%         sol = solve( W*T(j) - ( C*((N-1)^2/(2*N-4))*B ) - (DF*(N-1.0)*P) == 0, N );
%         
%         if double(sol(1)) >= 3
%             scal_vals_full_pl(i,j) = floor(real(double(sol(1))));
%         else if double(sol(2)) >=3
%             scal_vals_full_pl(i,j) = floor(real(double(sol(2))));
%             end
%         end
%         fprintf( init_guess_file_full_pl, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), scal_vals_full_pl(i,j) );
    end
end
csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/q_comp_thresh_%.2f/analytical_scalability_qoi.csv', image_size/8000, W/1000000, P/8, q_comp_thresh), mhop_cf_vals );
csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/q_comp_thresh_%.2f/analytical_scalability_w_tf_p.csv', image_size/8000, W/1000000, P/8, q_comp_thresh), scal_vals_w_tf_p );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/q_comp_thresh_%.2f/analytical_scalability_full_pl.csv', image_size/8000, W/1000000, P/8, q_comp_thresh), scal_vals_full_pl );
mhop_cf_vals
scal_vals_w_tf_p
% scal_vals_full_pl
% plot(T, mhop_cf_vals(1,:), '-kx');
% hold on;
% plot(T, worst_PL(1,:), ':bo');
% legend('Avg. PL', 'Worst PL');
% plot(T, mhop_cf_vals(3,:), '-kx');
% plot(T, worst_PL(3,:), ':bo');
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop.csv', image_size/8000, W/1000000, P/8), mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), no_mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop_2.csv', image_size/8000, W/1000000, P/8), mhop_cf_vals );

