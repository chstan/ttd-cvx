function [ ] = renderTruss( X, XID, E, a, fDes, fID, nx, ny, iter)
% plots the truss solution
m = length(E);
r = E(1, :);
s = E(2, :);

subplot(2, 2, (iter+6) / 7);
title(sprintf('Bridge Model at Iteration %d', iter));

hold on;
for i = 1:m
    p1 = find(XID == r(i)); p2 = find(XID == s(i));
    plt_str = 'b-';
    width = a(i)*6/max(a);
    if a(i) < 0.001
        plt_str = 'r--';
        width = 1;
        continue;
    end
    plot([X(1, p1) X(1, p2)], [X(2, p1) X(2, p2)], ...
         plt_str, 'LineWidth', width);
end
axis([-1 nx -0.6 ny]); axis square; box on;
set(gca, 'xtick', [], 'ytick', []);

for i = 1:1:length(fID)
    fidx = fID(i);
    currentforce = fDes(2*i - 1:2*i);
    currentforce = currentforce';
    currentX = X(:, fidx);
    if norm(currentforce) ~= 0
        arrow(currentX, currentforce/2, 'r');
    end
end

end

