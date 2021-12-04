function [Creal,Cperm] = CompareMeans_CrossnobisDistance(train_data,test_data,train_targets,test_targets,ndatsets)
  
%% Mansooreh Pakravan
%% this function is in the format of a classifier

%% inputs:
% train_data = searchlight samples with size N (number of samples) x V
% (numer of voxels or features) for training
% train_targets = corresponding labels with size 1xN
% test_data = searchlight samples with size N (number of samples) x V
% (numer of voxels or features) for testing
% test_targets = corresponding labels with size 1xN

%% ouputs:
% Creal = Crossnobis distance for original data
% Cperm = Crossnobis distances for permuted data

%% Original Paper for crossnobis distance: 
%Walther, A., H. Nili, N. Ejaz, A. Alink, N. Kriegeskorte, and J. Diedrichsen, 2016: Reliability of dissimilarity measures for multi-voxel pattern analysis. Neuroimage, 137, 188–200.

tr1 = find(train_targets==1);
tr2 = find(train_targets==2);
te1 = find(test_targets==1);
te2 = find(test_targets==2);
mt = min([length(tr1),length(tr2),length(te1),length(te2)]);

xAtr = train_data(tr1(1:mt),:);
xBtr = train_data(tr2(1:mt),:);        
xAte = test_data(te1(1:mt),:);
xBte = test_data(te2(1:mt),:);
        
Creal = Crossnobis_Core(xAtr,xBtr,xAte,xBte);

Cperm = zeros(1,ndatsets);
for nds = 1:ndatsets

    %% permuting the data
    xtr = [xAtr;xBtr];
    ind = randperm(size(xtr,1));
    xtr = xtr(ind,:);
    xte = [xAte;xBte];
    ind = randperm(size(xte,1));
    xte = xte(ind,:);

    xatr = xtr(1:size(xAtr,1),:);
    xbtr = xtr(size(xAtr,1)+1:size(xAtr,1)+size(xBtr,1),:);
    xate = xte(1:size(xAte,1),:);
    xbte = xte(size(xAte,1)+1:size(xAte,1)+size(xBte,1),:);

    Cperm(nds) = Crossnobis_Core(xatr,xbtr,xate,xbte);
end
end

function cvmah0 = Crossnobis_Core(xAtr,xBtr,xAte,xBte)

    nV = size(xAtr,2);

    sigmaAtr = cov(xAtr);
    sigmaBtr = cov(xBtr);
    sigmaAte = cov(xAte);
    sigmaBte = cov(xBte);
    % or yoy can use robust cov but it is time consuming!
    % sigmaAtr = robustcov(xAtr);
    % sigmaBtr = robustcov(xBtr);
    % sigmaAte = robustcov(xAte);
    % sigmaBte = robustcov(xBte);

    Sigma = (sigmaAte+sigmaBte+sigmaAtr+sigmaBtr)/4;
    iSigma = pinv(Sigma);

    d12 = real(sqrt((xAtr-xBtr)*iSigma*(xAte-xBte)'));
    d21 = real(sqrt((xAtr-xBte)*iSigma*(xAtr-xBte)'));
    d11 = real(sqrt((xAtr-xAte)*iSigma*(xAtr-xAte)'));
    d22 = real(sqrt((xBtr-xBte)*iSigma*(xBtr-xBte)'));

    cvmah0 = (mean(d12(:))+mean(d21(:)))-(mean(d11(:))+mean(d22(:)));
    cvmah0 = cvmah0/nV;
end