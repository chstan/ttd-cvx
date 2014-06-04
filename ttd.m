function [tareas, tlocs] = ttd(nx, ny, maxiters)

rand('state', 1);

% problem coarseness, initial discretization
richness = 3;

initialTop = [nx, ny];
fixedNodes = [1, ny*(nx - 1) + 1];
fDes = zeros(1, 2*nx*ny);
for i = 2:(nx-1)
    fidx = ny*(i-1) + 1;
    fDes(2*fidx) = -1;
end
fID = 1:1:nx*ny;

% initial matrix of nodes and an ID matrix
X = [];
XID = [];

for i = 1:1:nx
    for j = 1:1:ny
        X = [X [i-1; j-1]];
        XID = [XID (j + (i-1)*ny)];
    end
end

tareas = 0;
tlocs = 0;
% build an adjacency list and an ID list for the edges, as well as lengths
[EVecs, L, E, EID] = buildEdges(X, XID, richness);
ytot = zeros(2*nx*ny - 4, 1);

cs_obj = [];
loc_obj = [];
mobj = Inf;
% figure();
for iter = 1:maxiters
    iter
    A = buildProjection(E, EVecs, XID, fixedNodes);
    F = buildForceVector(fDes, fixedNodes, fID); 

    [n,m] = size(A);
    M = eye(m);
    d = nx*ny*(ones(m,1) + 1)/10;
    V = sum(d)/10;
    [a, optval, deltatareas] = optimizeAreas(A, L, M, d, V, F);
    mobj = min(mobj, optval);
    tareas = tareas + deltatareas;
    cs_obj = [cs_obj, optval];
%     if mod(iter, 7) == 1
%         renderTruss(X, XID, E, a, fDes, fID, nx, ny, iter);
%     end
    
    % remove edges/nodes on the basis of having very small optimal cross
    % sections
%     [Enew, Xnew, XIDnew, anew] = pruneEdges(E, X, XID, a);
%     
%     E = Enew;
%     X = Xnew;
%     XID = XIDnew;
%     a = anew;
    
    [y, optval, deltatlocs] = optimizeLocations(A, L, F, a, ytot, nx, ny);
    tlocs = tlocs + deltatlocs;
    loc_obj = [loc_obj, optval];
    ytot = ytot + y;
    % this is assuming no nodes removed. fine for now I guess
    notFixed = setdiff(XID, fixedNodes);
    for i = 1:1:length(notFixed);
        id = notFixed(i);
        X(1, id) = X(1, id) + y(2*i - 1);
        X(2, id) = X(2, id) + y(2*i);
    end

    [EVecs, L] = updateEdges(E, X, XID);
    
end

figure();
hold on;
plot(1:1:maxiters, cs_obj);
plot(1:1:maxiters, loc_obj);
% legend('\Theta_1', '\Theta_2') 
% figure();
% renderTruss(X,XID,E,a,fDes,fID,nx,ny);

tareas = tareas / maxiters;
tlocs = tlocs / maxiters;
cs_obj
min(cs_obj)
end