function [labels weights_frame] = getLabels(w,index,c)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if c(1)>c(2)
    background=2;
    foreground=1;
else
    background=1;
    foreground=2;
end    

[row col]=size(w);

count_positive=sum(index==foreground,2);
%count_negative=sum(index==background,2);
labels=count_positive>floor(0.99*882);

weights_frame=sum(w,2)./col;
end

