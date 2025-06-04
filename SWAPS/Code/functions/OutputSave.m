
function OutputSave(ax,isPhase, isGroupEx, isGroupSy,isCCF, isCohe)


outputDir = evalin('base','outputDir');
if ~isfolder(outputDir)             
    mkdir(outputDir)
end

cd(outputDir)

receiv = evalin('base','receiv');
ns1 = evalin('base','ns1');
ns2 = evalin('base','ns2');


dirname1 = strjoin([string(receiv{ns1}),'_',string(receiv{ns2}),'_SWAPS'],'');

parts = split(dirname1, "_");
dirname2 = parts(2) + "_" + parts(1) + "_" + parts(3);

dirname1 = char(dirname1);
dirname2 = char(dirname2);


assignin('base','dirname',dirname1);

if ~isfolder(dirname1) && ~isfolder(dirname2)
    mkdir(dirname1)
    cd(dirname1)
elseif isfolder(dirname1) && ~isfolder(dirname2)
    update = true;
    cd(dirname1)
    path = dir;
    path = path(3:end);
    for  j = 1:length(path)
        delete(path(j).name);
    end
elseif ~isfolder(dirname1) && isfolder(dirname2)
    update = true;
    cd(dirname2)
    path = dir;
    path = path(3:end);
    for  j = 1:length(path)
        delete(path(j).name);
    end
end


if isPhase  
    fr = evalin('base','fr');
    c = evalin('base','c');
    cm = evalin('base','cm');
    cp = evalin('base','cp');
    data = [fr,c,cm,cp];
    T = array2table(data, 'VariableNames', ...
    {'frequency[hz]', 'phasevelocity[m/s]', 'vel_min[m/s]', 'vel_max[m/s]'});
    writetable(T, 'phasevelocity.csv', 'Delimiter', ';');    
end

if isGroupEx
    fgr = evalin('base','fgr');
    vgr = evalin('base','vgr');
    vgrm = evalin('base','vgrm');
    vgrp = evalin('base','vgrp');
    data = [fgr,vgr,vgrm,vgrp]; 
    T = array2table(data, 'VariableNames', ...
    {'frequency[hz]', 'groupvelocity[m/s]', 'vel_min[m/s]', 'vel_max[m/s]'});
    writetable(T, 'groupvelocity_exp.csv', 'Delimiter', ';');    
end
   
if isGroupSy
    f_snt = evalin('base','f_snt');
    vg_snt = evalin('base','vg_snt');
    data = [f_snt,vg_snt]; 
    T = array2table(data, 'VariableNames', ...
    {'frequency[hz]', 'groupvelocity[m/s]'});
    writetable(T, 'groupvelocity_teo.csv', 'Delimiter', ';');   
end

if isCCF
    nccf = evalin('base','nccf');
    lag = evalin('base','lag');
    data = [lag',nccf'];   
    T = array2table(data, 'VariableNames', ...
    {'time-lag[s]', 'crosscorr'});
    writetable(T, 'crosscorr.csv', 'Delimiter', ';'); 
end


if isCohe
    freq = evalin('base','freq');
    corr = evalin('base','corr');
    data = [freq', corr']; 
    T = array2table(data, 'VariableNames', ...
    {'frequency[hz]', 'coherence'});
    writetable(T, 'coherence.csv', 'Delimiter', ';');     
end


% exportgraphics(ax, 'phase_dispcurve.jpg', 'Resolution', 300);
% exportgraphics(fig5, 'group_dispcurve.jpg', 'Resolution', 300);

receiv = evalin('base','receiv');

if length(receiv) == 2

    if isGroupEx
        ENVEL = evalin('base','ENVEL');
        ffilt = evalin('base','ffilt');
        v = evalin('base','v');
        lb = evalin('base','lb');
        ub = evalin('base','ub');
        
        fig = figure('Units','Normalized','Position',[0.2 0.25 0.6 0.5],'Visible','off');
        [~,h2] = contourf(ffilt,flip(v),flipud(ENVEL),15);
        set(h2,'LineStyle','none');
        set(h2,'edgecolor','none');
        ylim([lb ub])
        xlim([min(ffilt) max(ffilt)])
        colormap(jet)
        shading interp
        clim([0 1])
        grid on
        box on
        xlabel('Frequency (Hz)')
        ylabel('Group Vr (m/s)')
        hold on
        scatter(fgr,vgr,50,'xk')
        errorbar(fgr,vgr,vgr-vgrm,vgrp-vgr,'k','LineStyle','none'); 
        
        exportgraphics(fig, 'group_dispcurve.jpg', 'Resolution', 300);
        close(fig)
    end
    exportgraphics(ax, 'phase_dispcurve.jpg', 'Resolution', 300);

elseif length(receiv) > 2
       
    fi = evalin('base','fi');
    ff = evalin('base','ff');
    lb = evalin('base','lb');
    ub = evalin('base','ub');
    ff1 = evalin('base','ff1');
    corr_space = evalin('base','corr_space');
    vel = lb:ub;

    fr = evalin('base','fr');
    c = evalin('base','c');
    cm = evalin('base','cm');    
    cp = evalin('base','cp');        

    [FF1,VEL] = meshgrid(ff1,vel);
    [FF2,VEL2] = meshgrid(ff1(1):0.5:ff1(end),vel(1):0.5:vel(end));
    corr_space = interp2(FF1,VEL,corr_space,FF2,VEL2,'spline');

    vel = VEL2(:,1);
    ff1 = FF2(1,:);

    fig_phase = figure('Units','Normalized','Position',[0.2 0.25 0.6 0.5],'Visible','off');

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

    plot(fr,c,'k')
    plot(fr,cm,'--k')
    plot(fr,cp,'--k')


    exportgraphics(fig_phase, 'phase_dispcurve.jpg', 'Resolution', 300);
    close(fig_phase)

    if isGroupEx


        ENVEL = evalin('base','ENVEL');
        ffilt = evalin('base','ffilt');
        v = evalin('base','v');
        lb = evalin('base','lb');
        ub = evalin('base','ub');


        fig_group = figure('Units','Normalized','Position',[0.2 0.25 0.6 0.5],'Visible','off');
        [~,h1] = contourf(ffilt,flip(v),flipud(ENVEL),15);
        set(h1,'LineStyle','none');
        set(h1,'edgecolor','none');
        xlim([ffilt(1) ffilt(end)]);
        ylim([lb ub]);
        colormap( "jet")
        clim([0 1])
        xlabel('Frequency (Hz)')
        ylabel('Group Vr (m/s)')
        shading interp
        grid on
        box on         
        hold on
        scatter(fgr,vgr,50,'xk')
        errorbar(fgr,vgr,vgr-vgrm,vgrp-vgr,'k','LineStyle','none');         


        exportgraphics(fig_group, 'group_dispcurve.jpg', 'Resolution', 300);
        close(fig_group)

    end





end



cd ..









if exist('report.csv','file')


% parts = split(dirname1, "_");
% dirname2 = parts(2) + "_" + parts(1) + "_" + parts(3);

fr = evalin("base",'fr');
c = evalin('base','c');

    
report = readtable('report.csv');

for k = 2:size(report,2)
    if strcmp(report.Properties.VariableNames{k}, dirname1(1:end-6))
        
        report{:, dirname1(1:end-6)} = NaN;
        for kk = 1:size(report,1)
            for kkk = 1:length(fr)
                if table2array(report(kk,1)) == fr(kkk)
                    report(kk,k) = array2table(c(kkk));
                end
            end
        end
    elseif strcmp(report.Properties.VariableNames{k}, dirname2(1:end-6))

        report{:, dirname2(1:end-6)} = NaN;
        for kk = 1:size(report,1)
            for kkk = 1:length(fr)
                if table2array(report(kk,1)) == fr(kkk)
                    report(kk,k) = array2table(c(kkk));
                end
            end
        end        
    
    end
end


writetable(report, 'report.csv', 'Delimiter', ';');



cd ..

else


cd ..

end









