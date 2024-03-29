function [vec] = humomentinvariants(img)
%% CALCULATE THE HU MOMENT INVARIANTS FOR GIVEN IMAGE
    vec(1) = SI_moment(img,2,0) + SI_moment(img,0,2);
    vec(2) = (SI_moment(img,2,0) - SI_moment(img,0,2))^2  + 4 * SI_moment(img,1,1) ^ 2;
    vec(3) = (SI_moment(img,3,0) - 3*SI_moment(img,1,2))^2 + ...
                (3*SI_moment(img,2,1) - SI_moment(img,0,3))^2;
    vec(4) = (SI_moment(img,3,0) + SI_moment(img,1,2))^2 + ...
                (SI_moment(img,2,1) + SI_moment(img,0,3))^2;
    vec(5) = (SI_moment(img,3,0) - 3*SI_moment(img,1,2)) * (SI_moment(img,3,0) + SI_moment(img,1,2)) * ...
                ((SI_moment(img,3,0) + SI_moment(img,1,2))^2 - 3*(SI_moment(img,2,1) + SI_moment(img,0,3))^2) + ...
                (3*SI_moment(img,2,1) - SI_moment(img,0,3)) * (SI_moment(img,2,1) + SI_moment(img,0,3)) * ...
                ((3*(SI_moment(img,3,0) + SI_moment(img,1,2))^2 - (SI_moment(img,2,1) + SI_moment(img,0,3))^2));
    vec(6) = (SI_moment(img,2,0) - SI_moment(img,0,2)) * ...
                ((SI_moment(img,3,0) + SI_moment(img,1,2))^2 - (SI_moment(img,2,1) + SI_moment(img,0,3))^2) + ...
                4 * SI_moment(img,1,1)  * (SI_moment(img,3,0) + SI_moment(img,1,2)) * (SI_moment(img,2,1) + SI_moment(img,0,3));
    vec(7) = (3*SI_moment(img,2,1) - SI_moment(img,0,3)) * (SI_moment(img,3,0) + SI_moment(img,1,2)) * ...
                ((SI_moment(img,3,0) + SI_moment(img,1,2))^2 - 3*(SI_moment(img,2,1) + SI_moment(img,0,3))^2) - ...
                (SI_moment(img,3,0) - 3*SI_moment(img,1,2)) * (SI_moment(img,2,1) + SI_moment(img,0,3)) * ...
                (3*(SI_moment(img,3,0) + SI_moment(img,1,2))^2 - (SI_moment(img,2,1) + SI_moment(img,0,3))^2);
end