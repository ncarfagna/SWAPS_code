
function cartellaRisultati = Savefold(defaultDir)

    if nargin < 1
        defaultDir = pwd; % Default to the current folder
    end

    % Create the main figure window
    fig = figure('Name', 'Select Results Folder', 'Units', 'normalized', 'Position', [0.4, 0.4, 0.22, 0.12], 'Color', [.95 .95 .95], ...
        'MenuBar','none','ToolBar','none','NumberTitle','off');

    % Label asking the question
    uicontrol(fig, 'Style', 'text', 'String', 'Select an existing folder or create a new one', ...
              'Position', [20, 50, 300, 30], 'FontSize', 10, 'FontName', 'Calibri');

    % "Select existing" button
    btn_seleziona = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Select existing', ...
                              'Position', [20, 20, 100, 30], 'FontSize', 10, 'FontName', 'Calibri', ...
                              'Callback', @(btn, event) selectFolder(fig, 'Select existing', defaultDir));

    % "Create new" button
    btn_crea = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Create new', ...
                         'Position', [120, 20, 100, 30], 'FontSize', 10, 'FontName', 'Calibri', ...
                         'Callback', @(btn, event) createFolder(fig, defaultDir));

    % "Cancel" button
    btn_annulla = uicontrol(fig, 'Style', 'pushbutton', 'String', 'Cancel', ...
                            'Position', [220, 20, 100, 30], 'FontSize', 10, 'FontName', 'Calibri', ...
                            'Callback', @(btn, event) cancelOperation(fig));

    % Variable to store the result
    cartellaRisultati = '';

    % Wait for user selection
    uiwait(fig);  

    % Function to select an existing folder
    function selectFolder(fig, type, defaultDir)
        if strcmp(type, 'Select existing')
            selectedFolder = uigetdir(defaultDir, 'Select the folder for the results');
            if isequal(selectedFolder, 0)
                cartellaRisultati = '';
                uiresume(fig);
                return;
            end
            cartellaRisultati = selectedFolder;
        end
        close(fig);
    end

    % Function to create a new folder
    function createFolder(fig, defaultDir)
        answer = inputdlg('Enter the name of the new folder:', 'Create Folder', 1, {'new_folder'});
        if isempty(answer)
            cartellaRisultati = '';
            close(fig);
            return;
        end
        nuovaCartella = fullfile(defaultDir, answer{1});
        if ~isfolder(nuovaCartella)
            mkdir(nuovaCartella);
            cartellaRisultati = nuovaCartella;
        else
            cartellaRisultati = nuovaCartella;
        end
        close(fig);
    end

    % Function to cancel the operation
    function cancelOperation(fig)
        cartellaRisultati = '';
        close(fig);
    end
end
