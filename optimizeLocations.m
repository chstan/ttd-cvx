function [ yf, optval, time ] = optimizeLocations( A, L, F, a, ytot, nx, ny )
% Solve the truss topology design problem as a
% function of the truss cross sections a

[n,m] = size(A);
% young's modulus for each edge
Eyoung = ones(m,1);


% cvx_solver 'scs'
% cvx_solver_settings('MAX_ITERS', 25000);
% cvx_solver_settings('SCALE', 10);
% cvx_solver_settings('EPS', 1e-7);
cvx_solver sedumi
% cvx_solver gurobi
tstart = cputime;
cvx_begin quiet
    variables f(m) w(m) v(m) y(n);
    minimize( sum(w+v) + 0.01*norm(y, 1))
    subject to
        A*f == -F
        norms([v,L./sqrt(Eyoung)./sqrt(a).*f],2,2) <= w
        ((w-v) - ones(m, 1))/2 == (A'*y)./L;
        norm(y, inf) <= 0.015;
        norm(ytot + y, inf) <= 0.4;
        for i = 2:(nx-1)
            idx = ny*(i-1) + 1;
            % x coordinate of force loaded components dont move
            y(2*idx - 3) == 0;
        end
cvx_end
time = cputime - tstart;
% cvx_solver 'scs'
% cvx_solver_settings('MAX_ITERS', 25000);
% cvx_solver_settings('SCALE', 10);
% cvx_solver_settings('USE_INDIRECT', false);

% cvx_begin quiet
%     variables theta y(n);
%     k = length(F);
%     Z = zeros(k, k);
%     for i = 1:m
%         Z = Z + a(i)*Eyoung(i)*(L(i)^(-2))*(1 + 2*A(:,i)'*y/L(i))*(A(:, i)*A(:, i)');
%     end
%     Q = [theta, F'; F, Z];
%     
%     minimize( theta )
%     subject to
%         Q == semidefinite(k+1);
%         norm(y, inf) <= 0.015;
%         norm(ytot + y, inf) <= 0.4;
%         for i = 2:7
%             idx = 4*(i-1) + 1;
%             % x coordinate of force loaded components dont move
%             y(2*idx - 3) == 0;
%         end
% cvx_end
optval = cvx_optval;

yf = y;
end

