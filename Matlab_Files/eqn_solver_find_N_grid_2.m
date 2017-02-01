clear;
clc;
syms N;

W=2*1000*1000;

T=10:5:50;
num_images = 1;
% num_images =1:6;
% image_size_kb = 48;
image_size_kb = 60;
% image_size_kb = 72;
% image_size_kb = 90;
% image_size_kb = 120;
image_size_variance = 1;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
CF = 5;
DF = 2.5;
epsilon=0.001;

scal_vals = zeros(length(num_images),length(T));
scal_vals_2 = zeros(length(num_images),length(T));

output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/grid_net/', image_size_kb, W/1000000, P_s/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end
init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );
init_guess_file_2 = fopen( sprintf('%s/initial_guesses_2.csv', output_directory), 'w' );
% sol_index = [1,1,1,2];
% sol_index = [2,4,1,4,1,2,1,4,1];  % 48 1.0
% sol_index = [1,3,2,1,4,3,3,4,4];  % 48 1.1
% sol_index = [1,3,4,3,4,3,2,3,4];  % 48 1.2
% sol_index = [1,4,1,2,2,3,2,3,4];  % 60 1.0 3.0
% sol_index = [3,4,1,4,1,2,4,2,3];  % 60 1.0
% sol_index = [1,2,4,2,4,2,1,4,3];  % 60 1.1
% sol_index = [4,1,2,2,2,1,2,2,2];  % 60 1.2
% sol_index = [2,1,2,2,2,1,2,2,2];  % 72 1.0
% sol_index = [1,4,2,1,2,1,3,2,2];  % 72 1.1
% sol_index = [2,3,4,3,2,1,2,4,2];  % 90 1.0
% sol_index = [2,3,2,3,1,4,4,2,1];  % 90 1.1
% sol_index = [2,3,1,3,2,4,4,3,1];  % 90 1.2
i=1;
for j=1:length(T)

%     sol_3 = solve( W*T(j) - CF*1.0*I_s*( sqrt(N) + 3.5*sqrt(sqrt(N)*(1-(1/(N-1)))) ) - P_s*DF*2*sqrt(N) == 0, N );
    sol_3 = solve( W*T(j) - CF*1.0*I_s*( sqrt(N) + 4.0*sqrt(sqrt(N)) ) - P_s*DF*2*sqrt(N) == 0, N );
%     sol_1 = solve( W*T(j) - CF*1.0*I_s*( sqrt(N)-log(epsilon)/3+sqrt(log(epsilon)*log(epsilon)*(1/9)-log(epsilon)*sqrt(N)) ) - P_s*DF*2*sqrt(N) == 0, N ); % thm 2.4
    sol_1 = solve( W*T(j) - CF*1.0*I_s*( sqrt(N)*(1 - log(epsilon)/(2*sqrt(N)) + sqrt( log(epsilon)^2/(4*N) - (2*log(epsilon))/sqrt(N) ) ) ) - P_s*DF*2*sqrt(N) == 0, N ); 
%     sol_1 = solve( W*T(j) - CF*1.0*I_s*( sqrt(N)*(1+(-3*log(epsilon))/sqrt(N)) ) - P_s*DF*2*sqrt(N) == 0, N ); %
    
    if not(isempty(sol_3))
%         if double(sol_3(sol_index(j))) >= 9 
        if double(sol_3) >= 9 
%             scal_vals(i,j) = floor(real(double(sol_3(sol_index(j)))));
            scal_vals(i,j) = floor(real(double(sol_3)));
        else
            scal_vals(i,j) = 0;
        end
    end
    if not(isempty(sol_1))
%         if double(sol_3(sol_index(j))) >= 9 
        if double(sol_1) >= 9 
%             scal_vals(i,j) = floor(real(double(sol_3(sol_index(j)))));
            scal_vals_2(i,j) = floor(real(double(sol_1)));
        else
            scal_vals_2(i,j) = 0;
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
    scal_vals_2(i,j) = floor(sqrt(scal_vals_2(i,j)))^2;
    fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), 1.00, scal_vals(i,j) );
    fprintf( init_guess_file_2, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), 1.00, scal_vals_2(i,j) );
    fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', scal_vals(i,j), T(j), num_images(i), 1.00 );
    fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', scal_vals_2(i,j), T(j), num_images(i), 1.00 );
end

scal_vals
scal_vals_2
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

