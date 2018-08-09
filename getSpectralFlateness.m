function [ spec_flatness R lp time_taken] = getSpectralFlateness(y,fs,p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

tic;





%% lp analysis

frame_length=floor(fs*0.02);
frame_length=floor(frame_length);
inc=floor(frame_length/2);
frames=enframe(y,hamming(frame_length),inc);
lp=lpc(frames',p);
[rows cols]=size(frames);


%% cal residual

R=zeros(rows,cols);

for i=1:rows
     r=filter(lp(i,:),1,frames(i,:));
    
     R(i,:)=r;
end

%residual_sig=overlapadd(R,hamming(frame_length),inc);
 
residual_sig=overlapadd(R,v_windows('rectangle',frame_length),inc);

%recon_sig=overlapadd(frames); %% reconstructing signal from frames for 1 to 1  correspondance with residual
%  subplot(3,1,1)
%  plot(recon_sig)
%  subplot(3,1,2)
%  plot(residual_sig)

%% cal spectral flatness 
frames_residual=enframe(residual_sig,floor(0.002*fs),floor(0.002*fs));
frames_signal=enframe(y(1:length(residual_sig)),floor(0.002*fs),floor(0.002*fs));

energy_residual=energy_s(frames_residual');
energy_signal=energy_s(frames_signal');

spec_flatness=energy_signal./energy_residual;
 
time_taken=toc;

end

