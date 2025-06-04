function getPick(lb,ub,mainFig,ax)


fit = evalin('base','fit');

if fit


ff1 = evalin('base','ff1');
corr_space = evalin('base', 'corr_space');
vel = lb:ub;

if isfield(mainFig.UserData, 'p1') && isvalid(mainFig.UserData.p1)
delete(mainFig.UserData.p1)
delete(mainFig.UserData.p2)
delete(mainFig.UserData.p3)
end






[FF1,VEL] = meshgrid(ff1,vel);
[FF2,VEL2] = meshgrid(ff1(1):0.5:ff1(end),vel(1):0.5:vel(end));
corr_space = interp2(FF1,VEL,corr_space,FF2,VEL2,'spline');


vel = VEL2(:,1);
ff1 = FF2(1,:);


fig = figure('Units', 'normalized', 'Position', [0.15,0.15,0.72,0.63]);
imagesc([ff1(1) ff1(end)], [vel(1) vel(end)], corr_space);
set(gca,'YDir', 'normal');
set(gca,'FontName','Arial')
xlim([ff1(1) ff1(end)]);
ylim([lb ub]);
colormap(parula);
c2 = colorbar; % Aggiunge la colorbar
xlabel(c2, '\chi(c,\omega)'); % Nome della colorbar
xlabel('Frequency (Hz)');
ylabel('Phase velocity (m/s)');
box on
hold on
clim([0 1])
grid on




pause(2)




    
[ff,c] = getpts();

plot(ff, c, '--k','LineWidth', 1); % Evidenzia i punti selezionati
hold off
    
for jj = 1:length(ff) 

    v = vel;
    f_id = ff(jj);
    [~,f_id] = min(abs(ff1-f_id));
    col = corr_space(:,f_id);
    [~,loc] = min(abs(c(jj)-v));
    [cp(jj,1),cm(jj,1)] = error_v(v,col,loc,'manual');

end


   
pause(2)
close(fig)



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

warndlg('You must evaluate fit before compute manual picking');    


end




end
