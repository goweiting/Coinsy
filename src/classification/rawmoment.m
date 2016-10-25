function M_ij = rawmoment(img,p,q)
%% rawmoment(img,p,q) calculates the (p+q)th raw moment of img
%   image is a BW img

%%
[m,n] = size(img);
M_ij = 0;
for i=1:m
    for j=1:n
        x=i; y=j;
        I_xy = img(i,j);
        M_ij =  M_ij + (x^p * y^q * I_xy);
    end
end


end
