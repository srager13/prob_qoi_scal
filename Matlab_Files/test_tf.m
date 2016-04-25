
num_nodes=50;
dests = randi( [1,num_nodes], 1,num_nodes );
tf = zeros(1,num_nodes);
for i=1:num_nodes
    for j=1:num_nodes
        if (i < j && dests(i) > j) || (i > j && dests(i) < j)
            tf(j) = tf(j) + 1;
        end
    end
end
tf
