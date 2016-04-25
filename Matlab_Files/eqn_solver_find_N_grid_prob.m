clear;

avg_all_flows = 1;

% W=1000000;
W=2*1000*1000;

% T=5:5:25;
T=15:10:45;
% T=15:10:55;
% q_comp_thresh = 0.65:0.10:0.95;
q_comp_thresh = 0.999999;
num_images = 1;
% num_images =1:6;
% image_size_kb = 48;
% image_size_kb = 54;
image_size_kb = 90;
% image_size_kb = 120;
image_size_variance = 1;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
CF = 5;
DF = 2.5;

scal_vals = zeros(length(num_images),length(T), length(q_comp_thresh));

output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/grid_net/', image_size_kb, W/1000000, P_s/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

if avg_all_flows == 1
    init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );
else
    init_guess_file = fopen( sprintf('%s/initial_guesses_avg_all_flows.csv', output_directory), 'w' );
end

last_N = 2;
for i=1:length(num_images)
    for j=1:length(T)
        for q=1:length(q_comp_thresh)
            C_1 = (num_images(i)*CF)/W;
            C_2 = (P_s*DF)/W;
            rt_N = last_N;
            prob = 1.1;
            while prob > q_comp_thresh(q)
                rt_N = rt_N+1;
                N = rt_N^2;
                prob = 0;
                for x=1:N
                    zero_prob = 0;
                    for y=1:N
                        if x==y
                            continue;
                        end        
%                           sol_1 = solve( W - ( (C*(sqrt(N)+1)*(B+(2/3)*sqrt(N)*P))/T(j) ) == 0, N );
                        pl = abs(mod(x-1,sqrt(N))-mod(y-1,sqrt(N))) + abs(floor((x-1)/sqrt(N))-floor((y-1)/sqrt(N)));
                        k = (W*T(j) - DF*P_s*pl)/(num_images(i)*I_s*CF);
%                         prob = prob + binocdf( floor(k), floor(0.5*N^2), 1/N );
%                         prob = prob + cdf_TF_ftn_grid( N, x, y, k )*(1/(N-1));
%                 fprintf( 'N = %i, T = %i, num_images = %i, k = %f, prob = %f\n', N, T(j), num_images(i), k, prob );

                        if cdf_TF_ftn_grid(N, min(x,y), max(x,y), (T(j)-C_2*pl)/(C_1*I_s)) == 0
%                             fprintf('zero prob = %i: N = %i, x = %i, y = %i\n', zero_prob, N, x, y);
                            zero_prob = zero_prob + 1;
                        end
                        for i_s=1:image_size_kb*2
                            prob = prob + normpdf(i_s,image_size_kb,sqrt(image_size_variance))*cdf_TF_ftn_grid(N, min(x,y), max(x,y), (T(j)-C_2*pl)/(C_1*i_s*1000*8));
                        end
                    end
                    prob = prob/(N-zero_prob);
                end
                fprintf( 'N = %i, T = %i, num_images = %i, k = %f, prob = %f\n', N, T(j), num_images(i), k, prob );
                if rt_N > 50
                    fprintf( 'N > 2500.  Giving up on this one...\n' );
                    prob = 0.0;
                end
            end
            if rt_N < 50
                last_N = rt_N-1;
            end
            scal_vals(i,j,q) = N;
            fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), q_comp_thresh(q), scal_vals(i,j,q) );
            fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', N, T(j), num_images(i), q_comp_thresh(q) );
        end
    end
end
scal_vals
% scal_vals_w_pn
% plot(T, mhop_cf_vals(1,:), '-kx');
% hold on;
% plot(T, worst_PL(1,:), ':bo');
% legend('Avg. PL', 'Worst PL');
% plot(T, mhop_cf_vals(3,:), '-kx');
% plot(T, worst_PL(3,:), ':bo');
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop.csv', image_size/8000, W/1000000, P/8), mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability.csv', image_size/8000, W/1000000, P/8), no_mhop_vals );
% csvwrite( sprintf('./image_size_%i_KB/channel_rate_%i/line_net/PS_%i/analytical_scalability_mhop_2.csv', image_size/8000, W/1000000, P/8), mhop_cf_vals );

