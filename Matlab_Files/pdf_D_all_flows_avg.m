clear;
clc;
figure;
font_size = 20;

num_nodes = 50;
% num_nodes=455;
N = num_nodes;
j_set = 1:num_nodes;
i_set = 1:num_nodes;
plot_set = [1,ceil(N/2)];
% plot_set = [1,ceil(N/2),N];
colors = ['g','b','r'];
linespec = {'+g', 'xb', 'oc', '*r'};

k_req = 1;
% image_size_kb = 18;
% image_size_kb = 36;
image_size_kb = 90;
% image_size_kb = 360;
% timeliness = 40;
timeliness=100;
% timeliness=100;
% timeliness=300;

I_s = image_size_kb*1000*8;
B=k_req*I_s/8000;
CF = 3;
DF = 1.0;
W = 2*1000000;
P_s = 1500*8;
P_n = (B*8000)/P_s;

% timeliness = (k_req*I_s*CF*(num_nodes) + P_s*DF*P_n*(num_nodes-1))/W;
delay_set = 1.0:1.0:timeliness;

C_1 = (k_req*I_s*CF)/W;
C_2 = (P_s*DF)/W;
% C_2 = (P_s*DF*P_n)/W;
% C_2 = (DF*P_s*2)/W;
% avg_q_cont = [0, 1, 2, 2, 4, 5, 7, 18, 31, 18, 25, 25, 25, 48, 8, 100, 88, 105, 236 , 360, 438, 780, 846, 1524, 1172, 846, 457, 615, 864, 481, 287, 223, 161, 100, 68, 60, 56, 51, 43, 31, 23, 20, 16, 11, 5, 5, 3, 2, 1, 0];
% avg_q_not_cont = [0, 6, 12, 18, 24, 31, 42, 50, 67, 50, 51, 55, 59, 87, 101, 100, 97, 103, 148, 149, 167, 165, 151, 188, 133, 138, 164, 154, 186, 173, 147, 117, 118, 114, 102, 67, 76, 70, 61, 6, 69, 66, 50, 40, 27, 26, 18, 12, 6, 0];

pdf_D = zeros(1, length(delay_set));
hold on;
for i=1:N
    pdf_D_i = zeros(1, length(delay_set));
        for j=1:N
            if i == j
                continue;
            end
            pl = abs(i-j);
            avg_q_size = 0;
%             tf_2 = zeros(1, length(delay_set));
%             for k = min(i,j):max(i,j)
% %                 if k < N/2
% %                     avg_q_size = avg_q_size + 8*k+150;
% %                 else
% %                     avg_q_size = avg_q_size + 8*(N-k)+150;
% %                 end
% %                 avg_q_size = avg_q_size + avg_q_cont(k);
% %                 avg_q_size = avg_q_size + avg_q_not_cont(k);
% 
%                 tf_2 = tf_2 + pdf_TF_ftn(N, min(i,j), k, delay_set);
% %                 tf_2(1:20)
% %                 if i == 1 || j == N
% %                     fprintf( 'i = %i, j = %i, tf_2 = %i\n', i, j, tf_2 );
%     %                 fprintf( 'i = %i, j = %i, avg q size = %i\n', i, j, avg_q_size );
% %                 end
%             end
%             pdf_D = pdf_D + (1.0/(N-1))*pdf_TF_ftn(N, min(i,j), max(i,j), (delay_set-C_2*pl*delay_set)/C_1).*tf_2;
%             pdf_D_i = pdf_D_i + (1.0/(N-1))*pdf_TF_ftn(N, min(i,j), max(i,j), (delay_set-C_2*pl*delay_set)/C_1).*tf_2;
            % loop over all possible values of tf_2
%             for tf_2=1:num_nodes
%                 % prob tf_2 = tf_2
%                 pr_tf_2 = 0;
%                 for m=i:j
%                     pr_tf_2 = pr_tf_2 + pdf_TF_ftn(N, i, m, tf_2);
%                 end
%                 pr_tf_2 = pr_tf_2/pl;
%                 
%                 pdf_D = pdf_D + (1.0/(N-1))*pdf_TF_ftn(N, i, j, delay_set-((C_2*pl*tf_2*100)/(C_1)))*pr_tf_2;
%                 pdf_D_i = pdf_D_i + (1.0/(N-1))*pdf_TF_ftn(N, i, j, delay_set-((C_2*pl*tf_2*100)/(C_1)))*pr_tf_2;
%             end
% 
%             pdf_D = pdf_D + (1.0/(N-1))*pdf_TF_ftn(N, min(i,j), max(i,j), (delay_set/(C_1+C_2*pl)));
%             pdf_D_i = pdf_D_i + (1.0/(N-1))*pdf_TF_ftn(N, min(i,j), max(i,j), (delay_set/(C_1+C_2*pl)));

            pdf_D = pdf_D + (1.0/(N-1))*pdf_TF_ftn(N, min(i,j), max(i,j), (delay_set-C_2*pl)/C_1);
            pdf_D_i = pdf_D_i + (1.0/(N-1))*pdf_TF_ftn(N, min(i,j), max(i,j), (delay_set-C_2*pl)/C_1);
            
%             pdf_D = pdf_D + (1.0/(N-1))*pdf_TF_ftn_2(N, min(i,j), max(i,j), (delay_set/(C_1+C_2*pl*10)));
%             pdf_D_i = pdf_D_i + (1.0/(N-1))*pdf_TF_ftn_2(N, min(i,j), max(i,j), (delay_set/(C_1+C_2*pl*10)));
%             pdf_D = pdf_D + (1.0/(N-1))*pdf_TF_ftn_empirical(N, min(i,j), max(i,j), (delay_set-C_2*avg_q_size)/C_1);
%             pdf_D_i = pdf_D_i + (1.0/(N-1))*pdf_TF_ftn_empirical(N, min(i,j), max(i,j), (delay_set-C_2*avg_q_size)/C_1);
        end
        if sum(i==plot_set) > 0
            plot( delay_set, pdf_D_i, char(linespec(i==plot_set)) );
        end
end
pdf_D = pdf_D/N;

plot(delay_set, pdf_D, char(linespec(end)) );
xlabel('Delay', 'FontSize',font_size);
ylabel('PDF', 'FontSize',font_size);

legendTitles{1} = 'Node 1';
legendTitles{2} = 'Node 25';
legendTitles{3} = 'Avg all Nodes';
% legendTitles{3} = 'Node 50';
% legendTitles{4} = 'Avg all Nodes';
legend_font_size = 14;
legend(cellstr(legendTitles), 'Location', 'Best', 'FontSize', legend_font_size);
% h_legend = legend('Avg all flows');
% set(h_legend,'FontSize',14);

LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/line_net/', N, image_size_kb, floor(timeliness));
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR);
end
saveas(gcf, sprintf('%s/all_flows_avg_delay_pdf.pdf', LOCAL_DIR));

