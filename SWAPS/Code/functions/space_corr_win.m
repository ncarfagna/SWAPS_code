
function [ff1,corr_space] = space_corr_win(cohe,freq,vel,start_frequency,end_frequency,df,shf,r,win,k1,k2)
%%
win = round(win/df);
shf = round(shf/df);
fwin = linspace(round(win*2),round(win),length(round(start_frequency/df):shf:round(end_frequency/df)));
fwin = round(fwin);
corr_space = zeros(length(vel),length(round(start_frequency/df):shf:round(end_frequency/df)));
ff1 = zeros(1,length(round(start_frequency/df):shf:round(end_frequency/df)));
%%
jj = 0;

%shf = linspace(round(shf*10),round(shf),length(round(start_frequency/df):shf:round(end_frequency/df)));
%%
for nf = round(start_frequency/df)+1:shf:round(end_frequency/df)+1

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

        mape(j,jj) = mean(abs((coe - J0) ./ coe)) ;

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

%%
end

