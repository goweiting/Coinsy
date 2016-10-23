function r1 = background(p1,p2,p3,p4,p5,p6,p7,p8,p9)


first_pic = p1;
r1 = p2;
pic_size = size(first_pic);
m = pic_size(1,1);
n = pic_size(1,2);

%comment
for i = 1:m
    for j = 1:n
        r1(i,j,1) = myMedian(p1,p2,p3,p4,p5,p6,p7,p8,p9,i,j,1);
        r1(i,j,2) = myMedian(p1,p2,p3,p4,p5,p6,p7,p8,p9,i,j,2);
        r1(i,j,3) = myMedian(p1,p2,p3,p4,p5,p6,p7,p8,p9,i,j,3);
    end
end

end

function result = myMedian(p1,p2,p3,p4,p5,p6,p7,p8,p9,i,j,z)
array = [p1(i,j,z) p2(i,j,z) p3(i,j,z) p4(i,j,z) p5(i,j,z) p6(i,j,z) p7(i,j,z) p8(i,j,z) p9(i,j,z)];
result = median(array);
end