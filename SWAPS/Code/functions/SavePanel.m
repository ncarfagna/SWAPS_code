
function SavePanel()

% Crea la finestra principale con figure
fig = figure('Name', '  ', 'Units', 'normalized', 'Position', [0.45, 0.25, 0.2, 0.48], 'Color', [.95 .95 .95], ...
    'MenuBar','none','ToolBar','none','NumberTitle','off');

% Etichetta del testo
uicontrol(fig, 'Style', 'text', 'String', 'Choose the outputs to save:', ...
    'Units','Normalized','Position', [0.1 0.8 0.8 0.1], 'FontSize', 14, 'FontName', 'Calibri');

% Caselle di controllo per selezionare cosa salvare
savebox2 = uicontrol(fig, 'Style', 'checkbox', 'String', 'Phase dispersion curve ', ...
     'Units','Normalized','Position', [0.1 0.65 0.8 0.1], 'FontSize', 10, 'FontName', 'Calibri');

savebox3 = uicontrol(fig, 'Style', 'checkbox', 'String', 'Experimental Group dispersion curve', ...
    'Units','Normalized','Position', [0.1 0.55 0.8 0.1], 'FontSize', 10, 'FontName', 'Calibri');

savebox4 = uicontrol(fig, 'Style', 'checkbox', 'String', 'Syntetic Group dispersion curve', ...
    'Units','Normalized','Position', [0.1 0.45 0.8 0.1], 'FontSize', 10, 'FontName', 'Calibri');

savebox5 = uicontrol(fig, 'Style', 'checkbox', 'String', 'Cross-correlation function', ...
    'Units','Normalized','Position', [0.1 0.35 0.8 0.1], 'FontSize', 10, 'FontName', 'Calibri');

savebox6 = uicontrol(fig, 'Style', 'checkbox', 'String', 'Coherence function', ...
    'Units','Normalized','Position', [0.1 0.25 0.8 0.1], 'FontSize', 10, 'FontName', 'Calibri');


% Bottone per confermare
btn_save = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Save', ...
    'Units','Normalized','Position', [0.52 0.05 0.4 0.1], 'FontName', 'Calibri', 'FontSize', 12, ...
    'Callback', @(src, event) saveAndClose(fig));

% Attende la selezione dell'utente
uiwait(fig);

assignin('base', 'isPhase', savebox2.Value);
assignin('base', 'isGroupEx', savebox3.Value);
assignin('base', 'isGroupSy', savebox4.Value);
assignin('base', 'isCCF', savebox5.Value);
assignin('base', 'isCoeh', savebox6.Value);
% assignin('base', 'isTXT', formbox1.Value);
% assignin('base', 'isXLSX', formbox2.Value);

% Chiude la finestra
close(fig);

end

% Funzione per eseguire l'azione dopo aver premuto il pulsante
function saveAndClose(fig)
    
    % assignin('base', 'jj', true); % Esempio di assegnazione di variabile
    uiresume(fig); % Permette al codice di riprendere dopo uiwait

end

