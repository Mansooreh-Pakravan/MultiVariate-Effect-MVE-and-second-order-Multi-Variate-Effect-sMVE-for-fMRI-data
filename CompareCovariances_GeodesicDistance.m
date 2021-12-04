function [Greal,Gperm] = CompareCovariances_GeodesicDistance(Y1,Y2,ndatsets)

%% Mansooreh Pakravan 

%% inputs:
% Y1 = BOLD activities of the searchlight for condition 1
% Y2 = BOLD activities of the searchlight for condition 2 
% The dimension of Y1 and Y2 are N(number of samples) x V(number of voxels in the searchlight)

%% outputs:
% Greal = Geodesic distance for original data
% Gperm = Geodesic distances for permuted data

% remove mean effect
Y1 = bsxfun(@minus,Y1,mean(Y1));
Y2 = bsxfun(@minus,Y2,mean(Y2));

Greal = Compute_Comapre_Covarinaces(Y1,Y2);

Gperm = zeros(1,ndatsets);
for nds = 1:ndatsets

    [PermX1,PermX2] = Shuffling_Samples(Y1,Y2);
    Gperm(nds)= Compute_Comapre_Covarinaces(PermX1,PermX2);  

end

end

function Geo = Compute_Comapre_Covarinaces(Y1,Y2)

    % remove zero voxels
    s = sum(Y1);
    ind = find(s==0);
    Y1(:,ind)=[];
    Y2(:,ind)=[];

    s = sum(Y2);
    ind = find(s==0);
    Y1(:,ind)=[];
    Y2(:,ind)=[];

    if size(Y1,2)<2
        Geo=0;
    else  
        % you can use correlation
    %     Cov1 = corr(Y1);
    %     Cov2 = corr(Y2);  
        % or covariance
        Cov1 = cov(Y1);
        Cov2 = cov(Y2); 

        nV = size(Y1,2);
        EE = eig(Cov1,Cov2);  
        EE(EE==Inf)=[];   
        EE(EE==-Inf)=[]; 
        G = sqrt(sum(log(EE).^2));
        Geo = abs(G/nV);

    end
end

function [PermX11,PermX22] = Shuffling_Samples(PermX1,PermX2)

    d1 = size(PermX1,1);
    d2 = size(PermX2,1);
    d10 = floor(d1/2);
    d20 = floor(d2/2);

    ind1 = randperm(d1);
    PermX11 = [PermX1(ind1(1:d10),:);PermX2(ind1(d10+1:d1),:)];
    PermX22 = [PermX2(ind1(1:d10),:);PermX1(ind1(d20+1:d2),:)];

end
