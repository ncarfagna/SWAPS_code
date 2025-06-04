function [freq,corr] = coherence_2(tr1,tr2,ti_win,tf_win,fs,w,end_frequency,idx,axcoh)


if length(idx) == 2
w = round(w*fs);
end

N = w+1;
% N = w;
tr1 = tr1'; tr2 = tr2';
freq = linspace(0,fs/2,(N+1)/2);

freqq = [freq -flip(freq(1:end-1))];

% Inizializzo le matrici che conterranno spettri e cross-spettro
Px = zeros(length(ti_win),N); % psd del segnale 1
Py = zeros(length(ti_win),N); % psd del segnale 2
rPxy = zeros(length(ti_win),N); % parte reale di ogni cross-spettro


%%
for nw = 1:length(ti_win)
    
    x = tr1(ti_win(nw):tf_win(nw)); x = detrend(x,1);
    y = tr2(ti_win(nw):tf_win(nw)); y = detrend(y,1);    
    x = x.*tukeywin(length(x),0.05)'; y = y.*tukeywin(length(y),0.05)'; 
    % calcolo spettri di potenza e cross-spettro
    px = (fft(x).*conj(fft(x)));
    py = (fft(y).*conj(fft(y)));
    pxy = (fft(x).*conj(fft(y)));

    Px(nw,:) = px;
    Py(nw,:) = py;
    rPxy(nw,:) = real(pxy);            
            
            
    clear px py pxy
end


[mPx,mPy,mrPxy] = f_SN(Px,Py,rPxy);


corr = mrPxy ./ sqrt(mPx .* mPy);
corr = corr(1:N/2+1);

% ---------------------------------------------------------------------- %%
% ---------------------------------------------------------------------- %%



[freq,corr] = splineLSQR(freq,corr);


% sulla base del valore di start_frequency taglio la funzione in bassa
% frequenza
[~,loc] = min(abs(end_frequency-freq));
freq = freq(1:loc);
corr = corr(1:loc);

if nargin >= 9
plot(axcoh,freq,corr,'Color',[0 0 0])
axcoh.XLim = [0  end_frequency];
axcoh.YLim = [-1  1];
end


end

