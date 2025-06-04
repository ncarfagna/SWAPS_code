function [val1, val2] = frequencyRange(model)
    % Creazione della finestra
    if model == "misfit"
    uiFig = uifigure('Name', 'Insert frequency limits for plot 1', 'Units','Normalized','Position', [0.3 0.4 0.25 0.15]);
    elseif model == "correlation"
    uiFig = uifigure('Name', 'Insert frequency limits for plot 2', 'Units','Normalized','Position', [0.3 0.4 0.25 0.15]);
    end
    % Creazione della domanda
    uilabel(uiFig, 'Text', 'Choose frequency range for automatic picking', 'Position', [30, 100, 350, 20],'FontName','Lucida Console');

    % Creazione del primo campo di input
    uilabel(uiFig, 'Text', 'lower frequency:', 'Position', [30, 60, 120, 20],'FontName','Lucida Console');
    edit1 = uieditfield(uiFig, 'numeric', 'Position', [150, 60, 50, 20]);

    % Creazione del secondo campo di input
    uilabel(uiFig, 'Text', 'upper frequency:', 'Position', [30, 30, 120, 20],'FontName','Lucida Console');
    edit2 = uieditfield(uiFig, 'numeric', 'Position', [150, 35, 50, 20]);

    % Bottone di conferma
    btn = uibutton(uiFig, 'Text', 'OK', 'Position', [230, 40, 100, 30], ...
        'FontName','Lucida Console','ButtonPushedFcn', @(btn,event) confirmValues(uiFig, edit1, edit2));

    % Aspetta che l'utente inserisca i valori e prema OK
    uiwait(uiFig);

    % Recupera i valori salvati nella finestra
    val1 = uiFig.UserData.val1;
    val2 = uiFig.UserData.val2;
    delete(uiFig); % Chiude la finestra dopo l'input
end

function confirmValues(uiFig, edit1, edit2)
    % Salva i valori inseriti
    uiFig.UserData.val1 = edit1.Value;
    uiFig.UserData.val2 = edit2.Value;
    
    % Permette al codice principale di continuare
    uiresume(uiFig);
end

