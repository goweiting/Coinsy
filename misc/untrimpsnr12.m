%clc;clear;
close all;
x=rgb2gray(imread('/home/goweiting/Documents/IVR/01a.CW1/misc/img/AdditiveColor.svg.png'));
%x =imresize(x,[512 512]);
NOISE_VAR = 0.1;
y = imnoise(x,'salt & pepper',NOISE_VAR);

y = double(y);
Y = y;
[R C] = size(x);

for i = 2:R-1
    for j = 2:C-1

        tmp = y(i-1:i+1,j-1:j+1);

        S = sort(tmp(:));
        if(Y(i,j) == 0 || Y(i,j) == 255)
            H=0;
            for  m=1:9
             if(S(m)==0 || S(m) == 255)
                     H=H+1;
                end
            end
            if(H==9)
                Y(i,j)=mean2(tmp);
            else
                R=S(S>0);
                S1=R(R<255);
                S2= sort(S1);
                L=length(S2);
                if(rem(L,2)==0)
                     G=S2(L/2)+S2((L/2)+1);
                     Y(i,j)=round(G/2);
                else
                    Y(i,j)=S2((L+1)/2);
                end
            end
        end



    end
end

% Border Correction
Y(1,:) = Y(2,:);
%Y(R,:) = Y(R-1,:);
Y(:,1) = Y(:,2);
Y(:,C) = Y(:,C-1);
%y=single(y);
f = medfilt2(y,[3 3]);
%f=single(f);
figure;imshow(x,[]);title('Given Image');
figure;imshow(y,[]);title('Noisy image ');
figure;imshow(f,[]);title('Traditional Median');
figure;imshow(Y,[]);title('un trimmed');
x=double(x);
i= sum(sum(x-f).^2);
m=i/(262144);
ie=sum(sum(y-x).^2);
ief=ie/i;
disp(ief)
psnr=10*log10((261121)/m);
disp(psnr);
