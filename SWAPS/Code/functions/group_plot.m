function group_plot(isGroupEx,ax1,ax2,ax3,ENVEL_p,ENVEL_n,ENVEL_fold,start_frequency,end_frequency,fstep,vel)

if isGroupEx

choice1 = customDialog5();
% for manual picking of group dispersion curve
fig5 = figure('Units', 'normalized', ...
    'Position', [0.15,0.15,0.72,0.63]);


if choice1 == "ca"    
    ax_new = copyobj(ax1,fig5);
    ENVEL = ENVEL_p';
elseif choice1 == "ac"
    ax_new = copyobj(ax2,fig5);
    ENVEL = ENVEL_n';
elseif choice1 == "f"
    ax_new = copyobj(ax3,fig5);
    ENVEL = ENVEL_fold';
end



set(ax_new, 'Position', [0.1 0.1 0.8 0.8]); 
title(ax_new, 'Group dispersion curve - automatic picking');

ffilt = start_frequency:fstep:end_frequency;
 
clear vgrm vgrp
title(ax_new,'manual picking','FontName','Calibri','FontSize',14)
grid(ax_new,'on')
[fgr,vgr] = getpts(ax_new);


for k = 1:length(fgr)
    [~,locf] = min(abs(ffilt-fgr(k)));
    [~,locv] = min(abs(vel-vgr(k)));
    [vgrm(k,1),vgrp(k,1)] = error_v(vel,ENVEL(:,locf),locv,'manual');
end

hold(ax_new,'on')
pgr = scatter(ax_new,fgr,vgr,50,'xw');
epgr = errorbar(fgr,vgr,vgr-vgrm,vgrp-vgr,'k','LineStyle','none');
hold(ax_new,'off')                
                  
pause(3)
set(fig5,'Visible','off')

else 

    fig5 = [];
    fgr = [];
    vgr = [];
    vgrm = [];
    vgrp = [];
    ENVEL = [];
                               
end

fgr_i(:,1) = ceil(fgr(1)*2)/2 : 0.5 : floor(fgr(end));
vgr_i(:,1) = interp1(fgr, vgr, fgr_i, 'linear');
vgrm_i(:,1) = interp1(fgr, vgrm, fgr_i, 'linear');
vgrp_i(:,1) = interp1(fgr, vgrp, fgr_i, 'linear');




assignin('base','ENVEL',ENVEL)
assignin('base','vgrp',vgrp_i)
assignin('base','vgrm',vgrm_i)
assignin('base','vgr',vgr_i)
assignin('base','fgr',fgr_i)
assignin('base','fig5',fig5)





end

