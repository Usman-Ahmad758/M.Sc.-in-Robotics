function [px, py, pz, vx, vy, vz]= position(ax, ay, az, t)

%Declaring the velocities
vx = zeros(1,length(t));
vy = zeros(1,length(t));
vz = zeros(1,length(t));
%Declaring the positions
px = zeros(1,length(t));
py = zeros(1,length(t));
pz = zeros(1,length(t));

for i= 2: length(t) %loop for position x,y,z....
    
vx(i) = vx(i-1) + ( (t(i) - t(i-1)) .* ax(i) );
px(i) = px(i-1) + ( (t(i) - t(i-1)) .* vx(i) );


vy(i) = vy(i-1) + ( (t(i) - t(i-1)) .* ay(i) );
py(i) = py(i-1) + ( (t(i) - t(i-1)) .* vy(i) );


vz(i) = vz(i-1) + ( (t(i) - t(i-1)) .* az(i) );
pz(i) = pz(i-1) + ( (t(i) - t(i-1)) .* vz(i) );


end

% px=px./1000;
% py=py./1000;
% pz= pz./1000;

end