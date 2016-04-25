clear;
font_size = 20;

num_nodes = 50;
N = num_nodes;
x = 1:num_nodes;
timeliness=10;
B=18; % image size in KB for directory
% i_set = [21,42,63];
% i_set = [11,25,37];
i_set = [1,ceil(N/2)];
colors = ['g','b'];
exp_TF = zeros(1,length(i_set));
sum_pdf = zeros(1,length(i_set));

pdf_TF = zeros(length(i_set), num_nodes);

hold all;
for i=i_set

    mu_1 = (2*(i-1)*(N-i))/(N-1);
    sigma_1 = sqrt(((2*(i-1)*(N-i))/(N-1))*(1-(1/(N-1))));
    pdf_TF(i==i_set,:) = pdf_TF(i==i_set,:) + (i/N)*normpdf(x,mu_1,sigma_1);

    for k=i:(N/2-1)
        mu_2 = (2*(k-1)*(N-k))/(N-1);
        sigma_2 = sqrt(((2*(k-1)*(N-k))/(N-1))*(1-(1/(N-1))));
        pdf_TF(i==i_set,:) = pdf_TF(i==i_set,:) + ( (0.5-(i/N)) / ((N/2)-i) ) *normpdf(x,mu_2,sigma_2);
    end
    
    mu_3 = (N*(N/2-1))/(N-1);
    sigma_3 = sqrt(((N*(N/2-1))/(N-1))*(1-(1/(N-1))));
    pdf_TF(i==i_set,:) = pdf_TF(i==i_set,:) + (1/2)*normpdf(x,mu_3,sigma_3);
   
    exp_TF(i_set==i) = sum(x.*pdf_TF(i==i_set,:));
    sum_pdf(i_set==i) = sum(pdf_TF(i==i_set,:));

    plot(x, pdf_TF(i==i_set,:), sprintf('%s--x',colors(i==i_set)) );
end

%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Transit Factor', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);


LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/line_net/', N, B, timeliness);
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR); 
end
saveas(gcf, sprintf('%sflow_TF_pdf.pdf', LOCAL_DIR));
