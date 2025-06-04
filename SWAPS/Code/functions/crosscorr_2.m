function [lag,nccf] = crosscorr_2(tr1,tr2,ti_win,tf_win,fs,w,idx,axcor)

if length(idx) == 2
w = w*fs;
end

max_lag = w;

cxy = zeros(length(ti_win),(max_lag*2)+1);

for nw = 1:length(ti_win)
    
    x = tr1(ti_win(nw):tf_win(nw)); x = detrend(x,1);
    y = tr2(ti_win(nw):tf_win(nw)); y = detrend(y,1);     
    cxy(nw,:) = xcorr(x,y,max_lag,'normalized');
end

lag = linspace(-(max_lag/fs),max_lag/fs,size(cxy,2));
nccf = mean(cxy);


if nargin >= 8
plot(axcor,lag,nccf,'Color',[0 0 0])
axcor.XLim = [min(lag) max(lag)];

end



end
