clear;
font_size = 20;

linespec = {'xb', '+g', 'oc', '*r'};
num_nodes = 40;
N = num_nodes;
x = 1:ceil(num_nodes/2)+25;
plot_set = [1,ceil(N/2)];
exp_TF = zeros(1,length(plot_set));

cdf_D = zeros(1, length(x));
hold on;
for i=1:N
    cdf_D_i = zeros(1, length(x));
    for j=1:N
        if i == j
            continue;
        end
        pl = abs(i-j);
        avg_q_size = 0;

        cdf_D = cdf_D + (1.0/(N-1))*cdf_TF_ftn_line(N, min(i,j), max(i,j), x);
        cdf_D_i = cdf_D_i + (1.0/(N-2))*cdf_TF_ftn_line(N, min(i,j), max(i,j), x);
    end
    if sum(i==plot_set) > 0
        plot( x, cdf_D_i, char(linespec(i==plot_set)) );
    end
end
cdf_D = cdf_D/(N-2);

plot(x, cdf_D, char(linespec(end)) );
%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Transit Factor', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);

t = cellstr(num2str(plot_set', 'Node %i'));
t{3} = 'Avg. all nodes';
h_legend = legend(t{:}, 'Location', 'NorthWest');
set(h_legend,'FontSize',14);

saveas(gcf, sprintf('./TF_figures/CDF_TF_line_net_%i.pdf',num_nodes));