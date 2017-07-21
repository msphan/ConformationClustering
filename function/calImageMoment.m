function [ mmt ] = calImageMoment(I, centroid, x_order, y_order, z_order )
%COM_OBJ_MOMENT Summary of this function goes here
%   Detailed explanation goes here

prj_length = size(I,1);

mmt = 0;

for k = 1 : prj_length
    for j = 1 : prj_length
        for i = 1 : prj_length
            x = i - centroid(1);
            y = j - centroid(2);
            z = k - centroid(3);
            mmt = mmt + x^x_order * y^y_order * z^z_order * I(i, j, k);
        end
    end
end
    
end

