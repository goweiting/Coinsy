function r1 = normalise(first_pic)

[m,n,z] = size(first_pic);
r1 = zeros(m,n,z);

% for i = 1:m
%     for j = 1:n
%         red = first_pic(i,j,1);
%         green = first_pic(i,j,2);
%         blue = first_pic(i,j,3);
%         sum = (red + blue + green);
%         r1(i,j,1) = red / sum;
%         r1(i,j,2) = green / sum;
%         r1(i,j,3) = blue / sum;
%     end
% end

r = first_pic(:,:,1);
g = first_pic(:,:,2);
b = first_pic(:,:,3);
sum = r+g+b;
r1(:,:,1) = r./sum;
r1(:,:,2) = g./sum;
r1(:,:,3) = b./sum;



end
