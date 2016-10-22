function [out] = mdbutmfg(im, K, n)
% Modified decision based unsymmetric trimmed median filter for gray image 
% im    = input image
% K     = length to compute window win=(2*l)+1
% n     = Noise density of Salt & Pepper Noise
% out   = output image

% Code Developed BY : Suraj Kamya
% kamyasuraj@yahoo.com
% Visit to: kamyasuraj.blogspot.com

% Other used files
% rpadd     - removing padding
% trimf     - trimmed meadian filter
% PSN       - Peak Signal to noise ratio
% IEF       - Image Enhancement Factor

close all
% For example:
% im=imread('bgray.jpg');
% K=1;
% n=0.1;
% out=mdbutmfg(im,K,n);

imwrite(im,'in.jpg','Mode','Lossless')
figure, imshow(im), title('original')
win=(2*K)+1; % window size

% Add Salt & pepper noise
nim=imnoise(im,'Salt & Pepper',n);
imwrite(nim,'nim.jpg','Mode','Lossless')
figure,imshow(nim)
title('salt & pepper');

% Padding
proci=padarray(nim,[K K],'replicate'); % proci = image for processing
[row clm]=size(proci); % Size of image
nim=proci;

L=[-K:K];
c=K+1; % c,c is the position of centre element
iter=length(L); % iterations
N=[0 255]; % Components of Salt & Pepper Noise

% Applying MDBUTMF for Gray Image %%
% Create waitbar.
h = waitbar(0,'Wait...');
set(h,'Name','MDBUTMF');

for r=(1+K):(row-K) % Indexing Row of noisy pixel        
    for s=(1+K):(clm-K) % Indexing Coloumn of noisy pixel
        
                % Remove Noise from Image
                pixR=nim(r,s); % nim= noisy image
                if  pixR==255 || pixR==0 % Checking for Noisy Pixel                          
                    for i=1:iter % Indexing Row of window
                        for j=1:iter % Indexing Column of window                
                            wnim(i,j)=nim((r+L(i)),(s+L(j))); % Extracting noisy window                    
                        end
                    end
                    % Checking complete winow is noisy or not
                    % If it is noisy then replace by mean of the pixel.
                    N1=find(wnim==255); N2=find(wnim==0);  
                    if (length(N1)+length(N2))==9
                        rp=mean(wnim(:));                                        
                    else
                        rp=trimf(wnim); % Calling Trimmed mean filter                                        
                    end
                    proci(r,s)=rp; % Raplacing noisy pixel in orignal image.               
                end                               
    end
waitbar(r/(row-r));
end
close(h)

out=rpadd(proci,K); % Calling another function to remove padding
figure,imshow(out)
imwrite(out,'out.jpg','Mode','Lossless')

% Quality Measure %%
orgimg=im2double(imread('in.jpg'));
nimg=im2double(imread('nim.jpg'));
dimg=im2double(imread('out.jpg'));  

disp('PSNR'), psn=PSN(orgimg,dimg); disp(psn); % PSNR
disp('IEF'), I=IEF(orgimg,nimg,dimg); disp(I);