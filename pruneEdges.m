function [Enew, Xnew, XIDnew, anew] = pruneEdges(E, X, XID, a)

%
% Removes nodes that are connected to edges that're too thin according to
% the cross-sectional areas a
%

    % Remove edges
    threshold = 0.001;
	Enew = E(:,find(a >= threshold));
    anew = a(find(a >= threshold));
    % Remove unused nodes
    XIDnew = [];
    Xnew = [];
    for edge = 1:length(Enew) % assume there're more than 2 edges
        startNode = Enew(1,edge);
        endNode = Enew(2,edge);
        
        if ~ismember(startNode,XIDnew)
            XIDnew = [XIDnew startNode];
        end
        
        if ~ismember(endNode,XIDnew)
            XIDnew = [XIDnew endNode];
        end
    end
    
    XIDnew = sort(XIDnew);
    
    % Update positions of nodes
    for node = XIDnew
        nodePos = X(:,find(XID == node));
        Xnew = [Xnew nodePos];
    end

end