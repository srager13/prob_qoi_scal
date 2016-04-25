clc;
clear;

avg_all_flows = 1;

W=2*1000*1000;

% T=5:5:25;
% T=16:2:18;
% T=[45];
T=15:10:55;
% T=125:25:300;
% q_comp_thresh = 0.98:0.01:1.0;
q_comp_thresh = 0.999999;
num_images = 1;
% num_images =1:6;
image_size_kb = 36;
% image_size_kb = 48;
% image_size_kb = 90;
image_size_variance = 1;
% image_size_kb = 360;
I_s = image_size_kb*1000*8;
P_s = 1500*8; % 1500 Bytes coverted to bits
P_n = image_size_kb/P_s; % number of packets
CF = 3;
DF = 1.5;

scal_vals = zeros(length(num_images),length(T), length(q_comp_thresh));

output_directory = sprintf('./scal_predictions/image_size_%i_KB/channel_rate_%i/PS_%i/line_net/', image_size_kb, W/1000000, P_s/8);
if ~exist(output_directory, 'dir')
  mkdir(sprintf('%s', output_directory));
end

% if avg_all_flows == 0
init_guess_file = fopen( sprintf('%s/initial_guesses.csv', output_directory), 'w' );
% else
%     init_guess_file = fopen( sprintf('%s/initial_guesses_avg_all_flows.csv', output_directory), 'w' );
% end
last_N = 10;

for i=1:length(num_images)
    for j=1:length(T)
        for q=1:length(q_comp_thresh)
            C_1 = (num_images(i)*CF)/W;
            C_2 = (P_s*DF)/W;
            N = last_N;
            prob = 1.1;
            while prob > q_comp_thresh(q)
                N = N+1;
                prob = 0;
                for x=1:N
                    zero_prob = 0;
                    for y=1:N
                        if x==y
                            continue;
                        end
                        pl = abs(x-y);
                        k = (T(j)-C_2*pl)/C_1;
                        if cdf_TF_ftn_2_line(N, min(x,y), max(x,y), (T(j)-C_2*pl)/C_1) == 0
                            zero_prob = zero_prob + 1;
                        end
                        for i_s=1:image_size_kb*2
                %         cdf_D = cdf_D + (1.0/(N-1))*cdf_TF_ftn_2_line(N, min(i,j), max(i,j), (delay_set-a_factor-m_factor*C_2*pl)/C_1);
                            prob = prob + normpdf(i_s,image_size_kb,sqrt(image_size_variance))*cdf_TF_ftn_2_line(N, min(x,y), max(x,y), (T(j)-C_2*pl)/(C_1*i_s*1000*8));
                %             fprintf('i_s = %i\n', i_s);
                %             fprintf('input to cdf_TF = %f\n', (delay_set-a_factor-m_factor*C_2*pl)/(C_1*i_s));
                        end
%                         fprintf( 'N = %i, T = %i, num_images = %i, k = %f, prob = %f\n', N, T(j), num_images(i), k, prob );
                    end
                    prob = prob/(N-zero_prob);
                end
%                 prob = prob/(N-2);
                if N > 1000
                    fprintf( 'N > 1000.  Giving up on this one...\n' );
                    prob = 0.0;
                end
                
                fprintf( 'N = %i, T = %i, num_images = %i, k = %f, prob = %f\n', N, T(j), num_images(i), k, prob );
%                 fprintf( 'Before exit loop: N = %i, T = %i, num_images = %i, q_comp_thresh = %f, prob = %f\n', N, T(j), num_images(i), q_comp_thresh(q), prob );
            end
            if N < 1000
                last_N = N;
            end
            scal_vals(i,j,q) = N;
            fprintf( init_guess_file, '%.1f, %i, %.2f, %i\n', num_images(i)/2.0, T(j), q_comp_thresh(q), scal_vals(i,j,q) );
            fprintf( 'N = %i, T = %i, num_images = %i, thresh = %f\n', N, T(j), num_images(i), q_comp_thresh(q) );
        end
    end
end
scal_vals
% csvwrite( sprintf('./%s/analytical_scalability_qoi.csv', output_directory), scal_vals );
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

