clear;
clc;
% syms d;

d1 = 0:0.2:5
y1 = d1 - (1+d1).*log(1+d1) + d1.^2./(2+d1)

%sol_1 = solve( -log(1+d) + (2*d)/(2+d) - d^2/(2+d)^2 == 0, d );
% sol_1

d2 = 0:0.2:5
y2 = -log(1+d2) + (d2.*(d2+4))./(2+d2).^2

% sol_2 = solve( -1/(1+d) + 4/(2+d)^2 - (2*d)/(2+d)^2 + (2*d^2)/(2+d)^3 == 0, d );
d3 = 0:0.2:5
y3 = -1./(1+d3) - 8./(d3+2).^3

plot( d1, y1, 'b' );
hold on;
plot( d2, y2, 'g' );
plot( d3, y3, 'r' );
legend( 'f(delta)', 'f`(delta)', 'f``(delta)' );