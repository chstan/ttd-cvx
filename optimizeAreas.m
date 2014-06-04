function [ a, optval, time ] = optimizeAreas( A, L, M, d, V, F)
% Solve the truss topology design problem as a
% function of the truss cross sections a

[n,m] = size(A);
p = length(F) + 1;
% young's modulus for each edge
Eyoung = ones(m,1);


% cvx_solver_settings('MAX_ITERS', 25000);
% cvx_solver_settings('SCALE', 10);
% cvx_solver_settings('EPS', 1e-7);
% Convex optimization (SOCP formulation)
tstart = cputime;
% cvx_solver gurobi
cvx_begin quiet
    
    cvx_solver sedumi
    variables f(m) w(m) y(m)
    minimize( sum(w+y) )
    subject to
        A*f == -F
        M*(w-y) <= d
        norms([y,L./sqrt(Eyoung).*f],2,2) <= w
        sum(w-y) <= V
cvx_end
time = cputime - tstart;
% extract cross-section areas, ak
a = w - y;

% % Convex optimization (SDP formulation)
% cvx_begin
%     variables theta a(m);
%     
%     k = length(F);
%     Z = zeros(k, k);
%     for i = 1:m
%         Z = Z + a(i)*Eyoung(i)*(L(i)^(-2))*(A(:, i)*A(:, i)');
%     end
%     
%     Q = [theta, F'; F, Z];
%     
%     minimize( theta )
%     subject to
%         Q == semidefinite(k+1);
%         L'*a <= V;
%         a >= 0;
%         M*a <= d;
% cvx_end
optval = cvx_optval;
end

