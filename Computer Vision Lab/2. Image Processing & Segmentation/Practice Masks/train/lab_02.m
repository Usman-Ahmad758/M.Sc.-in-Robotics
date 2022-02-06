clear; close all;
clc;

%% Thresholding

rgb = imread('2018-10-29_10-50-48.403_L.png');
% HSV = rgb2hsv(rgb);
% imshow(rgb);
[BW,maskedRGBImage] = PinkMask1(rgb1);
figure;
imshow(BW)

