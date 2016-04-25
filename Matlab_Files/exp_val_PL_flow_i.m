clear;
font_size = 20;

num_nodes=125;
N=num_nodes;
x = 1:num_nodes;
i_set = 1:62;
exp_PL = zeros(1,length(i_set));
exp_PL_closed_form = zeros(1,length(i_set));

hold on;
for i=i_set
    pdf_PL = zeros(1, num_nodes);

    if( i > 1 )
        pdf_PL(1:i) = 2/N;
    end
    pdf_PL(i:num_nodes-i) = 1/N;

%     exp_PL(i_set==i) = sum(x.*pdf_PL);
    
	exp_PL_closed_form(i_set==i) = N/2 - i + i^2/N - 2*i/N;

end

% plot(i_set, exp_PL);
plot(i_set, exp_PL_closed_form);
% axis([0,140,0,0.018]);
%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Position of Node in Line Network', 'FontSize',font_size);
ylabel('Expected Value of Path Length', 'FontSize',font_size);

% t = cellstr(num2str(i_set', 'Node %i'));
% h_legend = legend(t{:});
% legend('Calculated', 'Derived');
% set(h_legend,'FontSize',14);

saveas(gcf, sprintf('./PL_figures/EV_PL_line_net_%i.pdf',num_nodes));