# MultiVariate Effect (MVE) versus second order MulitVariate Effect (sMVE) for BOLD fMRI data 
Matlab codes to compute MultiVariate Effect (MVE) based on Crossnobis distance and second-order Multi-Variate Effect (sMVE) based on Geodesic distance from BOLD fMRI data explained in the paper: 
### "Coordinated multivoxel coding beyond univariate effects is not likely to be observable in fMRI data"

Authors: Mansooreh Pakravan, Mojtaba Abbaszadeh and Ali Ghazizadeh

Published in NeuroImage 2022

## How to use for fMRI data:
  1) Preprocess your fMRI data 
  2) Conduct GLM analysis to extract the residuals
  3) Use CosMoMVPA toolbox to extract BOLD values in each searchlight (https://github.com/CoSMoMVPA/CoSMoMVPA)
  4) Concatenate the blocks of each task condition to make one matrix for each condition (size  of the matrices: the number of TRs x number of voxels in the searchlight, the same Y1 and Y2 in the input of functions)
  5) Compute Crossnobis distance from  BOLD signal (MVE) with using "CompareMeans_CrossnobisDistance.m" function  
  6) Compute Geodesic distance from GLM residuals (sMVE) with using "CompareCovariances_GeodesicDistance.m" function
  7) Repeat 5 and 6 steps for all of the searchlights
  8) Plot a brain-wide map of MVE and sMVE activations 
  

<img src="https://github.com/Mansooreh-Pakravan/MultiVariate-Effect-MVE-and-second-order-Multi-Variate-Effect-sMVE-for-fMRI-data/blob/main/MVE_vs_sMVE.png" width=75% height=75%>

### License
This project is free and open source for academic/research purposes (non-commercial).

### Problems or questions
If you have any problems or questions, please contact the author: Mansooreh Pakravan (email: mpakravan at modares dot ac dot ir)
