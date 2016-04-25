clear;
font_size = 20;

num_nodes = 49;
N = num_nodes;
j_set = 1:num_nodes;
i_set = [1,ceil(N/2)];
colors = ['g','b'];

k_req = 1;
image_size_kb = 360;
I_s = image_size_kb*1000*8;
B=k_req*I_s/8000;
timeliness=100;
delay_set = 0.1:0.1:timeliness;
CF = 5;
DF = 2.5;
W = 2*1000000;
P_s = 1500*8;

C_1 = (k_req*I_s*CF)/W;
C_2 = (P_s*DF)/W;

cdf_D = zeros(length(i_set), length(delay_set));

hold on;
for i=i_set
    for d=delay_set
%         cdf_TF = cdf_TF_ftn( N, i, (d - C_2*j_set)/C_1 );
        for j=j_set
            pl = abs(mod(i-1,sqrt(N))-mod(j-1,sqrt(N))) + abs(floor((i-1)/sqrt(N))-floor((j-1)/sqrt(N)));
            cdf_D(i==i_set,d==delay_set) = cdf_D(i==i_set,d==delay_set) + (1.0/(N-1))*cdf_TF_ftn_grid(N, i, j, (d-C_2*pl)/C_1);
        end
    end
    
    plot(delay_set, cdf_D(i==i_set,:),  sprintf('%s--x',colors(i==i_set)) );
end

xlabel('Delay', 'FontSize',font_size);
ylabel('CDF', 'FontSize',font_size);

t = cellstr(num2str(i_set', 'Node %i'));
h_legend = legend(t{:}, 'Location', 'NorthWest');
set(h_legend,'FontSize',14);


LOCAL_DIR = sprintf('./num_nodes_%i/image_size_%i_KB/timeliness_%i/grid_net/', N, image_size_kb, timeliness);
if ~exist( LOCAL_DIR, 'dir') 
    mkdir(LOCAL_DIR);
end
saveas(gcf, sprintf('%sdelay_cdf.pdf', LOCAL_DIR));
