function Image_X = copy_array(n,X)

Image_X = zeros(n);

for i = 1:n,
    for j = 1:n,
        if X(i,j) == -1
            Image_X(i,j) = 10;
            
        elseif X(i,j) == 1
            Image_X(i,j) = 1000;
            
        end
    end
end