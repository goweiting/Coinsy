function thehist = dohist(theimage, show)
%% 
% computes the histogram of a given image into num bins.
% values less than 0 go into bin 1, values bigger than 255
% go into bin 255
% if show=0, then don't show. Otherwise show in figure(show)

%%
% set up bin edges for histogram
edges = zeros(256,1);
for i = 1 : 256;
    edges(i) = i-1;
end


if ndims(theimage) == 2 
    [R,C] = size(theimage);
    imagevec = reshape(theimage,1,R*C);      % turn image into long array
    thehist = histc(imagevec,edges)';        % do histogram
elseif ndims(theimage)==3
    [r,c,chn] = size(theimage);
    imagevec = reshape(theimage,1,r*c*chn);
    thehist = histc(imagevec, edges);
    
end


if show > 0
  figure(show)
  clf
  pause(0.1)
  plot(edges,thehist)
  axis([0, 255, 0, 1.1*max(thehist)])
end
