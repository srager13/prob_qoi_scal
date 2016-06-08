clear;

font_size = 20;
num_nodes = 125;
N=num_nodes;
x = 1:num_nodes;
i_set = 1:62;

k_req_set = 1:100;
max_i = zeros(1,length(k_req_set));
I_s = 100*8;
W = 2*1000000;
CF = 3;
P_s = 1500*8;
DF = 2;

for k_req = k_req_set
    exp_TF = zeros(1,length(i_set));
    exp_PL = zeros(1,length(i_set));

    for i=i_set
        % Traffic Factor:
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

        % Path Length:
        pdf_PL = zeros(1, num_nodes);

        if( i > 1 )
            pdf_PL(1:i) = 2/N;
        end
        pdf_PL(i:num_nodes-i) = 1/N;

        exp_PL(i_set==i) = sum(x.*pdf_PL);

    end

    D_i = ((k_req*I_s*CF)/W)*exp_TF + ((P_s*DF)/W)*exp_PL;
    [max_D, max_i(k_req==k_req_set)] = max(D_i);
%     max_i(k_req==k_req_set);
end

plot(k_req_set*I_s/8000, max_i);

xlabel('Amount of Data in Query (KB)', 'FontSize',font_size);
ylabel('Node of Flow Origin with Max Exp. Delay', 'FontSize',font_size);

saveas(gcf, sprintf('./max_i_line_net_%i.pdf',num_nodes));
