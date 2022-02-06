function [R, T] = estimateTransform(p1, p2)
% ESTIMATETRANSFORM Estimate rigid ransform between two sets of 3D points
% 
% The estimated transform should be the best fit between the given set of
% points, i.e. p1 * R + T should be (almost) equal to p2
%
% Inputs:
%   p1 : first set of 3D points (stored as a row-vectors)
%   p2 : second set of 3D points (stored as a row-vectors)
%
% Outputs:
%   R : rotation matrix (3x3 in MATLAB format)
%   T : translation vector (single row)

    % prepare output values
    R = eye(3);
    T = [0, 0, 0];

    %% =[ your code starts here ]===========================================
    
    % Checking for size
    
    if ~isequal(size(p1),size(p2))
        error('The points matrixs do not have the same size');
    end

    %Checking for Centroid of points
    p1_centroid = p1 - mean(p1, 1);
    p2_centroid = p2 - mean(p2, 1);
    
    % calculate covariance matrix
    H = p1_centroid' * p2_centroid;
    
    %Calculating Rotation through SVD
    % Singular Value Decomposition
    [U,S,V] = svd(H);
   
    %Rotation and translation
    R = (V * det(V*U') * U')';
    T = (R * mean(p2, 1)' - mean(p1, 1)')';
    
    % =[ your code ends here ]=============================================
    
end

