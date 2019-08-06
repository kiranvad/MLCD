Metric Learning for Combinatorial Datasets
===========================================

This is a demo of Multi-Task metric learning framework introduced for combinatorial datasets.

We use the following packages available for free:

* [SpectralClustering suite](http://vision.ucsd.edu/~sagarwal/spectral-0.2.tgz)

* [Ternay plotting software](https://www.mathworks.com/matlabcentral/fileexchange/7210-ternary-plots)

The MLCD framework learns a Mahalanobis distance using MT-LMNN framework 
introduced in the following paper:

>Parameswaran, Shibin, and Kilian Q. Weinberger. 
>"Large margin multi-task metric learning."
>Advances in neural information processing systems. 2010

MT-LMNN code is NOT-distributed along with this package.

Extract the archive into a folder and change the MATLAB working directory 
to where you extracted the archive.

This demo folder can be used to do the following:

1. Generate synthetic data of a ternary space (used for MTML framework)
   For example: 

	`[c,data,phaseVal,dataClass]=getSynthData(30,350)`;

generates ternary composition array in `c`, synthetic data in `data`, degrees of freedom (DOFs) values in `phaseVal` and phase indices in `dataClass`

2. For a given distance metric, one can find a phase diagram of a ternary using Graph Partition or Hierarchical Clustering (see paper for more information) 
   For example: 

	Run `finaldemo.m` 

to produce phase diagram using Euclidean and Mahalanobis distance measure for a 4 sets of data given (SET A and B used in the paper)

Notes
------
* We have provided the exhaustive list of performance measures used for t-test in the original paper as a CSV file in  `MLCD_Experiments` folder. This folder also contains .mat files for F-measure used. 
* `finaldemo.m` file also contains instructions onto how to perform performance evaluation protocol.

