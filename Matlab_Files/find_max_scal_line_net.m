clear;

syms N

W=2000000; % channel rate in b/s
C=3; % contention factor
DF=1.5; % delay factor
image_size = 12000*8; % 12 KBytes
P = 1500*8; % 1500 Bytes coverted to bits

num_images = 1:6;
T=10:10:50;

mhop_cf_vals = zeros(length(num_images),length(T));
worst_PL = zeros(length(num_images),length(T));

output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i', image_size/8000, W/1000000, P/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );

for i=1:length(num_images)
    for j=1:length(T)
        
        B=num_images(i)*image_size;
        % multi-hop
%         sol = solve( W - ( DF*C*((N-1)^2/(2*N-4) + 1)*(B/T(j)) - ((N/4)*(P))/T(j) ) == 0, N );
        sol = solve( W - ( C*((N-1)^2/(2*N-4) + 1)*(B/T(j)) ) - (C*DF*(N/4)*(P))/T(j) == 0, N );
        if double(sol(1)) >= 3
            mhop_cf_vals(i,j) = floor(real(double(sol(1))));
        else if double(sol(2)) >=3
            mhop_cf_vals(i,j) = floor(real(double(sol(2))));
            end
        end
        
        % worst case path length
        sol = solve( W - ( C*((N-1)^2/(2*N-4)+0.02*N+2)*(B/T(j)) ) - (C*1.5*0.25*N*P)/T(j) == 0, N );
        if double(sol(1)) >= 3
            worst_PL(i,j) = floor(real(double(sol(1))));
        else if double(sol(2)) >=3
            worst_PL(i,j) = floor(real(double(sol(2))));
            end
        end
        
        
%         fprintf( init_guess_file, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), mhop_cf_vals(i,j) );
    end
end
% mhop_cf_vals
% worst_PL
mhop_cf_vals - worst_PL
plot(T, mhop_cf_vals(1,:), '-kx');
hold on;
plot(T, worst_PL(1,:), ':bo');
legend('Avg. PL', 'Worst PL');
plot(T, mhop_cf_vals(3,:), '-kx');
plot(T, worst_PL(3,:), ':bo');
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop.csv', image_size/8000, W/1000000, P/8), mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), no_mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop_2.csv', image_size/8000, W/1000000, P/8), mhop_cf_vals );

