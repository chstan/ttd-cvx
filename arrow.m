function y = arrow(P,V,color, epsi)
%  This mfile plots an arrow with tail at the point (x0, y0) and
%  tip at the point  (x0+a, y0+b).  Writing P = [x0, y0] and 
%  V = [a,b], the the complete call is   arrow(P,V, color).  The third argument,
%  color, is optional.  If the call is simply   arrow(P,V), the
%  arrow will be blue.  To get a red arrow, use  arrow(P,V, 'r').
%
% This function was contributed by Dr. Jeffrey Cooper, University of
% Maryland, MD, USA. See http://www.math.umd.edu/~jec/math246/demos.html.  


if nargin < 3
   color = 'b';
end

arrowsize = 3;

x0 = P(1); y0 = P(2);
a = V(1); b = V(2);

l = max(norm(V), eps);

u = [x0 x0+a]; v = [y0 y0+b];
hchek = ishold;

plot(u,v,color, 'LineWidth', arrowsize)
hold on
h = l - min(.2*l, .2) ; v = min(.2*l/sqrt(3), .2/sqrt(3) );

a1 = (a*h -b*v)/l;
b1 = (b*h +a*v)/l;

plot([x0+a1, x0+a], [y0+b1, y0+b], color, 'LineWidth', arrowsize)

a2 = (a*h +b*v)/l;
b2 = (b*h -a*v)/l;   

plot([x0+a2, x0+a], [y0+b2, y0+b], color, 'LineWidth', arrowsize)
if hchek == 0
	hold off
end

