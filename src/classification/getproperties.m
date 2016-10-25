function vec = getproperties(image, prop)
%% getproperties(Image)
%   gets property vector for a binary shape in an image
%   properties extracted: 
%       1) Area
%       2) Perimeter
%       3) 
Image = image.Image;

[H,W] = size(Image);
area = bwarea(Image);
perim = bwarea(bwperim(Image,8));

% compactness
compactness = perim*perim/(4*pi*area);

% rescale properties so all have size proportional
% to image size
area_ = 4*sqrt(area);
compactness_ = H*compactness;

% rectangularity
bb_width = image.BoundingBox(3);
bb_height = image.BoundingBox(4);
area_bb = bb_width * bb_height;
rectangularity = area / area_bb; 

% Elongation - ratio of principal axis
elongation = prop.MajorAxisLength / prop.MinorAxisLength;

hu_invariant = humomentinvariants(Image);

% get scale-normalized complex central moments
c11 = complexmoment(Image,1,1) / (area^2);
c20 = complexmoment(Image,2,0) / (area^2);
c30 = complexmoment(Image,3,0) / (area^2.5);
c21 = complexmoment(Image,2,1) / (area^2.5);
c12 = complexmoment(Image,1,2) / (area^2.5);
%c=[c11,c20,c30,c21,c12]

% get invariants, scaled to [-1,1] range
ci1 = real(c11);
ci2 = real(1000*c21*c12);
tmp = c20*c12*c12;
ci3 = 10000*real(tmp);
ci4 = 10000*imag(tmp);
tmp = c30*c12*c12*c12;
ci5 = 1000000*real(tmp);
ci6 = 1000000*imag(tmp);

%ci=[ci1,ci2,ci3,ci4,ci5,ci6]

vec = [area_, perim, compactness_ , rectangularity, elongation, hu_invariant, ...
        ci1, ci2, ci3, ci4, ci5, ci6]; % 18 features


end
