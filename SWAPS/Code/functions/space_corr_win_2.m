
function space_corr_win_2(cohe,freq,lb,ub,start_frequency,end_frequency,w,fs,step,r,win,ax,k1,k2)

if k1+k2~=1
msgbox('Sum of coefficients k1 and k2 must be equal to 1', 'Warning', 'modal');    
else

w = round(w*fs);
dt = 1/fs; % sampling time
N = w+1;
T = dt*N;
df = 1/T; % frequency rate in frequency domain
vel = lb:ub;

%%

win = round(win/df);
step = round(step/df);
fwin = linspace(round(win),round(win),length(round(start_frequency/df):step:round(end_frequency/df)));
fwin = round(fwin);
corr_space = zeros(length(vel),length(round(start_frequency/df):step:round(end_frequency/df)));
ff1 = zeros(1,length(round(start_frequency/df):step:round(end_frequency/df)));

%%

jj = 0;
for nf = round(start_frequency/df)+1:step:round(end_frequency/df)+1

    jj = jj + 1;
    
    if nf-fwin(jj)>0 && nf+fwin(jj)<=length(freq) 
    coe = cohe(nf-fwin(jj):nf+fwin(jj));
    f = freq(nf-fwin(jj):nf+fwin(jj));
    % J0 = @(c) besselj(0,(2*pi*r*f)/c);    
    elseif nf-fwin(jj)<=0
    coe = cohe(1:nf+fwin(jj));
    f = freq(1:nf+fwin(jj));
    % J0 = @(c) besselj(0,(2*pi*r*f)/c);
    elseif nf+fwin(jj)>length(freq)
    coe = cohe(nf-fwin(jj):end);
    f = freq(nf-fwin(jj):end);
    % J0 = @(c) besselj(0,(2*pi*r*f)/c);
    end    

    j = 0;
    N = length(coe);
    w = 1 - abs((1:N) - (N+1)/2) / (N/2);  % Finestra triangolare
    %w = w';
    mean_coe = sum(w .* coe) / sum(w);

    for c = vel
        j = j + 1;
        J0 = besselj(0,(2*pi*r*f)/c);
     
        mean_J0 = sum(w .* J0) / sum(w);
        numerator = sum(w .* (coe - mean_coe) .* (J0 - mean_J0));
        denominator = sqrt(sum(w .* (coe - mean_coe).^2) * sum(w .* (J0 - mean_J0).^2));
        corr_space(j,jj) = numerator / denominator;

        rmse(j,jj) = sqrt(sum((coe-J0).^2)/length(coe));
        
        clear J0
    end  
       
    ff1(jj) = freq(nf);
    clear coe f RMSE
    % jj = jj + 1;

end

%%

for k = 1:size(rmse,2)
    rmse(:,k) = rmse(:,k)/max(rmse(:,k));
end

corr_space = corr_space+abs(min(corr_space(:)));
corr_space = corr_space /max(corr_space(:));
corr_space = k1*corr_space + k2*(1-rmse);


assignin('base','ff1',ff1)
assignin('base','corr_space',corr_space)

[FF1,VEL] = meshgrid(ff1,vel);
[FF2,VEL2] = meshgrid(ff1(1):0.5:ff1(end),vel(1):0.5:vel(end));
corr_space2 = interp2(FF1,VEL,corr_space,FF2,VEL2,'spline');

imagesc(ax, [ff1(1) ff1(end)], [vel(1) vel(end)], corr_space2);
set(ax, 'YDir', 'normal');
set(ax,'FontName','Lucida Console')
xlim(ax, [ff1(1) ff1(end)]);
ylim(ax, [lb ub]);
colormap(ax, parula);
c2 = colorbar(ax); % Aggiunge la colorbar
xlabel(c2, '\chi(c,\omega)'); % Nome della colorbar
xlabel(ax, 'Frequency (Hz)');
ylabel(ax, 'Phase velocity (m/s)');
box(ax,'on')
hold(ax, 'on');
clim(ax,[0 1])
grid(ax,'on')


pause(3)

fit = true;
assignin('base','fit',fit)

%%

end

end

