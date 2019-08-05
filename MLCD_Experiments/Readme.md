This folder contains the performance measure(s) computed for the case studies in original MLCD paper.

F-measures
-----------
* F-measures folder contains the F-scores computed to perform a comparitive study of metric performance on material science datasets.
* Each .mat file is a MATLAB cell with rows as the following distance metrics in the order specfiied here:
	1.Euclidean
	2.Cosine
	3.Correlation
	4.Standarized Euclidean(seuclidean)
	5.City Block
	6.Minkowski
	7.Chebychev
	8.Hamming
	9.Jaccard
	10.MT-LMNN
	11.DTW
* Corresponding clustering settings for any row in a given metric cell can be looked up from the relevant .txt file provided.

ttest
-----
* ttest folder contains CSV files corresponding to various performance measures computed. 
* Clustering settings used to compute the performance measures are also provided as text files. Each line in the text file correspond to relvant row in CSV file for a given metric.
