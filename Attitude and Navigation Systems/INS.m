clear; close all;
clc;
rng("default");

%% Creation of Data

t = 0:1:599;  % Data is taken at every 1 second,
o= length(t)/3; %Dividing the interval od t by 3
m=36; %The maximum acceleration


ax= [ones(1,o).*1.5*m    -ones(1,o).*m     ones(1,o).*m/2];
ax = ax(1,1:length(t));

ay= [ones(1,o).*m   zeros(1,o)  -ones(1,o).*m];
ay = ay(1,1:length(t));

az= [ones(1,o).*m     -ones(1,o).*m     -ones(1,o).*m];
az = az(1,1:length(t));

a=ax+ay+az;

% figure;
% plot(t,ax)
% hold on
% plot(t,ay);
% hold on 
% plot(t,az)
% legend('ax','ay','az')
% 
% figure();
% plot(t,a);
% legend('a')
% 
% 
[px, py, pz, vx, vy, vz]= position(ax, ay, az, t);
% 
% figure();
% plot(t,px)
% hold on
% plot(t,py);
% hold on 
% plot(t,pz)
% legend('px','py','pz')
% 
% figure();
% plot(t,vx)
% hold on
% plot(t,vy);
% hold on 
% plot(t,vz)
% legend('vx','vy','vz')
% plot3(px,py,pz);

%% Adding the error in acceleration
a = 0;
b = 0.5;
r = (b-a).*randn(length(ax),1) + a;
e= 0.1;

axx= ax+e*ax+r';
ayy=ay+e*ay+r';
azz=az+e*az+r';

aa=axx+ayy+azz;

% figure;
% plot(t,axx)
% hold on
% plot(t,ax)
% legend('Acceleration with error','Actual Acceleration')
% xlabel('Time') 
% ylabel('Acceleration across X-axis') 
% title('Time vs Acceleration across X-Axis')
% 
% figure;
% plot(t,ayy)
% hold on
% plot(t,ay)
% legend('Acceleration with error','Actual Acceleration')
% xlabel('Time') 
% ylabel('Acceleration across Y-axis') 
% title('Time vs Acceleration across Y-Axis')
% 
% figure;
% plot(t,azz)
% hold on
% plot(t,az)
% legend('Acceleration with error','Actual Acceleration')
% xlabel('Time') 
% ylabel('Acceleration across Z-axis') 
% title('Time vs Acceleration across Z-Axis')

[pxx, pyy, pzz]= position(axx, ayy, azz, t);

% figure();
% plot(t,pxx)
% hold on
% plot(t,px);
% legend('pxx','px')
% legend('Position with error','Actual Position')
% xlabel('Time') 
% ylabel('Position across X-axis') 
% title('Time vs Position across X-Axis')
% 
% 
% figure();
% plot(t,pyy)
% hold on
% plot(t,py);
% legend('Position with error','Actual Position')
% xlabel('Time') 
% ylabel('Position across Y-axis') 
% title('Time vs Position across Y-Axis')
% 
% 
% figure();
% plot(t,pzz)
% hold on
% plot(t,pz);
% legend('Position with error','Actual Position')
% xlabel('Time') 
% ylabel('Position across Z-axis') 
% title('Time vs Position across Z-Axis')



%% LSTM for X-Position

[Ypred_x, rms_pred_x, rms_overall_x] = LSTM_Algorithm(pxx, px);

figure;
plot(Ypred_x)
hold on
plot(px)
hold on
plot(pxx)
legend('LSTM Prediction','Actual Position','Input Positions ')
xlabel('Time(sec)') 
ylabel('X-Axis Position(meters)') 
title('Time vs Position across X-Axis')



%% LSTM for Y-Position

[Ypred_y, rms_pred_y, rms_overall_y] = LSTM_Algorithm(pyy, py);
figure;
plot(Ypred_y)
hold on
plot(py)
hold on
plot(pyy)
legend('LSTM Prediction','Actual Position','Input Positions')
xlabel('Time(sec)') 
ylabel('Y-Axis Position(meters)') 
title('Time vs Position across Y-Axis')
 

%% LSTM for Z-Position

[Ypred_z, rms_pred_z, rms_overall_z] = LSTM_Algorithm(pzz, pz);
figure;
plot(Ypred_z)
hold on
plot(pz)
hold on
plot(pzz)
legend('LSTM Prediction','Actual Position','Input Positions')
xlabel('Time(sec)') 
ylabel('Z-Axis Position(meters)') 
title('Time vs Position across Z-Axis')

%% 3D Plot

figure;
plot3(px,py,pz);
hold on
plot3(Ypred_x,Ypred_y,Ypred_z);
hold on
plot3(pxx,pyy,pzz);
legend('Ideal Path', 'Predicted path', 'Drifted Actual Path');
xlabel('X-Axis Position') 
ylabel('Y-Axis Position')
zlabel('Z-Axis Position')
title('Three Dimentional Plot of Positions')









