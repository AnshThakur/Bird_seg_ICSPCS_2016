addpath('gmm');
%% read
[x fs]=audioread('test_p.wav');

%% pre-emphasis

x=x';
y=x-0.99*[0 x(1:length(x)-1)];



%% get spectral flatness
p_sf=14; % order used for spectral flatness
frame_length=floor(0.002*fs);
[spec_flatness  R lp time] = getSpectralFlateness(y,fs,p_sf);

sf=smoothing(db(spec_flatness),frame_length+1);
w=getWeights(sf,frame_length);

%% k-means
[index c]=kmeans(w',2);

%% mapping spectral flatness to frame labels
frame_length=floor(fs*0.02);
inc=floor(frame_length/2);
frames_sig=enframe(x,hamming(frame_length),inc);
frames_w=enframe(w,rectwin(frame_length),inc);
frames_index=enframe(index,rectwin(frame_length),inc);
[labels weights_frame]=getLabels(frames_w,frames_index,c);

%% get first estimate
activity_labels=find(labels==1);
background_labels=find(labels==0);

if length(activity_labels)>1000
    len=1000;
else
    len=length(activity_labels)-10; %% choosing some of the bird frames for training, depends on the possible number of calls
end

if length(background_labels)>10000
    back=10000;
else
    back=length(background_labels)-250; %% choosing some of the background frames for training
end


sf_sum_activity=weights_frame(activity_labels);
sf_sum_background=weights_frame(background_labels);

[activity index_activity]=sort(sf_sum_activity,'descend');
[background index_background]=sort(sf_sum_background);


% labeled info
activity_labels=activity_labels(index_activity(1:len));
background_labels=background_labels(index_background(1:back));


% generate ISF prior

prior_activity=weights_frame;
prior_background=1-weights_frame;

%% GET mfcc FEATURES
mfcc=melcepst(x,fs,'MEdD',12,floor(3*log(fs)),frame_length,inc);

%% training GMM

activity_features=mfcc(activity_labels,:);
background_features=mfcc(background_labels,:);

[m1,v1,w1]=gaussmix(activity_features,[],[],1,'v');
gmm_activity.mean=m1;
gmm_activity.covariance=v1;
gmm_activity.weights=w1;


[m2,v2,w2]=gaussmix(background_features,[],[],1,'v');
gmm_background.mean=m2;
gmm_background.covariance=v2;
gmm_background.weights=w2;

[r c]=size(prior_activity);
% background_gmm=fitgmdist(background_features,1,'Options',options);
results=classify(mfcc(1:r,:),gmm_activity,gmm_background,prior_activity,prior_background);

%% plots

figure;
subplot(2,1,1);
spgrambw(x,fs,'J',90.5/2);
ylim([0 10000])
title('Spectrogram');
subplot(2,1,2);
plot(results);
title('Decisions');
xlabel('Frame Index') % x-axis label
ylabel('Result')
xlim([0 662])



