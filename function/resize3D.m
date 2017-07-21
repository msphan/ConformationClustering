function [ nI ] = resize3D( I, newsize )
%RESIZE3D Summary of this function goes here
%   Detailed explanation goes here

oldsize = size(I,1);
nI = zeros(newsize, newsize, newsize);

i = ((newsize-oldsize)/2) : (((newsize-oldsize)/2) + oldsize - 1);
i = i + 1;
nI(i,i,i) = I;

end

