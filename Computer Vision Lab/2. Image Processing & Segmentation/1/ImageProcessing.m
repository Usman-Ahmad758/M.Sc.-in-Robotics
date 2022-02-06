function [u,v,x,y,z,r] = ImageProcessing(rgb1, i)
%Applying masks and segmentation

[BW1,maskedRGBImage1] = CombinedMask(rgb1);

%Applying masks and segmentation
[BW11,maskedImage11] = segmentImageFinal(maskedRGBImage1,BW1);

%% Measuring the Image parameters

%Known Camera Parameters (In Pixels)
fx = 1.4103*1000;
fy = 1.4112*1000;
cx = 610.9592;
cy = 551.9464;

%Object Parameter (Diameter in mm)
D = 200;

% The function will give the table with the following properties
stats = regionprops('table',BW11,'Area','Centroid','EquivDiameter');

Area = stats.Area;       
[A,I] = maxk(Area,1);   %Getting the index of main bigger area (i.e, ball)

dia = stats.EquivDiameter;

L =stats.Centroid;     %Getting values from centroid
L1 = L(I,1);            %storing first value (u)
L2 = L(I,2) ;           %Storing second value(v)

%% Plot the BW image with the center displayed on each figure

%These images of each frame, if plotted, will show that the algorithm
%do not consider noise while depicting the ball because noise will also
%have diameter and region prop will not give direct values of bigger circle

%     figure;
%     imshow(BW11)
%     hold on
%     plot(L1,L2,'r*')
%     hold off

%% Image Parameters Calculations considering left top of the image as origin

u= L1;                  % u is horizontal length in image plane
v= 1296 - L2;           % v is vertical length in image plane
d = dia(I,1);        %Getting the Radius
r = d/2;
N = nan(1);

if ( d ~= 0)||( d ~= N)         %In case the mask do not detect the ball
                                %Like first and Last Two figures
    z = (fx * D)./(d);          %Calculating z distance 
    x =  ((u - cx).*z )./(fx);  %Calculating x
    y =  ((v - cy).*z )./(fy);  %Calculating y
else
    u = 0;            
    v = 0;
    z = 0;
    x = 0;
    y = 0;
end

%% Plotting the Masked ball on the Image Plane  

INS = insertShape(rgb1, "FilledCircle", [L1, L2, r], "Opacity", 0.7);
figure;
imshow(INS);


end