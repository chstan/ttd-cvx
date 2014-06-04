clear all; close all; clc;

% --- Generate problem data (6-nodes building) --- %

% initial node positions
P = [0, 0; ...
     0, 1; ...
     1, 0; ...
     1, 1; ...
     2, 0; ...
     2, 1]';

% force projection matrix (edges implicit)
% edges: 12, 13, 14, 16, 23, 24, 25, 34, 35, 36, 45, 46, 56
A = [0 0 0 0 1/sqrt(2) 1 2/sqrt(5) 0 0 0 0 0 0; ... % 2x
     -1 0 0 0 -1/sqrt(2) 0 -1/sqrt(5) 0 0 0 0 0 0; ... % 2y
     0 -1 0 0 -1/sqrt(2) 0 0 0 1 1/sqrt(2) 0 0 0; ... % 3x
     0 0 0 0 1/sqrt(2) 0 0 1 0 1/sqrt(2) 0 0 0; ... % 3y
     0 0 -1/sqrt(2) 0 0 -1 0 0 0 0 1/sqrt(2) 1 0; ... % 4x
     0 0 -1/sqrt(2) 0 0 0 0 -1 0 0 -1/sqrt(2) 0 0; ... % 4y
     0 0 0 -2/sqrt(5) 0 0 0 0 0 -1/sqrt(2) 0 -1 0; ... % 6x
     0 0 0 -1/sqrt(5) 0 0 0 0 0 -1/sqrt(2) 0 0 -1]; % 6y

[n,m] = size(A);

% set of edge lengths
% edges: 12, 13, 14, 16, 23, 24, 25, 34, 35, 36, 45, 46, 56
L = [1 1 1 sqrt(5) sqrt(2) 1 sqrt(5) 1 1 sqrt(2) sqrt(2) 1 1]';

% young's modulus for each edge
E = ones(m,1);

% volume factor (in cross-section areas, tk)
rand('state',1);
M = diag(ones(m,1) + 1);

% volume constraints
d = ones(m,1) + 1;
V = sum(d)/5;

% Force on "free nodes" 
% nodes: 2x 2y 3x 3y 4x 4y 6x 6y
F = [0, 0, ... % 2x, 2y
     -2, -3, ... % 3x, 3y
     0, 0, ... % 4x, 4y
     0, 0]';   % 6x, 6y

% --- Solve optimal building design (SOCP) --- %
cvx_begin quiet
    variables f(m) w(m) y(m)
    minimize( sum(w+y) )
    subject to
        A*f == -F
        M*(w-y) <= d
        norms([y,L./sqrt(E).*f],2,2) <= w
        sum(w-y) <= V
cvx_end

% extract cross-section areas, tk
t = w - y;

% visualize solution
a = t; % replace 'a' with your solution

% bar j is connected between nodes rj and sj
% edges: 12, 13, 14, 16, 23, 24, 25, 34, 35, 36, 45, 46, 56
r = [1 1 1 1 2 2 2 3 3 3 4 4 5]';
s = [2 3 4 6 3 4 5 4 5 6 5 6 6]';

% plot
clf; hold on;
N = 3;
for i = 1:m
    p1 = r(i); p2 = s(i);
    plt_str = 'b-';
    width = a(i)*5;
    if a(i) < 0.001
        plt_str = 'r--';
        width = 1;
    end
    plot([P(1, p1) P(1, p2)], [P(2, p1) P(2, p2)], ...
         plt_str, 'LineWidth', width);
end
axis([-0.5 N-0.5 -0.1 N-0.5]); axis square; box on;
set(gca, 'xtick', [], 'ytick', []);