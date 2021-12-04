# MultiVariate Effect (MVE) versus second order MulitVariate Effect (sMVE) for BOLD fMRI data 
Matlab codes to compute MultiVariate Effect (MVE) based on Crossnobis distance and second-order Multi-Variate Effect (sMVE) based on Geodesic distance from BOLD fMRI data explained in the paper: "Coordinated multivoxel coding beyond univariate effects is not likely to be observable in fMRI data"

Authors: Mansooreh Pakravan, Mojtaba Abbaszadeh and Ali Ghazizadeh
Published in NeuroImage 2022

Procedure:
  1) Preprocess your fMRI data 
  2) Conduct GLM analysis to extract the residuals
  3) Use CosMoMVPA toolbox to extract BOLD values in each searchlight (https://github.com/CoSMoMVPA/CoSMoMVPA)
  4) Concatenate the blocks of each task condition to make one matrix for each condition (size  of the matrices: the number of TRs x number of voxels in the searchlight, Y1 and Y2 in the functions)
  5) Compute Crossnobis distance from  BOLD signal (MVE) and Geodesic distance from GLM residuals (sMVE) for each searchlight
  6) Plot a brain-wide map of MVE and sMVE activation 
  

<img src="https://github.com/Mansooreh-Pakravan/MultiVariate-Effect-MVE-and-second-order-Multi-Variate-Effect-sMVE-for-fMRI-data/blob/main/MVE_vs_sMVE.png" width=75% height=75%>


