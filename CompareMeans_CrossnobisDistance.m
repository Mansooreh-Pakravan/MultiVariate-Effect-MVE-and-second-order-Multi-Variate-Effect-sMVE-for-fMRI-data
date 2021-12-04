function [Creal,Cperm] = CompareMeans_CrossnobisDistance(Split1,Split2,Split1_targets,Split2_targets,ndatsets)
  
%% Mansooreh Pakravan

%% inputs:
% Split1 = searchlight samples with size N (number of samples) x V
% (number of voxels or features) for Split1
% Split1_targets = corresponding labels with size 1xN
%Split2 = searchlight samples with size N (number of samples) x V
% (number of voxels or features) for Split2
% Split2_targets = corresponding labels with size 1xN

%% outputs:
% Creal = Crossnobis distance for original data
% Cperm = Crossnobis distances for permuted data

tr1 = find(Split1_targets==1);
tr2 = find(Split1_targets==2);
te1 = find(Split2_targets==1);
te2 = find(Split2_targets==2);
mt = min([length(tr1),length(tr2),length(te1),length(te2)]);

xAtr = Split1(tr1(1:mt),:);
xBtr = Split1(tr2(1:mt),:);        
xAte = Split2(te1(1:mt),:);
xBte = Split2(te2(1:mt),:);
        
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
