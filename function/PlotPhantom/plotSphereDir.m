function [  ] = plotSphereDir( A )
%PLOTSPHERE Summary of this function goes here

[x, y, z] = calSphere(A);
plot3(x,y,z,'o');


end

