function [ f, fIDex ] = buildForceVector( fullF, fixedNodes, fID )
% removes entries of fullF corresponding to the fixed nodes

f = fullF;
fIDex = setdiff(fID, fixedNodes);
k = length(fullF)/2;
removeIdx = [];
for i = 1:1:k
    if any(fixedNodes == fID(i))
        removeIdx = [removeIdx (2*i - 1) (2*i)];
    end
end

f(removeIdx) = [];
f = f';
end

