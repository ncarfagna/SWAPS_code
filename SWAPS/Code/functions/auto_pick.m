

function [ff,c,cm,cp] = auto_pick(mainFig,ax,vel,model,nrec,start_frequency,end_frequency)

fit = evalin('base','fit');

if fit

ff1 = evalin('base','ff1');
corr_space = evalin('base','corr_space');
corr_space = flipud(corr_space);

if isfield(mainFig.UserData, 'p1') && isvalid(mainFig.UserData.p1)
delete(mainFig.UserData.p1)
delete(mainFig.UserData.p2)
delete(mainFig.UserData.p3)
end


if nrec == 2
[fmin, fmax] = frequencyRange(model);
[~,fmin] = min(abs(ff1-fmin));
[~,fmax] = min(abs(ff1-fmax));
else
fmin = start_frequency;
fmax = end_frequency;
[~,fmin] = min(abs(ff1-fmin));
[~,fmax] = min(abs(ff1-fmax));
end


v = flip(vel);
i = 0;
picking = struct();

for k = fmin:fmax
col = corr_space(:,k);
[pks,loc,wd,prom] = findpeaks(col,'Annotate','extents');
[cm,cp] = error_v(v,col,loc,'auto');


if ~isempty(pks) 

pks = pks/max(pks);
loc = loc(pks>0.5);    
wd = wd(pks>0.5);
prom = prom(pks>0.5);
cm = cm(pks>0.5);    
cp = cp(pks>0.5);
pks = pks(pks>0.5);


i=i+1;
picking(i).freq = ff1(k);
picking(i).V = v(loc);
picking(i).pks = pks;
picking(i).wd = wd;
picking(i).prom = prom;
picking(i).min1 = cm;
picking(i).min2 = cp;
end


end

clear i k loc pks prom wd cm cp

for i = 1:length(picking)

    ff(i) = picking(i).freq;
    V = picking(i).V;
    pks = picking(i).pks;
    min1 = picking(i).min1;
    min2 = picking(i).min2;

    if length(pks) == 1

        c(i) = V;
        cm(i) = min1;
        cp(i) = min2;        

    elseif length(pks) > 1 && i == 1
        
        wd = picking(i).wd;
        prom = picking(i).prom;
     
        norm_pks = pks/max(corr_space(:,i));
        norm_wd = wd/length(corr_space(:,i));
        norm_prom = prom/max(corr_space(:,i));
        w1 = 0.1; w2 = 0.9; w3 = 0.0;
        score = w1 * norm_pks + w2 * norm_wd + w3 * norm_prom;
        [~,xscore] = max(score);

        c(i) = V(xscore);
        cm(i) = min1(xscore);
        cp(i) = min2(xscore);        

    elseif length(pks) > 1 && i > 1
 
        pks = picking(i).pks;
        wd = picking(i).wd;
        prom = picking(i).prom;       

        norm_pks = pks/max(corr_space(:,i));
        norm_wd = wd/length(corr_space(:,i));
        norm_prom = prom/max(corr_space(:,i));
        dc = abs(c(i-1) - V);
        dnorm = max(abs(c(i-1)-[v(1) v(end)]));
        d_norm = (dc/dnorm)';
        w1 = 0.0; w2 = 0.0; w3 = 0.0; w4 = 1;
        score = w1 * norm_pks + w2 * norm_wd + w3 * norm_prom + w4*(1./d_norm);
        [~,xscore] = max(score);

        c(i) = V(xscore);
        cm(i) = min1(xscore);
        cp(i) = min2(xscore);  

    end

end




ff1 = ff;


ff = ff';
c = c';
cm = cm';
cp = cp';


if length(ff) ~= length(c)
uialert(mainFig, ['Something goes wrong with automatic picking, ...' ...
                   ' try manual picking'], 'Warning', 'Icon', 'warning');
end

ff2 = ceil(ff(1)*2)/2 : 0.5 : floor(ff(end));
c2 = interp1(ff, c, ff2, 'linear');
cm2 = interp1(ff, cm, ff2, 'linear');
cp2 = interp1(ff, cp, ff2, 'linear');
ff2 = ff2'; c2 = c2'; cm2 = cm2'; cp2 = cp2';

assignin('base','fr',ff2)
assignin('base','c',c2)
assignin('base','cm',cm2)
assignin('base','cp',cp2)

hold(ax,'on')
mainFig.UserData.p1 = plot(ax,ff2,c2,'k');
mainFig.UserData.p2 = plot(ax,ff2,cm2,'--k');
mainFig.UserData.p3 = plot(ax,ff2,cp2,'--k');
hold(ax,'off')

[f_snt,vg_snt] = get_Vg(ff2,c2);


synt = true;
assignin('base','synt',synt)

assignin('base','f_snt',f_snt)
assignin('base','vg_snt',vg_snt)


else

warndlg('You must evaluate fit before compute automatic picking');


end


end
