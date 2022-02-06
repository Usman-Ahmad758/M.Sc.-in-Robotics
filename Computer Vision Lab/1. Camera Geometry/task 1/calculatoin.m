function [z1, z2] = calculatoin(fx, fy, x1, u1, y1, v1)

z1 = (fx * 1000)*((0-x1)/(0-u1));

z2 = (fy *1000)*((0-y1)/(0-v1));



end