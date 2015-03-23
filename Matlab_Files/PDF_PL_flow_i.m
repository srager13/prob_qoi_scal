clear;
font_size = 20;

num_nodes=125;
N=num_nodes;
x = 1:num_nodes;
i_set = [1,32,62];
exp_TF = zeros(1,length(i_set));

hold on;
for i=i_set
    pdf_PL = zeros(1, num_nodes);

    if( i > 1 )
        pdf_PL(1:i) = 2/N;
    end
    pdf_PL(i:num_nodes-i) = 1/N;
    
    exp_TF(i_set==i) = sum(x.*pdf_PL);

    plot(x, pdf_PL, '--x');
end

axis([0,140,0,0.018]);
%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Path Length', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);

saveas(gcf, sprintf('./PL_figures/PDF_PL_line_net_%i.pdf',num_nodes));