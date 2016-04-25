clear;
clc;
figure;
font_size = 20;

num_nodes = 50;
N = num_nodes;
pl_set = 1:num_nodes-1;
i_set = [1,ceil(N/2)];
% i_set = 2;
colors = ['g','b'];

k_req = 1;
image_size_kb = 18;
I_s = image_size_kb*1000*8;
B=k_req*I_s/8000;
timeliness=10;
delay_set = 0.1:0.1:timeliness;
CF = 3;
DF = 2;
W = 2*1000000;
P_s = 1500*8;

C_1 = (k_req*I_s*CF)/W;
C_2 = (P_s*DF)/W;

% delay_set = 0.5:0.25:timeliness;
pdf_D = zeros(length(i_set), length(delay_set));
pdf_TF = zeros(length(i_set), length(delay_set));
pdf_PL = zeros(length(i_set), length(delay_set));

hold on;
for i=i_set

    for d=delay_set
        for pl=pl_set
            pdf_PL(i==i_set,d==delay_set) = pdf_PL(i==i_set,d==delay_set) + pdf_PL_ftn(N, i, pl);
            pdf_TF(i==i_set,d==delay_set) = pdf_TF(i==i_set,d==delay_set) + pdf_TF_ftn(N, i, (d-C_2*pl)/C_1);
%             pdf_D(i==i_set,d==delay_set) = pdf_D(i==i_set,d==delay_set) + pdf_PL_ftn(N, i, pl)*pdf_TF_ftn(N, i, (d-C_2*pl)/C_1);
            pdf_D(i==i_set,d==delay_set) = pdf_D(i==i_set,d==delay_set) + pdf_PL_ftn(N, i, pl)*pdf_TF_ftn_2(N, i, pl, (d-C_2*pl)/C_1);
        end
    end
    pdf_D(i==i_set,:) = pdf_D(i==i_set,:)/2.0;
    fprintf('Mean delay of node %i = %f\n', i, sum(pdf_D(i==i_set,:).*delay_set) );
    fprintf('Sum of delay PDF for node %i = %f\n', i, sum(pdf_D(i==i_set,:)) );
    fprintf('Sum of PL PDF for node %i = %f\n', i, sum(pdf_PL(i==i_set,:)) );
    fprintf('Sum of TF PDF for node %i = %f\n', i, sum(pdf_TF(i==i_set,:)) );
    plot(delay_set, pdf_D(i==i_set,:), sprintf('%s--x',colors(i==i_set)) );
end

xlabel('Delay', 'FontSize',font_size);
ylabel('PDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);

LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/line_net/', N, image_size_kb, timeliness);
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR);
end
saveas(gcf, sprintf('%sdelay_pdf.pdf', LOCAL_DIR));