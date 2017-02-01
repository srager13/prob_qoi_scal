clear;
clc;
syms N;

W=2*1000*1000;

T=10:5:50;
% T=15:10:45;
num_images = 1;
% num_images =1:6;
% image_size_kb = 18;
% image_size_kb = 36;
% image_size_kb = 48;
image_size_kb = 72;
% image_size_kb = 90;
% image_size_kb = 120;
image_size_variance = 1;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
CF = 3;
DF = 1.5;
epsilon=0.0001;

scal_vals = zeros(length(num_images),length(T));
scal_vals_max = zeros(length(num_images),length(T));

output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/line_net/', image_size_kb, W/1000000, P_s/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end
init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );
init_guess_file_2 = fopen( sprintf('%s/initial_guesses_max.csv', output_directory), 'w' );

sol_index=1;
i=1;
for j=1:length(T)

%     sol_3 = solve( W*T(j) - CF*I_s*( (2*((N/2)-1)^2)/(N-1) +3.5*sqrt(((2*((N/2)-1)^2)/(N-1))*(1-(1/(N-1)))) ) - P_s*DF*(N-1) == 0, N, 'ReturnConditions', true );
%     sol_3 = solve( W*T(j) - CF*1.2*I_s*( (N-1)/2 +3.5*sqrt((N/2)*(1-(1/(N-1)))) ) - P_s*DF*(N-1) == 0, N );
    sol_3 = solve( W*T(j) - CF*1.0*I_s*( (N-1)/2 + 3.5*sqrt((N-1)/2) ) - P_s*DF*(N-1) == 0, N );
%     sol_1 = solve( W*T(j) - CF*1.0*I_s*( (N-1)/2 - log(epsilon)/3+sqrt(log(epsilon)*log(epsilon)*(1/9)-log(epsilon)*(N-1)) ) - P_s*DF*(N-1) == 0, N );
    sol_1 = solve( W*T(j) - CF*1.0*I_s*( ((N-1)/2)*(1 - log(epsilon)/(N-1) + sqrt( log(epsilon)^2/((N-1)*(N-1)) - (4*log(epsilon))/(N-1) ) ) ) - P_s*DF*(N-1) == 0, N );
%     sol_1 = solve( W*T(j) - CF*1.2*I_s*( 0.5*(N-1)*(1+(-3*log(epsilon)/(0.5*(N-1)))) ) - P_s*DF*(N-1) == 0, N );
%     sol_1 = solve( W*T(j) - CF*1.0*I_s*( 0.5*(N-1) + sqrt(0.5*(N-1)*(1/epsilon)) ) - P_s*DF*(N-1) == 0, N );
    if not(isempty(sol_3))
        if double(sol_3(sol_index)) >= 3 
%         if sol_3(1) >= 3 
            scal_vals(i,j) = floor(real(sol_3(sol_index)));
            scal_vals_max(i,j) = floor(real(double(sol_1(1))));
        else
            scal_vals(i,j) = 0;
            scal_vals_max(i,j) = 0;
        end
    end

%     scal_vals(i,j) = floor(sqrt(scal_vals(i,j)))^2;
    fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), 1.00, scal_vals(i,j) );
    fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', scal_vals(i,j), T(j), num_images(i), 1.00 );
    
    fprintf( init_guess_file_2, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), 1.00, scal_vals_max(i,j) );
    fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', scal_vals_max(i,j), T(j), num_images(i), 1.00 );
end

scal_vals
scal_vals_max
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

