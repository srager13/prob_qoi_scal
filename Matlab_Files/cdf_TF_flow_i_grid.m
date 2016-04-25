clear;
font_size = 20;

num_nodes = 49;
N = num_nodes;
x = 1:ceil(num_nodes/2);
i_set = [1,ceil(N/2)];

cdf_TF = zeros(length(i_set), length(x));

hold on;
for i=i_set
    for j=1:N
        if i == j
            continue;
        end
        
        pl = abs(mod(i-1,sqrt(N))-mod(j-1,sqrt(N))) + abs(floor((i-1)/sqrt(N))-floor((j-1)/sqrt(N)));
        
        cdf_TF(i==i_set,:) = cdf_TF(i==i_set,:) + (1/(N-1))*cdf_TF_ftn_grid( N, i, j, x );
    end
    
    plot(x, cdf_TF);
end

%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Transit Factor', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:}, 'Location', 'NorthWest');
set(h_legend,'FontSize',14);

saveas(gcf, sprintf('./TF_figures/CDF_TF_grid_net_%i.pdf',num_nodes));