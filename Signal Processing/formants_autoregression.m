% The following link was used as a reference:
% https://www.clear.rice.edu/elec431/projects96/digitalbb/index.html

function fmnts = formants_autoregression(x,fs)
% This function returns a column vector containing the locations of the 
% formants of the speech signal x based on auto regression model

% x: speech signal
% fs: is the sampling frequency of x
% n : is the order of the auto-regressive model

n = round(fs/1000) + 2;

w = hamming(length(x));
x = x.*w;

th = ar(x,n);		% auto-regressive model of voice

[b,a] = tfdata(th);	% transfer function of vocal tract
b = cell2mat(b); 
a = cell2mat(a);
[h,w1] = freqz(b,a);	% frequency response of vocal tract

f = w1.*fs/(2*pi); % frequency
% Visualization 
figure
semilogy(f,abs(h))
xlabel('Frequeny (Hz)')
ylabel('log scale frequency response')
title('Auto-Regressive Model with Formants')

hold on

[floc,fmag] = peakz(abs(h));
allfmnts = f(floc);
semilogy(allfmnts,fmag,'x');

if ( length(allfmnts) < 3 )
    r1 = roots(a);
    r2 = r1(angle(r1)>0);
    angles = angle(r2);
    fmnts = (fs/2)*(angles/pi);
else
	fmnts = allfmnts(1:3);
end

hold off
end