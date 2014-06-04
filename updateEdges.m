function [ Evecs, L ] = updateEdges( E, X, XID )

% compute the new edge vectors and lengths after nodes have been moved

m = length(E);
Evecs = zeros(size(E));

for edge = 1:m
    startNode = E(1,edge);
    endNode = E(2,edge);
    
    startNodeIdx = find(XID == startNode);
    endNodeIdx = find(XID == endNode);
    
    Evecs(:,edge) = X(:,endNodeIdx) - X(:,startNodeIdx);
end

L = norms(Evecs,2,1)';

end
