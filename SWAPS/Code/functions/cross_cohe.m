
function cross_cohe(tr1, tr2, ti_win, tf_win, fs, w, end_frequency, axcoh, idx, axcor)

% Crea la finestra principale usando figure
fig_cc = figure('Name', 'Processing...', 'Units', 'normalized', 'Position', [0.32, 0.4, 0.3, 0.1], 'Color', [.95 .95 .95], ...
    'MenuBar','none','ToolBar','none','NumberTitle','off');

% Aggiungi un'etichetta con il messaggio
lbl = uicontrol(fig_cc, 'Style', 'text', 'String', 'Computing cross-correlation and coherence functions ...', ...
                'Position', [10, 35, 450, 30], 'FontSize', 12, 'FontName', 'Calibri');

% Pausa per mostrare il messaggio
pause(2)

% Esegui le funzioni per calcolare la coerenza e la cross-correlazione
if isempty(tr1) || isempty(tr2) || isempty(ti_win) || isempty(tf_win)
errordlg('Something went wrong with selected traces or windows', 'Error');
error('Check imported traces or selected windows ');
else
[lag, nccf] = crosscorr_2(tr1, tr2, ti_win, tf_win, fs, w, idx, axcor);
[freq, corr] = coherence_2(tr1, tr2, ti_win, tf_win, fs, w, end_frequency,idx, axcoh);
end

% Assegna i risultati nel workspace
assignin('base', 'lag', lag)
assignin('base', 'nccf', nccf)
assignin('base', 'freq', freq)
assignin('base', 'corr', corr)

% Chiudi la finestra dopo il calcolo
close(fig_cc)

end
