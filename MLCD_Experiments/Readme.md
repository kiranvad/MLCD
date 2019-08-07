This folder contains the performance measure(s) computed for the case studies in original MLCD paper.

F-measures
-----------
* F-measures folder contains the F-scores computed to perform a comparative study of metric performance on material science datasets.
* Each .mat file is a MATLAB cell with rows as the following distance metrics in the order specified here:

1. Euclidean
2. Cosine
3. Correlation
4. Standardized Euclidean(seuclidean)
5. City Block
6. Minkowski
7. Chebychev
8. Hamming
9. Jaccard
10. MT-LMNN
11. DTW

* Corresponding clustering settings for any row in a given metric cell can be looked up from the relevant .txt file provided.

ttest
-----
* ttest folder contains CSV files corresponding to various performance measures computed to perform a sophisticated, statistical t-test (one-sided, paired with a significance level of 0.01) to naturally asses the following Null hypothesis: 

> H0 : mt-lmnn is comparable to the best performing measure

* Clustering settings used to compute the performance measures are also provided as text files. Each line in the text file correspond to relevant row in CSV file for a given metric.

demo
----
A python file is also provided to compute various performance measures used in the original Paper on MLCD. One first needs to create a CSV file with different performance measures

This can be done using the following pieces of codes in Python with in the ttest directory:

> python cluster_performance.py

This code creates CSV files for `SETA1` dataset and can be modified to do the same for other datasets provided in `IndxFiles` folder

Once the CSV files are created in a directory, you can then perform a one-sided paired t-test using the file provided in MATLAB:
 	
> perform_ttest(your_directory_name)

The programs were tested on Python 3 and MATLAB 2018b.




















