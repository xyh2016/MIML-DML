-------------------------------------------
--- MATLAB/OCTAVE interface of MIML-DML ---
-------------------------------------------

Table of Contents
=================
- Introduction
- Installation
- Usage
- Returned Model Structure
- Copyright Notice

Introduction
============
This tool provides the matlab code for Multi-Instance Multi-Label Distance Metric Learning for Genome-Wide Protein Function Prediction.It is very easy to use.

Installation
============
The CVX toolbox is a necessary component for this code. CVX can be download from: http://cvxr.com/cvx/download/. 

Example:
        matlab> cvx_setup
	  matlab> cvx_startup

Usage
=====
matlab> result=demo;

Result of Prediction
====================
The function 'MIML-DML' return a struct "result" which store the predict reslut. The result has detailed outputs:
[HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Average_Recall,Average_F1,Outputs,Pre_Labels,time]

- Outputs: output vector of our algorithm.
- Pre_Labels: predicted label vector of our algorithm.
- time: average runtime of this code.
- HammingLoss
- RankingLoss
- OneError
- Coverage
- Average_Precision
- Average_Recall
- Average_F1

Copyright Notice
=====
This procedure is for scientific use only and can not be used for commercial purposes. If you are going to use the program in a paper or work, please quote the following paper. 

Please refer to the following papers:
1. Xu, Y., et al. "Multi-instance multi-label distance metric learning for genome-wide protein function prediction." Computational Biology & Chemistry 63.C(2016):30-40.
2. Y. Xu et al., "A Unified Framework for Metric Transfer Learning," in IEEE Transactions on Knowledge and Data Engineering, vol. 29, no. 6, pp. 1158-1171, June 1 2017. doi: 10.1109/TKDE.2017.2669193

For any question, please contact Yonghui Xu <xu.yonghui@hotmail.com>
