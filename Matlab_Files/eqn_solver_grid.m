clear;

syms N

W=2000000;
C=5;

% image_size = 51000*8; % 51 KBytes
image_size = 48000*8; % 48 KBytes
% image_size = 800000; % 100Kbytes = 800,000 bits
% image_size = 111*8000; % 111KBytes
% image_size = 112500*8; % 112.5 KB converted to bits
channel_rate = 2000000;
P = 1500*8; % # Bytes coverted to bits

q_comp_thresh=0.98;

num_images = 1:5;
T=10:10:50;

if mod(image_size,8000) == 0
    output_directory = sprintf('./image_size_%i_KB/channel_rate_%i/grid_net/PS_%i/q_comp_thresh_%.2f', image_size/8000, channel_rate/1000000, P/8, q_comp_thresh);
else
    output_directory = sprintf('./image_size_%.1f_KB/channel_rate_%i/grid_net/PS_%i/q_comp_thresh_%.2f', image_size/8000, channel_rate/1000000, P/8, q_comp_thresh);
end
if ~exist(output_directory, 'dir')
  mkdir(output_directory);
end

init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );

mhop = zeros(length(num_images),length(T));
mhop_cf = zeros(length(num_images),length(T));
no_mhop = zeros(length(num_images),length(T));
full_pl = zeros(length(num_images),length(T));
i = 1;
for i=1:length(num_images)
    for j=1:length(T)
        
        B=num_images(i)*image_size;
        
        % not including multihop
        sol_3 = solve( W - (C*(sqrt(N)+1)*(B))/T(j) == 0, N );
        if not(isempty(sol_3))
            if double(sol_3(1)) >= 9 
                no_mhop(i,j) = floor(sol_3(1));
            else
                no_mhop(i,j) = 0;
            end
        end
        
        % including multihop considerations: + (2/3sqrt(N)*P)/T
        sol_1 = solve( W - ( (C*(sqrt(N)+1)*(B+(2/3)*sqrt(N)*P))/T(j) ) == 0, N );
        if not(isempty(sol_1))
            if double(sol_1(1)) >= 9 
                mhop(i,j) = floor(sol_1(1));
            else
                mhop(i,j) = 0;
            end
        end
        
        % including multihop considerations with CF adjustment
        sol_1 = solve( W - C*(sqrt(N)+1)*(B/T(j)) - ((1.5+2+3.5+4)*(1/4)*C*((2/3)*sqrt(N))*P)/T(j) == 0, N );
%         sol_1 = solve( W - C*(sqrt(N)+1)*(B/T(j)) - ((1.5+2+3.5+4)*(1/4)*((((sqrt(N)-1)/2 + 1)*((sqrt(N)-1)^2 - ((sqrt(N)-1)/2)*(sqrt(N)-2)))/(N-1))*P)/T(j) == 0, N );
        if double(sol_1) >= 9
            mhop_cf(i,j) = floor(real(double(sol_1)));
        end
%         if double(sol_1(1)) >= 9
%             mhop_cf(i,j) = floor(real(double(sol_1(1))));
%         else if double(sol_1(2)) >=9
%             mhop_cf(i,j) = floor(real(double(sol_1(2))));
%             end
%         end

        
        % full path length
        sol_3 = solve( W - (C*(sqrt(N)+1)*(B))/T(j) - ((1.5+2+3.5+4)*(1/4)*C*(3*sqrt(N))*P)/T(j) == 0, N );
        if not(isempty(sol_3))
            if double(sol_3(1)) >= 9 
                full_pl(i,j) = floor(sol_3(1));
            else
                full_pl(i,j) = 0;
            end
        end
        init_guesses = floor(sqrt(full_pl)).^2;
        fprintf( init_guess_file, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), init_guesses(i,j) );
    end
end
no_mhop;
no_mhop = floor(sqrt(no_mhop)).^2;
mhop = real(mhop);
mhop = floor(sqrt(mhop)).^2;

mhop_cf = floor(sqrt(mhop_cf)).^2;
mhop_cf

full_pl = floor(sqrt(full_pl)).^2;
full_pl

csvwrite( sprintf('./%s/analytical_scalability_mhop.csv', output_directory), mhop );
csvwrite( sprintf('./%s/analytical_scalability_mhop_2.csv', output_directory), mhop_cf );
% csvwrite( sprintf('./%s/analytical_scalability.csv', output_directory), no_mhop );
csvwrite( sprintf('./%s/analytical_scalability.csv', output_directory), full_pl );