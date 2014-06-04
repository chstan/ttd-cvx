function A = buildProjection(E, Evecs, XID, fixedNodes)

%
% E = edges (start and end nodes)
% Evecs = edge vectors
% XID = node indices
% fixedNodes = array of fixed nodes
%
% A = force projection matrix
%

    % Constants and data
    e1 = [1 0]';
    e2 = [0 1]';
    
    n = length(XID);
    A = zeros(2*n,length(Evecs));
    [~,m] = size(A);
    
    % Construct projection matrix (incl. fixed nodes)
    for edge = 1:m
        startNode = E(1,edge);
        endNode = E(2,edge);
        
        startNodeIdx = find(XID == startNode)*2 - 1;
        endNodeIdx = find(XID == endNode)*2 - 1;
        
        A(startNodeIdx,edge) = Evecs(:,edge)'*e1/norm(Evecs(:,edge),2);
        A(startNodeIdx+1,edge) = Evecs(:,edge)'*e2/norm(Evecs(:,edge),2);
        
        A(endNodeIdx,edge) = -Evecs(:,edge)'*e1/norm(Evecs(:,edge),2);
        A(endNodeIdx+1,edge) = -Evecs(:,edge)'*e2/norm(Evecs(:,edge),2);
    end
    
    % Remove fixed nodes from projection matrix
    Amod = [];
    for node = 1:n
        if ~ismember(node,fixedNodes)
            nodeIdxX = find(XID == node)*2 - 1;
            nodeIdxY = find(XID == node)*2;
            
            Amod = [Amod; A(nodeIdxX:nodeIdxY,:)];
        end
    end
    A = Amod;
end