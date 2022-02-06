clear; close all;
clc;

%% Looping for Image 

imgFiles = dir("*.png");   % get all jpg files in the folder 
numfiles = length(imgFiles);  % total number of files 


u = zeros(numfiles,1);
v = zeros(numfiles,1);
x = zeros(numfiles,1);
y = zeros(numfiles,1);
z = zeros(numfiles,1);
r = zeros(numfiles,1);


for i = 2:numfiles-2            % loop for each file 
    
    img = imgFiles(i).name;    % present image file 
   
    rgb1 = imread(img);
    
    [u(i,1),v(i,1),x(i,1),y(i,1),z(i,1),r(i,1)] = ImageProcessing(rgb1, i);
    
    % Plotting the final 2D graph 
    if i>=6

        P = polyfit(u(2:i,1), v(2:i,1),2);
        f1 = polyval(P,u(2:i));

        figure;
        plot(u(2:i),f1,'b--')
        hold on
        plot(u(2:i),v(2:i),'o--')
        legend('Prediction','Actual')

    end

end

            


        

