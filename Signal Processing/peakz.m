function [loc,mag] = peakz(x)
% This function locates local maxima of a signal x and returns index number
% and magnitude of the maxima
% x: input signal


b = zeros(length(x));

for i = 2:length(x)-1
    
    if ( (x(i) >= x(i-1)) && (x(i) >= x(i+1)) && ( x(i) ~= x(i+1) ) )
        b(i) = 1;
    end

end

loc = find(b==1);
mag = x(loc);
end