# -*- coding: utf-8 -*-
"""
To compute various sklearn implemented clustering performance evaluation
measures for MLCD paper

% (c) Copyright Kiran Vaddi 2019
"""

from sklearn import metrics
import pandas as pd
import numpy as np
import os
from scipy.io import loadmat
def classification_report_csv(labels_true,labels_pred,fname):
    report_data = []
    for row in range(0, labels_pred.shape[0]):
#        print(row)
#        print(labels_pred[row,:])

        rowmat = {}
        ARI = metrics.adjusted_rand_score(labels_true, labels_pred[row,:])  
        AMI = metrics.adjusted_mutual_info_score(labels_true, labels_pred[row,:]) 
        NMI = metrics.normalized_mutual_info_score(labels_true, labels_pred[row,:])
        FMS = metrics.fowlkes_mallows_score(labels_true, labels_pred[row,:])
        rowmat['ARI'] = float(ARI)
        rowmat['AMI'] = float(AMI)
        rowmat['NMI'] = float(NMI)
        rowmat['FMS'] = float(FMS)
        report_data.append(rowmat)
    dataframe = pd.DataFrame.from_dict(report_data)
    file_name = os.getcwd()+'/'+fname + '.csv'
    # print(file_name)
    dataframe.to_csv(file_name, index = False)
 
def report_for_givenfolder(indxmat,gtmat,dirname):
    direc_indx = os.getcwd()
    labels_pred = loadmat(direc_indx+'/IndxFiles/'+indxmat+'.mat')
    labels_true = loadmat(direc_indx+'/IndxFiles/'+gtmat+'.mat')
    keys = list( labels_pred.keys() )
    indxcell = keys[-1]
    labels_pred = labels_pred[indxcell]
    labels_true = np.transpose(labels_true['dataClass']).ravel()
    fnames = ['Euclidean','Cosine','Correlation','seuclidean','CityBlock',\
        'Minkowski','Chebychev','Hamming','Jaccard','mt-lmnn','dtw']
	# Create target Directory if don't exist
    if not os.path.exists(dirname):
        os.mkdir(dirname)
        print("Directory " , dirname ,  " Created ")
    else:    
        print("Directory " , dirname ,  " already exists")
    for metric in range(0, labels_pred.shape[1]):
        current_labels_pred = np.transpose(labels_pred.item(metric))
        extended_fname = dirname+'/'+fnames[metric]
        classification_report_csv(labels_true,current_labels_pred,extended_fname)   


# Sample Usage: (The following creates a folder with a 
# csv file with different measures)

report_for_givenfolder('seta1_indxcell','cvgroundtruth','test_SETA1')










