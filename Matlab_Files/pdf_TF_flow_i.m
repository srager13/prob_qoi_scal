clear;
font_size = 20;

num_nodes = 125;
N = num_nodes;
x = 1:num_nodes;
i_set = [10,25,60];
exp_TF = zeros(1,length(i_set));

hold on;
for i=i_set
    pdf_TF = zeros(1, length(num_nodes));

    % mu(x) = -0.016x^2 + 2x - 2
    % sigma(x) = -0.0011x^2 + 0.128x + 1.42
    % normpdf( x_vals, mu, sigma )

    x_1 = i;
    mu_1 = -0.016*x_1^2 + 2*x_1 - 2;
    sigma_1 = -0.0011*x_1^2 + 0.128*x_1 + 1.42;
    pdf_TF = pdf_TF + (i/N)*normpdf(x,mu_1,sigma_1);

    for k=i:(N/2-1)
        x_2 = k;
        mu_2 = -0.016*x_2^2 + 2*x_2 - 2;
        sigma_2 = -0.0011*x_2^2 + 0.128*x_2 + 1.42;
        pdf_TF = pdf_TF + ((1/2-i/N)/(N/2-i))*normpdf(x,mu_2,sigma_2);
    end

    x_3 = N/2;
    mu_3 = -0.016*x_3^2 + 2*x_3 - 2;
    sigma_3 = -0.0011*x_3^2 + 0.128*x_3 + 1.42;
    pdf_TF = pdf_TF + (1/2)*normpdf(x,mu_3,sigma_3);
    
    exp_TF(i_set==i) = sum(x.*pdf_TF);

    plot(x, pdf_TF);
end

%title('PDF of TF for Selected Nodes in Line Network', 'FontSize',font_size);
xlabel('Transit Factor', 'FontSize',font_size);
ylabel('Probability', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:});
set(h_legend,'FontSize',14);

saveas(gcf, sprintf('./TF_figures/PDF_TF_line_net_%i.pdf',num_nodes));