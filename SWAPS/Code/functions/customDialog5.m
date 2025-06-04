


function choice = customDialog5()
    % Crea una finestra personalizzata con figure
    fig = figure('Name', 'Select Curve', 'Units', 'normalized', 'Position', [0.4, 0.4, 0.25, 0.15], ...
        'MenuBar','none','ToolBar','none','NumberTitle','off');

    % Testo della domanda
    uicontrol(fig, 'Style', 'text', 'String', 'Choose one group velocity plot', ...
              'Position', [40, 75, 300, 30], 'FontName', 'Calibri', 'FontSize', 12);
    
    choice = '';  % Inizializza la variabile di scelta

    % Bottone "Causal"
    btn_ca = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Causal', ...
                       'Position', [55, 30, 80, 30], ...
                       'FontName', 'Calibri', 'FontSize', 10, ...
                       'Callback', @(btn,event)setChoice('ca'));

    % Bottone "Acausal"
    btn_ac = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Acausal', ...
                       'Position', [155, 30, 80, 30], ...
                       'FontName', 'Calibri', 'FontSize', 10, ...
                       'Callback', @(btn,event)setChoice('ac'));

    % Bottone "Folded"
    btn_f = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Folded', ...
                      'Position', [255, 30, 80, 30], ...
                      'FontName', 'Calibri', 'FontSize', 10, ...
                      'Callback', @(btn,event)setChoice('f'));

    % Attende la selezione dell'utente
    uiwait(fig);  

    delete(fig);  % Chiude la finestra dopo la selezione

    % Funzione per impostare la scelta
    function setChoice(val)
        choice = val;
        uiresume(fig); % Riprende l'esecuzione
    end
end

