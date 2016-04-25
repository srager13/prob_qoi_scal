clear;
clc;
syms N;

W=2*1000*1000;

T=15:10:45;
num_images = 1;
% num_images =1:6;
% image_size_kb = 48;
image_size_kb = 72;
% image_size_kb = 90;
% image_size_kb = 120;
image_size_variance = 1;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
CF = 5;
DF = 2.5;

scal_vals = zeros(length(num_images),length(T));

output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/grid_net/', image_size_kb, W/1000000, P_s/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end
init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );

i=1;
for j=1:length(T)

    sol_3 = solve( W*T(j) - CF*I_s*(sqrt(N)+3.5*sqrt(sqrt(N)-(1/(N-1)))) - P_s*DF*2*sqrt(N) == 0, N );
    if not(isempty(sol_3))
        if double(sol_3(4)) >= 9 
            scal_vals(i,j) = floor(sol_3(4));
        else
            scal_vals(i,j) = 0;
        end
    end
%     sol_3 = solve( W*T(j) - CF*I_s*(sqrt(N)) - P_s*DF*(N-1) == 0, N );
%     if not(isempty(sol_3))
%         if double(sol_3(1)) >= 9 
%             scal_vals(i,j) = floor(sol_3(1));
%         else
%             scal_vals(i,j) = 0;
%         end
%     end

    
    scal_vals(i,j) = floor(sqrt(scal_vals(i,j)))^2;
    fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), 1.00, scal_vals(i,j) );
    fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', scal_vals(i,j), T(j), num_images(i), 1.00 );
end

scal_vals
% scal_vals_w_pn
% plot(T, scal_vals_cf_vals(1,:), '-kx');
% hold on;
% plot(T, worst_PL(1,:), ':bo');
% legend('Avg. PL', 'Worst PL');
% plot(T, scal_vals_cf_vals(3,:), '-kx');
% plot(T, worst_PL(3,:), ':bo');
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_scal_vals.csv', image_size/8000, W/1000000, P/8), scal_vals_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), scal_vals_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_scal_vals_2.csv', image_size/8000, W/1000000, P/8), scal_vals_cf_vals );

