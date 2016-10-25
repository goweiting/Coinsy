function miu_pq = centralmoment(img,p,q)
%% centralmoment(img,p,q) calculates the (p+q)th central moment of img
%   image is a BW img
%   covariance = miu_11; variance = miu_02 or miu_20;

%%
[m, n] = size(img);
M_00 = rawmoment(img,0,0);
M_10 = rawmoment(img,1,0); % mean x
M_01 = rawmoment(img,0,1); % mean y
centroid_x = M_10/M_00;
centroid_y = M_01/M_00;

miu_pq = 0;
for i=1:m
    for j=1:n
        diff_x = (i-centroid_x) ^ p;
        diff_y = (j-centroid_y) ^ q;
        I_xy = img(i,j);
        miu_pq = miu_pq + (diff_x * diff_y * I_xy);
    end
end


end
