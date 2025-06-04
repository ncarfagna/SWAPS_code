
function create_frequency_window()
    % Crea la finestra di input usando 'figure' invece di 'uifigure'
    fig = figure('Name', 'Analysis limits', 'Units', 'normalized', 'Position', [0.43, 0.4, 0.17, 0.3], ...
         'MenuBar','none','ToolBar','none','NumberTitle','off');

    % Etichetta e campo di input per Start Frequency
    startFreqLabel = uicontrol(fig, 'Style', 'text', 'String', 'Start Frequency (Hz)', ...
                               'Units','Normalized','Position', [0.05 0.7 0.6 0.2], 'FontName', 'Calibri', 'FontSize', 12);
    startFreqInput = uicontrol(fig, 'Style', 'edit', 'Units','Normalized','Position', [0.7 0.81 0.2 0.1]);




    % Etichetta e campo di input per End Frequency
    endFreqLabel = uicontrol(fig, 'Style', 'text', 'String', 'End Frequency (Hz)', ...
                             'Units','Normalized','Position', [0.05 0.55 0.6 0.2], 'FontName', 'Calibri', 'FontSize', 12);
    endFreqInput = uicontrol(fig, 'Style', 'edit', 'Units','Normalized','Position', [0.7 0.66 0.2 0.1]);





    % Etichetta e campo di input per Start Velocity
    startVelLabel = uicontrol(fig, 'Style', 'text', 'String', 'Start Velocity (m/s)', ...
                               'Units','Normalized','Position', [0.05 0.4 0.6 0.2], 'FontName', 'Calibri', 'FontSize', 12);
    startVelInput = uicontrol(fig, 'Style', 'edit', 'Units','Normalized','Position', [0.7 0.51 0.2 0.1]);




    % Etichetta e campo di input per End Velocity
    endVelLabel = uicontrol(fig, 'Style', 'text', 'String', 'End Velocity (m/s)', ...
                             'Units','Normalized','Position', [0.05 0.25 0.6 0.2], 'FontName', 'Calibri', 'FontSize', 12);
    endVelInput = uicontrol(fig, 'Style', 'edit', 'Units','Normalized','Position', [0.7 0.36 0.2 0.1]);

    % Bottone per confermare i valori
    btn = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Confirm', ...
                    'Units','Normalized','Position', [0.25 0.1 0.5 0.15], 'FontName', 'Calibri', 'FontSize', 12, ...
                    'Callback', @(src, event) on_confirm(startFreqInput, endFreqInput, startVelInput, endVelInput, fig));

    uiwait(fig);  % Sospendi l'esecuzione fino al clic del pulsante
end

% Funzione che esegue l'azione dopo aver premuto il pulsante
function on_confirm(startFreqInput, endFreqInput, startVelInput, endVelInput, fig)
    % Ottieni i valori inseriti per Start Frequency e End Frequency
    startFreq = str2double(get(startFreqInput, 'String'));
    endFreq = str2double(get(endFreqInput, 'String'));
    startVel = str2double(get(startVelInput, 'String'));
    endVel = str2double(get(endVelInput, 'String'));


    % Verifica se i valori sono validi
    if isempty(startFreq) || isempty(endFreq) || startFreq >= endFreq
        msgbox('Please enter valid frequencies and velocities. Start frequency must be less than End frequency.', 'Warning', 'modal');
    elseif isempty(startVel) || isempty(endVel) || startVel>=endVel
        msgbox('Please enter valid velocities. Start velocity must be less than End velocity.', 'Warning', 'modal');        
    else
        % Visualizza i valori nella Command Window (o puoi fare altre operazioni)
        assignin('base', 'start_frequency', startFreq);
        assignin('base', 'end_frequency', endFreq);
        assignin('base', 'lb', startVel);
        assignin('base', 'ub', endVel);
        % Chiudi la finestra dopo aver confermato i valori
        close(fig);
    end
end

