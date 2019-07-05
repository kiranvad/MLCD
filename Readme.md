This is a demo of MTML framework introduced.

Please extract the archieve into a folder and change the matlab directory 
to where you extracted the archieve to

We use the following packages available for free online:

SpectralClustering suite from: 
http://vision.ucsd.edu/~sagarwal/spectral-0.2.tgz

Ternay plotting software from:
 https://www.mathworks.com/matlabcentral/fileexchange/7210-ternary-plots

The MTML framework learns a Mahalanobis distance using MT-LMNN framework 
introduced in the following paper:
Parameswaran, Shibin, and Kilian Q. Weinberger. 
"Large margin multi-task metric learning.
" Advances in neural information processing systems. 2010.

MT-LMNN code is NOT-ditributed along with this package.

This demo folder can be used to do the following:

1. Generate synthetic data of a ternary space (used for MTML framework)
   For example: [c,data,phaseVal,dataClass]=getSynthData(30,350);
                generate ternary compositon array in c, synthetic data in 'data'
                DOFs values in phaseVal and phase indicies in dataClass

2. For a given distance metric, find phase diagram of a ternay using Grpah Partition or
   Heirarchial Clustering (see paper for more information) 
   For example: Run finaldemo.m to produce phase diagram using Euclidean and
                Mahalanobis distance measure for a 4 sets of data given (
                SET A and B used in the paper)