clear;
clc;
figure;
font_size = 20;

num_nodes = 50;
% num_nodes=455;
N = num_nodes;
j_set = 1:num_nodes;
i_set = [1,ceil(N/2)];
colors = ['g','b','r'];

k_req = 1;
% image_size_kb = 18;
image_size_kb = 360;
I_s = image_size_kb*1000*8;
B=k_req*I_s/8000;
CF = 3;
DF = 1.5;
W = 2*1000000;
P_s = 1500*8;
P_n = (B*8000)/P_s;

% timeliness = (k_req*I_s*CF*(num_nodes) + P_s*DF*P_n*(num_nodes-1))/W;
% timeliness = 50;
timeliness=165;
% timeliness=300;
delay_set = 1.0:1.0:timeliness;

C_1 = (k_req*I_s*CF)/W;
C_2 = (P_s*DF)/W;
% C_2 = (P_s*DF*P_n)/W;
% C_2 = (P_s*DF*P_n*0.75)/W;
% C_2 = (P_s*DF*P_n*0.5)/W;
% C_2 = (P_s*DF*128)/W;

% delay_set = 0.5:0.25:timeliness;
pdf_D = zeros(length(i_set), length(delay_set));
pdf_TF = zeros(length(i_set), length(delay_set));
pdf_PL = zeros(length(i_set), length(delay_set));

hold on;
for i=i_set

    for d=delay_set
        for j=j_set
%             pdf_D(i==i_set,d==delay_set) = pdf_D(i==i_set,d==delay_set) + pdf_PL_ftn(N, i, j)*pdf_TF_ftn(N, i, (d-C_2*pl)/C_1);
            if i == j
                continue;
            end
            pl = abs(i-j);
%             pdf_D(i==i_set,d==delay_set) = pdf_D(i==i_set,d==delay_set) + (1.0/(N-1))*pdf_TF_ftn(N, i, j, (d-C_2*pl)/C_1);
            Q_avg = 125;
            pdf_D(i==i_set,d==delay_set) = pdf_D(i==i_set,d==delay_set) + (1.0/(N-1))*pdf_TF_ftn_2(N, i, j, (d-C_2*pl*Q_avg)/C_1);
%             for k=j_set
%                 pdf_D(i==i_set, d==delay_set) = pdf_D(i==i_set,d==delay_set) + (1.0/(N-1))*pdf_TF_ftn_2(N, i, j, (d-C_2*pl*k)/C_1)*pdf_TF_ftn(N, i, j, k);
%             end
        end
    end
    fprintf('Mean delay of node %i = %f\n', i, sum(pdf_D(i==i_set,:).*delay_set)/length(j_set) );
    fprintf('Sum of delay PDF for node %i = %f\n', i, sum(pdf_D(i==i_set,:)) );
    
    plot(delay_set, pdf_D(i==i_set,:), sprintf('%s--x',colors(i==i_set)) );
end

xlabel('Delay', 'FontSize',font_size);
ylabel('PDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);

LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/line_net/', N, image_size_kb, floor(timeliness));
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR);
end
saveas(gcf, sprintf('%sdelay_pdf.pdf', LOCAL_DIR));
