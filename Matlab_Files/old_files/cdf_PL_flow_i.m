clear;
font_size = 20;

num_nodes = 125;
N = num_nodes;
pl = 1:num_nodes-1;
i_set = [1,ceil(N/2)];

hold on;
for i=i_set
    cdf_PL = ones(1, num_nodes-1);

    if( i > 1 )
        cdf_PL(1:i-1) = (2*(pl(1:i-1)-1))./N;
%         cdf_PL(1:i-1) = (2*pl(1:i-1))./(N*(N-1));
    end
    cdf_PL(i:N-i) = (pl(i:N-i)-1)./N;
%     cdf_PL(i:N-i) = (pl(i:N-i))./(N*(N-2*i));
    
    plot(pl, cdf_PL, '--x');
end

% axis([0,140,0,0.018]);
%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Path Length', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);

saveas(gcf, sprintf('./PL_figures/CDF_PL_line_net_%i.pdf',num_nodes));