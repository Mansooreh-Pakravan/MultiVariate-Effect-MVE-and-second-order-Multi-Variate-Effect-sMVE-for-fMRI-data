function [X2,R] = Simulation_rotate_samples(X1,ang)
% define the x- and y-data for the original line we would like to rotate
if size(X1,1)==2
    X1 = X1';
    class_mean = mean(X1); % class mean
    Z1 = bsxfun(@minus,X1,class_mean); % residuals
    % define a 60 degree counter-clockwise rotation matrix
    R = eye(length(class_mean));

    R(1:2,1:2) = [cos(ang) -sin(ang); sin(ang) cos(ang)];
    % do the rotation...
        % shift points in the plane so that the center of rotation is at the origin

    so = Z1*R;           % apply the rotation about the origin

    X2 = bsxfun(@plus,so,class_mean); % residuals
    X2 = X2';
else
    X1 = X1';
    class_mean = mean(X1); % class mean
    Z1 = bsxfun(@minus,X1,class_mean); % residuals

    % define a 60 degree counter-clockwise rotation matrix
    R = eye(length(class_mean));
    for i=1:2:floor(length(class_mean)/2)
        
        R(i:i+1,i:i+1) = [cos(ang) -sin(ang); sin(ang) cos(ang)];
        
    end
    % do the rotation...
        % shift points in the plane so that the center of rotation is at the origin

    so = Z1*R;           % apply the rotation about the origin
    X2 = bsxfun(@plus,so,class_mean); % residuals
    X2 = X2';
end

