function [ results ] = classify( mfcc,activity,background,prior_activity,prior_background)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[activity_likelihood] = gmmb_pdf(mfcc, activity.mean',activity.covariance,activity.weights);
[background_likelihood] = gmmb_pdf(mfcc, background.mean',background.covariance,background.weights);


posterior_activity=(prior_activity.*activity_likelihood);
posterior_background=(prior_background.*background_likelihood);


results=posterior_activity>posterior_background;


end

