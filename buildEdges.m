function [ EVecs, L, E, EID ] = buildEdges( X, XID, richness )
% produces an edge list, a list of the edge lengths, and IDs for the edges
s = length(X);
k = 1;
L = [];
E = [];
EID = [];
EVecs = [];
for i = 1:1:s
    for j = (i+1):1:s
        d = -X(:, i) + X(:, j);
        if (norm(d) < richness && gcd(d(1), d(2)) == 1)
            L = [L norm(d)];
            E = [E [XID(i); XID(j)]];
            EID = [EID k];
            EVecs = [EVecs, d];
            k = k + 1;
        end
    end
end

L = L';

end
