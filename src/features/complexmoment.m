% gets a given complex central moment value
function c_uv = complexmoment(Image,u,v)

     [r,c] = find(Image==1);            % get (r,c) of region's pixels
     rbar = mean(r);
     cbar = mean(c);
     n = length(r);
     momlist = zeros(n,1);
     
     for i = 1 : n
       c1 = complex(r(i) - rbar, c(i) - cbar);
       c2 = complex(r(i) - rbar, cbar - c(i));
       momlist(i) = c1^u * c2^v;
     end
     
     c_uv = sum(momlist);
