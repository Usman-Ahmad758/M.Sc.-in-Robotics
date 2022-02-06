clear;
clc;
close all;

% load sample image
I1=imread('974-1.jpg');
I2=imread('975-1.jpg');

% show the image and wait for the points selection (be sure to check if exactly four points were selected)
figure(1)
imshow(I1)

[x,y] = getpts;
close(figure(1))

figure
imshow(I2)

[X,Y] = getpts;
close(figure(2))

%Check if exactly four points
if length(x)==4 &&  length(X)==4
    % prepare reference points
    % fill with appropriate output of the getpts command
    points_in = [x';y'];
    points_out = [X';Y'];

    % calculate the homography - this function should be implemented by you
    H = calculate_homography(points_in, points_out);
    
    % prepare image reference information
    Rin1=imref2d(size(I1));
    Rin2=imref2d(size(I2));
    
    % convert homography matrix to the Matlab projective transformation
    t = projective2d(H');
    
    % warp the image and get the output reference information
    [I3, Rout]=imwarp(I1, Rin1, t);
    nexttile;
    imshow(I3);
    p = imfuse(I2,Rin2, I3, Rout,'blend');
    imshow(p)
    
else
    fprintf('Number of inputs should exactly be four for both images \n')
    close all
end
