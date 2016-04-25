clear;
font_size = 20;

num_nodes = 49;
N = num_nodes;
x = 1:num_nodes;
timeliness=100;
% timeliness=300;
% B=18; % image size in KB for directory
B=360;
% i_set = [21,42,63];
% i_set = [11,25,37];
i_set = [1,ceil(N/2)];
colors = ['g','b'];
exp_TF = zeros(1,length(i_set));
sum_pdf = zeros(1,length(i_set));

pdf_TF = zeros(length(i_set), num_nodes);

hold all;
for i=i_set

    for j=1:N
        pl = abs(mod(i-1,sqrt(N))-mod(j-1,sqrt(N))) + abs(floor((i-1)/sqrt(N))-floor((j-1)/sqrt(N)));
        if i == j
            continue;
        end
        pdf_TF(i==i_set,:) = pdf_TF(i==i_set,:) + (1/(N-1))*pdf_TF_ftn_grid( N, i, j, x );
    end
    
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


LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/grid_net/', N, B, timeliness);
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR); 
end
saveas(gcf, sprintf('%sflow_TF_pdf.pdf', LOCAL_DIR));
