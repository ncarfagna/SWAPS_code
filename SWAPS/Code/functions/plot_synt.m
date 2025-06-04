function plot_synt(mainFig,ax1,ax2,ax3)

synt = evalin('base','synt');

if synt

f_snt = evalin('base', 'f_snt');
vg_snt = evalin('base', 'vg_snt');


if isfield(mainFig.UserData,'snt1') && isvalid(mainFig.UserData.snt1)
delete(mainFig.UserData.snt1)
delete(mainFig.UserData.snt2)
delete(mainFig.UserData.snt3)
end


hold(ax1,'on')
mainFig.UserData.snt1 = plot(ax1,f_snt,vg_snt,'--k','LineWidth',1.25);
hold(ax1,'off')

hold(ax2,'on')
mainFig.UserData.snt2 = plot(ax2,f_snt,vg_snt,'--k','LineWidth',1.25);
hold(ax2,'off')

hold(ax3,'on')
mainFig.UserData.snt3 = plot(ax3,f_snt,vg_snt,'--k','LineWidth',1.25);
hold(ax3,'off')


else

warndlg('You must compute picking of phase velocities');


end    



end

