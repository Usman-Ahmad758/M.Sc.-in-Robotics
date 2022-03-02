function formants = formants_lpc(x,Fs)
% This function returns a column vector containing the locations of the 
% formants of the speech signal x based on lpc coefficients

% x: speech signal
% fs: is the sampling frequency of x

x1_m = x.*hamming(length(x)); % hamming filter or windowing
preemph = [1 0.63]; % pre-emphasis filter
x1_m = filter(1,preemph,x1_m);
ncoeff = 2+Fs/1000;
A = lpc(x1_m,ncoeff); % getting linear prediction coefficients
rts = roots(A); % finding roots
rts = rts(imag(rts)>=0); % only the roots with one sign for the imaginary part
angz = atan2(imag(rts),real(rts)); % angles corresponding to the roots
[frqs,indices] = sort(angz.*(Fs/(2*pi))); % Convert the angular frequencies in rad/sample represented by the angles to hertz
bw = -1/2*(Fs/(2*pi))*log(abs(rts(indices))); % calculate the bandwidths of the formants
nn = 1;
for kk = 1:length(frqs)
    if (frqs(kk) > 90 && bw(kk) <400) % criterion that formant frequencies should be greater than 90 Hz with bandwidths less than 400 Hz to determine the formants
        formants(nn) = frqs(kk);
        nn = nn+1;
    end
end
formants = mink(formants,3);
end