function [ENVEL_fold] = FTAN_fold(ffilt,lag,ccf,fs,d,sdi,sdf)

nccf = diff(ccf)./diff(lag);
nccf(end+1) = ccf(end);

ccf = nccf;
clear nccf

ccf = (ccf+flip(ccf))/2;

L = length(ccf);
dt = abs(lag(1)-lag(2));

T = (length(ccf)-1)*dt; % Durata in secondi della traccia

f0 = 1/T; % Frequenza iniziale
df = f0; % Passo di campionamento in frequenza
fmax = fs/2; % Frequenza di Nyquist
% f = (0:(length(ccf)/2)-1)*fs/length(ccf);
f = f0:df:fmax; % Vettore delle frequenze
t = (1:(L-1)/2)*dt;

smf = 0.05; % parametro per il cosine taper

zp = (L+1)/2;


% Costruzione del cosine taper per rastremare il segnale ai bordi

taper = linspace(pi/2,3*pi/2,round(length(ccf)*smf));
taper2 = (sin(taper)+1)/(max(sin(taper)+1));
taper1 = flip(taper2);
taper = [taper1 ones(1,length(ccf)-length(taper1)-length(taper2)) taper2];
clear taper1 taper2

if size(ccf)~=size(taper)
    taper=taper';
end

signal = ccf.*taper;

freq = [0 f]; % vettore frequenza negative e positive

% sgm = sdi + (sdf - sdi) * (1 - exp(-k * linspace(0,1,length(ffilt))));
sgm = sdi * ((sdf / sdi) .^ linspace(0, 1, length(ffilt)));

FTAN = zeros(length(ffilt),length(signal));
for kk = 1:length(ffilt)

std = sgm(kk);

fc = ffilt(kk);

% loc mi da la posizione della frequenza centrale in punti del vettore freq
[~,loc] = min(abs(freq(freq>=0)-fc));
loc = loc+length(freq(freq<0)); 

win = exp(- ( (freq - freq(loc) ).^2 ) / ( 2 * std^2 ) );
% win = [ flip(win(freq>0)) win(freq>=0)];
win = win/max(win);
% cwin = complex(win,0);
win2 = win;

win = [ flip(win2(2:end)) win2];
win = win/max(win);
cwin = win;

Y=fftshift(fft(signal)/T);
absY = abs(Y);
sm_absY = movmean(absY,200);
sm_absY = sm_absY .* cwin;

phase = angle(Y);

Yf = sm_absY .* exp(1i*phase);


fsignal = ifftshift(Yf);
fsignal = real(ifft(fsignal*T));


FTAN(kk,:) = fsignal;

clear fsignal Y Yf F win cwin loc



end

ENVEL = zeros(size(FTAN));
for k = 1:size(FTAN,1)
% ENVEL(k,:) = envelope(FTAN(k,:),5121);
ENVEL(k,:) = abs(hilbert(FTAN(k,:)));
end

for k = 1:size(ENVEL,1)
    ENVEL(k,:) = ENVEL(k,:)./max(ENVEL(k,:));
end

ENVEL_fold = ENVEL(:,zp+1:end);

assignin('base','ENVEL_fold',ENVEL_fold)

end

