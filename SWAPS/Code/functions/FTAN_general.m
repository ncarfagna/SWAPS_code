function FTAN_general(lag,nccf,fs,r,sdi,sdf,fstep,start_frequency,end_frequency,ub,lb,ax1,ax2,ax3,times,panel_group)


if ~isnan(fstep) && ~isnan(sdi) && ~isnan(sdf) && (end_frequency-start_frequency)>fstep

times = times+1;
ffilt = start_frequency:fstep:end_frequency;

[ENVEL_p,ENVEL_n,ffilt,vel] = FTAN(ffilt,lag,nccf,fs,r,sdi,sdf);
[ENVEL_fold] = FTAN_fold(ffilt,lag,nccf,fs,r,sdi,sdf); 


v = vel;

if times>1
cla(ax1)
cla(ax2)
cla(ax3)
ax1 = axes('Parent', panel_group, 'Units', 'normalized', 'Position', [0.1 0.68 0.87 0.28]);
ax2 = axes('Parent', panel_group, 'Units', 'normalized', 'Position', [0.1 0.38 0.87 0.28]);
ax3 = axes('Parent', panel_group, 'Units', 'normalized', 'Position', [0.1 0.07 0.87 0.3]);
end

ax1.FontName = 'Lucida Console';
ax2.FontName = 'Lucida Console';
ax3.FontName = 'Lucida Console';


[~,h2] = contourf(ax1,ffilt,flip(v),flipud(ENVEL_p'),15);
set(h2,'LineStyle','none');
set(h2,'edgecolor','none');
ylim(ax1,[lb ub])
xlim(ax1,[min(ffilt) max(ffilt)])
colormap(ax1, jet)
shading(ax1, 'interp')
clim(ax1,[0 1])
grid(ax1,'on')
box(ax1,'on')
% xlabel(ax1,'Frequency (Hz)')
ylabel(ax1,'Group Vr (m/s)')
xticklabels(ax1,[])

xlims = xlim(ax1);
ylims = ylim(ax1);
% Calcola un piccolo offset
x_offset = (xlims(2) - xlims(1)) * 0.02; % 2% della larghezza totale
y_offset = (ylims(2) - ylims(1)) * 0.04; % 5% dell'altezza totale

% Posiziona il testo esattamente in alto a destra del subplot
text(xlims(2) - x_offset, ylims(2) - y_offset, 'causal', ...
    'FontSize', 12, 'FontName', 'Lucida Console', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', ...
    'Parent', ax1);




% [~,h1] = contourf(ax2,FFILT2(1,:),flip(V2(:,1)),flipud(ENVEL_n),25);
[~,h1] = contourf(ax2,ffilt,flip(v),flipud(ENVEL_n'),15);
set(h1,'LineStyle','none');
set(h1,'edgecolor','none');
ylim(ax2,[lb ub])
xlim(ax2,[min(ffilt) max(ffilt)])
colormap(ax2, "jet")
clim(ax2,[0 1])
% xlabel(ax2,'Frequency (Hz)')
ylabel(ax2,'Group Vr (m/s)')
xticklabels(ax2,[])
shading(ax2, 'interp')
grid(ax2,'on')
box(ax2,'on')

text(xlims(2) - x_offset, ylims(2) - y_offset, 'anti-causal', ...
    'FontSize', 12, 'FontName', 'Lucida Console', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', ...
    'Parent', ax2);


% [~,h3] = contourf(ax3,FFILT2(1,:),flip(V2(:,1)),flipud(ENVEL_fold),25);
[~,h3] = contourf(ax3,ffilt,flip(v),flipud(ENVEL_fold'),15);
set(h3,'LineStyle','none');
set(h3,'edgecolor','none');
% h2.LineColor = [.3 .3 .3];
ylim(ax3,[lb ub])
xlim(ax3,[min(ffilt) max(ffilt)])
colormap(ax3, jet)
clim(ax3,[0 1])
xlabel(ax3,'Frequency (Hz)')
ylabel(ax3,'Group Vr (m/s)')
grid(ax3,'on')
box(ax3,'on')
shading(ax3, 'interp')

text(xlims(2) - x_offset, ylims(2) - y_offset, 'folded', ...
    'FontSize', 12, 'FontName', 'Lucida Console', ...
    'BackgroundColor', 'white', 'EdgeColor', 'black', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', ...
    'Parent', ax3);


assignin('base','times',times)
assignin('base', 'ax1', ax1);
assignin('base', 'ax2', ax2);
assignin('base', 'ax3', ax3);

assignin('base','v',v)
assignin('base','ffilt',ffilt)

else

msgbox('One or more FTAN parameters are not valid', 'Warning', 'modal');

end

end

