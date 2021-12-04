clc
clear all

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Matlab codes to compute MultiVariate Effect (MVE) and second-order Multi-Variate Effect (sMVE) explained in the paper:
% % Coordinated multivoxel coding beyond univariate effects is not likely to be observable in fMRI data 
% % Authors: Mansooreh Pakravan, Mojtaba Abbaszadeh and Ali Ghazizadeh
% % Published in NeuroImage 2022
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please cite to this paper if you use this Code ;)

nSamples = [50:50:500];
nVoxels = 20;
SNR = 0;%[0,20];
Niter = 100;

Ang = 3*pi/4;
intr1 = 0.1;
intr2 = 0.6;
Amp1 = 1;
Amp2 = 4;

Greal = zeros(Niter,length(nSamples),length(nVoxels));
Gperm = zeros(Niter,length(nSamples),length(nVoxels));
Creal = zeros(Niter,length(nSamples),length(nVoxels));
Cperm = zeros(Niter,length(nSamples),length(nVoxels));

ndatsets = 99; %p-value=0.01 , for pvalue=0.001 -> set ndatsets=999

for iter =1:Niter
    for iT = 1:length(nSamples)
    
        rng('default')
        d = nSamples(iT);
        
        for iV=1:length(nVoxels)

            %% Simulate simple normal data with predefied mean and covariance
            sigma=10^(-SNR/20);
            covM = sigma*eye(nVoxels);  
            noise = randn(d,nVoxels);
            noise = sigma*bsxfun(@minus, noise, mean(noise));

            mu1 = Amp1*ones(1,nVoxels);
            mu2 = Amp2*ones(1,nVoxels);
            Sig1 = eye(nVoxels,nVoxels)+intr1*ones(nVoxels,nVoxels)-diag(diag(intr1*ones(nVoxels,nVoxels)));
            Sig2 = eye(nVoxels,nVoxels)+intr2*ones(nVoxels,nVoxels)-diag(diag(intr2*ones(nVoxels,nVoxels)));
                       
            rng(iter)
            S1 = mvnrnd(mu1,Sig1*Sig1',d);
            Y1 = S1;        
            S2 = mvnrnd(mu2,Sig2*Sig2',d);
            Y2 = S2;
            [Y2,Rot] = Simulation_rotate_samples(Y2',Ang);    
            Y2 = Y2';

            %% Compute second-order Multi-Variate Effect (sMVE) using Geodesic distance
            [Greal(iter,iT,iV),Gp0] = CompareCovariances_GeodesicDistance(Y1,Y2,ndatsets);
            Gperm(iter,iT,iV) = max(Gp0);
            
            %% Compute Multi-Variate Effect (sMVE) using Crossnobis distance
            R = 20; % number of splittings
            C0 = zeros(1,R);
            Cp0 = zeros(1,R);    
            for r=1:R
                K = size(Y1,1);
                rK = randperm(K);
                k = floor(K/2);

                Split1 = [Y1(rK(1:k),:);Y2(rK(1:k),:)];
                Split2 = [Y1(rK(k+1:K),:);Y2(rK(k+1:K),:)];

                Split1_targets = [ones(k,1);2*ones(K-k,1)];
                Split2_targets = [ones(k,1);2*ones(K-k,1)];

                [C0(r),Cp00] = CompareMeans_CrossnobisDistance(Split1,Split2,Split1_targets,Split2_targets,ndatsets);
                Cp0(r) = max(Cp00);
            end
            Creal(iter,iT,iV) = mean(C0);
            Cperm(iter,iT,iV) = mean(Cp0);

        end

    end
end

%% Plot the results
close all
myplot(Creal,Cperm,nVoxels,nSamples,'Crossnobis Distance')
myplot(Greal,Gperm,nVoxels,nSamples,'Geodesic Distance')

function myplot(real,perm,Nvoxels,NT,tit)
    
    nsamp = 100;

    figure
    fontname= 'Cambria';
    set(0,'defaultaxesfontname',fontname);
    set(0,'defaulttextfontname',fontname);
    fontsize = 10;
    set(0,'defaultaxesfontsize',fontsize);
    set(0,'defaulttextfontsize',fontsize)

    for iV=1:length(Nvoxels)

        hold on
        myerrorbar(NT,squeeze(mean(real(:,:,iV),1)),mean(bootstrp(nsamp,@std,squeeze(real(:,:,iV)))),'g',1);
        myerrorbar(NT,squeeze(mean(perm(:,:,iV),1)),mean(bootstrp(nsamp,@std,squeeze(perm(:,:,iV)))),'r',1);
        plot(NT,squeeze(mean(real(:,:,iV),1)),'color','g','LineWidth',3);
        plot(NT,squeeze(mean(perm(:,:,iV),1)),'color','r','LineWidth',3);
        xlabel('#Samples')
        title(tit)
        
    end

    HL = legend('Original data','Shuffled data','Location','northeast');
    set(HL,'box','off')

end
