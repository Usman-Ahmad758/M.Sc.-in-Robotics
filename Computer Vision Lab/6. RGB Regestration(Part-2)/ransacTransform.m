function [R, T] = ransacTransform(pts1, pts2, iter, ratio, thr)
% RANSACTRANSFORM Estimate the best transform R, T between the two given 
% point sets, such that pts1 * R + T are as close to pts2 as possible
%
% Inputs:
%   pts1 : first set of points, of size Nx3
%   pts2 : second set of points, of size Nx3
%   iter : maximum number of RanSaC iterations
%   ratio: inliers ratio for the transformation to be treated as good [0..1]
%   thr  : threshold between the points to be treated as the inlier (in meters)

    % prepare output values
    R = eye(3);
    T = [0, 0, 0];
    
    % remember the best solution so far
    best_inl = 0;
    
    % number of point pairs
    N = size(pts1, 1);
    
    for i = 1:iter    
    %% =[ your code starts here ]===========================================
    
        % 1. pick three random pairs of points from pts1 and pts2
        [pt1, pt2] = pickRandomPoints(3, pts1, pts2);
        
        % 2. calculate the [R, T] transform between them
        [Rot, Trans] = estimateTransform(pt1, pt2);
        
        % 3. apply the transform to the whole data
        pt_new = pts1 * Rot + Trans;
        
        % 4. count inliers (points between the pts_new and pts2 that are 
        % closer to each other than given threshold
        diff_ = sqrt(sum((pt_new - pts2).^2, 2));
        
        % 5. check, if inliers threshold is better than required and break
        % the loop if the solution is found
        inliers_comp = sum(diff_ < thr);
        inl_ratio = inliers_comp / N;
        
        if inl_ratio > best_inl
            R = Rot;
            T = Trans;
            best_inl = inl_ratio;
        end
        
        if inl_ratio > ratio
            break;
        end
    
    %=[ your code ends here ]=============================================
    end

end

