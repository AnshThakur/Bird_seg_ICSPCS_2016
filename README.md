# Bird_seg_ICSPCS_2016
Model-based unsupervised segmentation of birdcalls from field recordings

An unsupervised, species independent method to segment birdcalls from the background
in bioacoustic recordings is implemented. The method follows a two-pass approach.
An initial segmentation is performed utilizing K-means
clustering. This provides labels to train Gaussian mixture acoustic
models, which are built using Mel frequency cepstral coefficients.
Using the acoustic models, the segmentation is refined further
to classify each short-time frame as belonging either to the
background or to call-activity. Different features, namely shorttime
energy, Fourier transform phase-based entropy and inverse
spectral flatness (ISF) are evaluated within the framework of the
proposed method. Our experiments with real field recordings
on two datasets reveal that the ISF reliably provides better
segmentation performance when compared to the other two
features.

Advantages: No thresholding, no train-test mismatch. 


Disadvatnges: Can't discriminate between bird and non-bird sounds. Outputs high SNR regions of the input recording. 
