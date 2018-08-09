function [w time_taken] = getWeights(spec_flatness,freq)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
tic;
ind=find(spec_flatness==-Inf);
spec_flatness(ind)=0;
alpha_g=0.75;
delta_0=(max(spec_flatness)-min(spec_flatness))*0.5;
%delta_0=mean(spec_flatness);

% 
% for i=1:length(spec_flatness)
%     delta_k=((0.8-0.2)/2*(tanh(alpha_g*pi*(spec_flatness(i)-delta_0))))+(0.8+0.2)/2;
%     w=repmat(delta_k,freq,1);
%     weights=[weights;w];
%     
% end

 delta_k1=((0.8-0.2)/2).*tanh(alpha_g*pi.*(spec_flatness-delta_0))+(1)/2;
  %delta_k1=delta_k1';
  w=repmat(delta_k1',1,freq)';
  w=w(:)';

time_taken=toc;

end

