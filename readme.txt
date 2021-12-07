**************************************************************************
This Github project has two key functions:

1) CompareMeans_CrossnobisDistance.m
This function computes MVE using Crossnobis distance for original and shuffled data.
inputs:
Split1 = searchlight samples with size N (number of samples) x V (number of voxels or features) for Split1 Split1_targets = corresponding labels with size 1xN
Split2 = searchlight samples with size N (number of samples) x V(number of voxels or features) for Split2
Split2_targets = corresponding labels with size 1xN
nShuffling = number of permutation tests (or shufflings)
outputs:
Creal = Crossnobis distance for original data (scalar)
Cperm = Crossnobis distances for permuted data (1 x ndatasets)

2) CompareCovariances_GeodesicDistance.m
This function computes second-order MVE using Geodesic distance for original and shuffled data.
inputs:
Y1 = BOLD activities of the searchlight for condition 1
Y2 = BOLD activities of the searchlight for condition 2 
The dimension of Y1 and Y2 is N(number of samples) x V(number of voxels in the searchlight)
nShuffling = number of permutation tests (or shufflings)
outputs:
Greal = Geodesic distance for original data (1 x 1)
Gperm = Geodesic distances for permuted data (1 x nShuffling)

There is also a main script "Main_Simulation.m" that simply generates two clouds of data (Y1 and Y2) with normal distribution and predefined different mean and covariance matrices for each of Y1 and Y2.
This script calls CompareMeans_CrossnobisDistance.m and CompareCovariances_GeodesicDistance.m functions to compute MVE and sMVE from these simulated data and plot the results versus the number of samples.

************************************************************************
The application of these functions is explained completely in the paper 
"Coordinated multivoxel coding beyond univariate effects is not likely to be observable in fMRI data"
Authors: Mansooreh Pakravan, Mojtaba Abbaszadeh, and Ali Ghazizadeh
Published in NeuroImage 2022

Please cite if you want to use ;)

Abstract of the paper:
Simultaneous recording of activity across brain regions can contain additional information compared to regional recordings done in isolation. In particular, multivariate pattern analysis
(MVPA) across voxels has been interpreted as evidence for distributed coding of cognitive or sensorimotor processes beyond what can be gleaned from a collection of univariate effects (UVE)
using functional magnetic resonance imaging (fMRI). Here, we argue that regardless of patterns revealed, conventional MVPA is merely a decoding tool with increased sensitivity arising from
considering a large number of ‘weak classifiers’ (i.e., single voxels) in higher dimensions.
We propose instead that ‘real’ multivoxel coding should result in changes in higher-order statistics across voxels between conditions such as second-order multivariate effects (sMVE).
Surprisingly, analysis of conditions with robust multivariate effects (MVE) revealed by MVPA failed to show significant sMVE in two species (humans and macaques). Further analysis showed
that while both MVE and sMVE can be readily observed in the spiking activity of neuronal populations, the slow and nonlinear hemodynamic coupling and low spatial resolution of fMRI
activations make the observation of higher-order statistics between voxels highly unlikely. These results reveal inherent limitations of fMRI signals for studying coordinated coding across voxels.
Together, these findings suggest that care should be taken in interpreting significant MVPA results as representing anything beyond a collection of univariate effects.

	