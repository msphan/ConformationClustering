function [ ce ] = calCentroid( I )
%GET_CENTROID compute centroid of object I

s = 2;
if length(size(I)) == 3, s = 3; end

ce = zeros(1,s);
g = zeros(1, s);

w = sum(I(:));

l = size(I,1);
c = (l + 1) / 2;

if s == 3

    for k = 1 : l
        for j = 1 : l
            for i = 1 : l

                x = i - c;
                y = j - c;
                z = k - c;

                g(1) = g(1) + x * I(i,j,k);
                g(2) = g(2) + y * I(i,j,k);
                g(3) = g(3) + z * I(i,j,k);

            end
        end
    end

    g(1) = g(1) / w;
    g(2) = g(2) / w;
    g(3) = g(3) / w;

    ce(1) = c + g(1);
    ce(2) = c + g(2);
    ce(3) = c + g(3);
    
else
    
    for j = 1 : l
        for i = 1 : l

            x = i - c;
            y = j - c;

            g(1) = g(1) + x * I(i,j);
            g(2) = g(2) + y * I(i,j);

        end
    end
   
    g(1) = g(1) / w;
    g(2) = g(2) / w;

    ce(1) = c + g(1);
    ce(2) = c + g(2);
    
end

% ce = round(ce);

end

