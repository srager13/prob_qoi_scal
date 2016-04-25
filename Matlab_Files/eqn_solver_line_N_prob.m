clear;
syms N

% W=1000000;
W=2*1000*1000;

% T=5:5:25;
% T=10:10:50;
T=125:25:200;
% T=125:25:300;
% T=600:100:1000;
% T=1000:500:3000;
q_comp_thresh=1.00;
num_images = 1:3;
% num_images =1:6;
k_req = 1;
% image_size_kb = 18;
image_size_kb = 360;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
CF = 3;
DF = 1.5;

C_1 = (k_req*I_s*CF)/W;
C_2 = (P_s*DF)/W;

mhop_cf_vals = zeros(length(num_images),length(T));
scal_vals_w_pn = zeros(length(num_images),length(T));
scal_vals_full_pl = zeros(length(num_images),length(T));

output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/line_net/PS_%i/q_comp_thresh_%.2f', image_size_kb, W/1000000, P_s/8, q_comp_thresh);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );
init_guess_file_w_pn = fopen( sprintf('%s/initial_guesses_w_P_n.csv', output_directory), 'w' );
init_guess_file_full_pl = fopen( sprintf('%s/initial_guesses_full_pl.csv', output_directory), 'w' );
anal_vals_file = fopen( sprintf('%s/analytical_scalability_qoi.csv', output_directory), 'w' );
anal_vals_w_pn_file = fopen( sprintf('%s/analytical_scalability_w_pn.csv', output_directory), 'w' );

for i=1:length(num_images)
    for j=1:length(T)
        
        B=num_images(i)*image_size_kb;
        
%         sol = solve( W*T(j) - ( C*((N-1)^2/(2*N-4))*B ) - (DF*(N-1.0)*P) == q_comp_thresh, N );
%         sol = solve( binopdf( floor((T(j)-C_2*N)/C_1), N*N*0.5, 1/N )*(1/N) == q_comp_thresh, N );
        k = (T(j)-C_2*N)/C_1;
        sol = solve( nchoosek(0.5*N^2, floor((T(j)-C_2*N)/C_1))*(1/N)^((T(j)-C_2*N)/C_1)*(1-1/N)^(0.5*N^2-((T(j)-C_2*N)/C_1))*(1/N) - q_comp_thresh == 0, N );
        
%         if double(sol(1)) >= 3
            scal_vals_full_pl(i,j) = floor(real(double(sol(1))));
%         else if double(sol(2)) >=3
%             scal_vals_full_pl(i,j) = floor(real(double(sol(2))));
%             end
%         end
        fprintf( init_guess_file, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), scal_vals_full_pl(i,j) );
    end
end
csvwrite( sprintf('./%s/analytical_scalability_qoi.csv', output_directory), mhop_cf_vals );
csvwrite( sprintf('./%s/analytical_scalability_w_pn.csv', output_directory), scal_vals_w_pn );
csvwrite( sprintf('./%s/analytical_scalability_full_pl.csv', output_directory), scal_vals_full_pl );
% mhop_cf_vals
% scal_vals_w_pn
scal_vals_full_pl
% plot(T, mhop_cf_vals(1,:), '-kx');
% hold on;
% plot(T, worst_PL(1,:), ':bo');
% legend('Avg. PL', 'Worst PL');
% plot(T, mhop_cf_vals(3,:), '-kx');
% plot(T, worst_PL(3,:), ':bo');
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop.csv', image_size/8000, W/1000000, P/8), mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), no_mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop_2.csv', image_size/8000, W/1000000, P/8), mhop_cf_vals );

