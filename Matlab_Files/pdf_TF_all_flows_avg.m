clear;
font_size = 20;

num_nodes = 50;
N = num_nodes;
x = 1:num_nodes;
timeliness=10;
% timeliness=165;
% timeliness=300;
B=18; % image size in KB for directory
% B=360;
% i_set = [21,42,63];
% i_set = [11,25,37];
i_set = [1,ceil(N/2)];
colors = ['g','b'];
avg_pdf_TF = zeros( 1, num_nodes );

hold all;
for i=1:N
    for j=1:N
        if i == j
            continue;
        end
%         avg_pdf_TF(1,:) = avg_pdf_TF(1,:) + (1/(N-1))*normpdf( x, 13, 3 );
        avg_pdf_TF(1,:) = avg_pdf_TF(1,:) + (1/(N-1))*pdf_TF_ftn( N, min(i,j), max(i,j), x );
%         avg_pdf_TF(1,:) = avg_pdf_TF(1,:) + (1/(N-1))*pdf_TF_ftn_2( N, min(i,j), max(i,j), x );
    end   
end
avg_pdf_TF = avg_pdf_TF./N;

mean_TF = (N-1)^2/(2*N-4);
fprintf( 'Mean = %f\n', mean_TF );

plot(x, avg_pdf_TF, sprintf('%s--x',colors(i==i_set)) );
%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Transit Factor', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);

% t = cellstr(num2str(i_set', 'Node %i'));
% h_legend = legend(t{:});
h_legend = legend('Avg-All Flows');
set(h_legend,'FontSize',14);


LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/line_net/', N, B, timeliness);
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR); 
end
saveas(gcf, sprintf('%sall_flows_avg_TF_pdf.pdf', LOCAL_DIR));
