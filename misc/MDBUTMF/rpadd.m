function x=rpadd(R,K)
% rpadd is to To remove padding
% R     = input matrix 
% K     = (2*K + 1) is the window size
% x     = output

% Code Developed BY : Suraj Kamya
% kamyasuraj@yahoo.com
% Visit to: kamyasuraj.blogspot.com

for i=1:K
    R(1,:)=[]; % Remove padding on the first and last col
    R(:,1)=[];
    [ro cl]= size(R);
    R(ro,:)=[]; % Romove padding on the first and last row
    R(:,cl)=[];;
end
x=R;