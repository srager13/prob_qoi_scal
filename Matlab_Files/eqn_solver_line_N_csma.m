clear;
avg_all_flows = 0;

W=2*1000*1000;
% image_size= 72000; % 9 KBytes
% image_size = 12000*8; % 12 KBytes
image_size = 18*8000; % 18 KBytes
% image_size = 120000; % 15 KB = 120,000 bits
% image_size = 400000; % 50 KB = 400,000 bits
T=20:10:40;
q_comp_thresh = 0.65:0.10:0.95;
num_images = 1:3;
% num_images =1:6;
% image_size_kb = 18;
image_size_kb = 36;
% image_size_kb = 360;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
DF = 0;
CF=1/0.64;

csma_vals = zeros(length(num_images),length(T), length(q_comp_thresh));
output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/line_net/', image_size_kb, W/1000000, P_s/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

init_guess_file = fopen( sprintf('%s/initial_guesses_csma.csv', output_directory), 'w' );
for i=1:length(num_images)
    for j=1:length(T)
        for q=1:length(q_comp_thresh)
            C_1 = (num_images(i)*I_s*CF)/W;
            C_2 = (P_s*DF)/W;
            N = 3;
            prob = 1.1;
            while prob > q_comp_thresh(q)
                N = N+1;
                if avg_all_flows == 1
                    prob = 0;
                    for x=1:N
                        for y=1:N
                            if x==y
                                continue;
                            end
                            pl = abs(x-y);
                            k = (W*T(j) - DF*P_s*pl)/(num_images(i)*I_s*CF);
    %                         prob = prob + binocdf( floor(k), floor(0.5*N^2), 1/N );
                            prob = prob + cdf_TF_ftn_2_line( N, x, y, k )*(1/(N-1));
    %                 fprintf( 'N = %i, T = %i, num_images = %i, k = %f, prob = %f\n', N, T(j), num_images(i), k, prob );
                        end
                    end
                    prob = prob/N;
                else
                    k = (W*T(j) - DF*P_s*(N/4-1))/(num_images(i)*I_s*CF);
    %                 k = (T(j)-C_2*(N-1))/C_1;
                    prob = binocdf( floor(k), floor(0.5*N^2), 1/N );
    %                 fprintf( 'N = %i, T = %i, num_images = %i, k = %f, prob = %f\n', N, T(j), num_images(i), k, prob );
                end
                if N > 1000
                    fprintf( 'N > 500.  Giving up on this one...\n' );
                    prob = 0.0;
                end
            end
            csma_vals(i,j,q) = N;
            fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), q_comp_thresh(q), csma_vals(i,j,q) );
            fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', N, T(j), num_images(i), q_comp_thresh(q) );
        end
    end
end
csma_vals
csvwrite( sprintf('%s/analytical_scalability_csma.csv', output_directory), csma_vals );
% for i=1:length(num_images)
%     for j=1:length(T)
%         
%         B=num_images(i)*image_size;
% 
%         % next attempt: add multi-hop, but without the CF in mhop delay
%         sol = solve( W - ( C*((N-1)^2/(2*N-4) + 1)*(B/T(j)) ) - (C*(N/4)*(P))/T(j) == 0, N );
%         if double(sol(1)) >= 3
%             csma_vals(i,j) = floor(real(double(sol(1))));
%         else if double(sol(2)) >=3
%             csma_vals(i,j) = floor(real(double(sol(2))));
%             end
%         end
%         
%         %if mod(num_images(i)/2.0, 1) == 0
%         %    fprintf( init_guess_file, '%i, %i, %i\n', num_images(i)/2.0, T(j), mhop_cf_vals(i,j) );
%         %else
%             fprintf( init_guess_file, '%.1f, %i, %i\n', num_images(i)/2.0, T(j), csma_vals(i,j) );
%         %end
%     end
% end

