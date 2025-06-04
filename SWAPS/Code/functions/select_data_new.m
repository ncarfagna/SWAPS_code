
function [nrec, receiv, idx] = select_data_new(input_sig,input_sta)




sta = readcell(input_sta); % read data from file_station
sta_name = sta(:,1);  % name of the stations
coords = cell2mat(sta(:,2:3));  % Coordinates x and y 


fid = fopen(input_sig, 'r');
row1 = fgetl(fid);
fclose(fid);
sig = str2num(row1);
check1 = length(sig);


check2 = size(sta,1); % read number of channels

% Se ci sono meno di due tracce, errore
if check1 < 2 || check2 < 2 || check1 ~= check2
errordlg('Wrong number of stations or traces. Check input files', 'Error');
error(' Wrong number of stations or traces. Check input files ');  % Ferma effettivamente
% uiwait(errordlg('Errore: file mancante o dati insufficienti.', 'Errore'));
% exit; 
end

%%
% Crea la finestra di dialogo
fig2 = uifigure('Name', 'Select Traces', 'Units','normalized','Position', [0.2,0.23,0.60,0.50]);

% Testo descrittivo

uilabel(fig2, 'Text', sprintf('Imported traces: %d', check2), ...
    'Position', [150 360 300 30], 'FontSize', 16,'FontName','Calibri');
uilabel(fig2, 'Text', sprintf('Press CTRL and select two or more receivers '), ...
    'Position', [120 120 300 30], 'FontSize', 10,'FontName','Calibri');

% Lista delle tracce selezionabili
listbox = uilistbox(fig2, 'Items', string(sta(:,1))', ...
    'Multiselect', 'on', 'Position', [90 150 250 200],'FontSize',14,'FontName','Calibri');

% Bottone per confermare
btn = uicontrol(fig2, 'Style', 'pushbutton', 'String', 'Select', ...
                'Position', [160 40 100 30], 'FontName','Arial','FontSize',12,'BackgroundColor', 'white', ...
                'Callback', @(src, event) accept(fig2,listbox.Value));   


Fs_Label = uilabel(fig2, 'Text', 'Sampling Frequency', 'Position', [120, 90, 130, 30], 'FontSize', 12);
fs = uieditfield(fig2,'numeric', 'Value', 256, 'Position', [250, 95, 50, 20]);
%fs  = str2double(Fs_Input.Value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%



%%

% Aggiungi un'area di plot per le coordinate delle stazioni
ax = axes(fig2, 'Position', [0.5 0.15 0.4 0.7]);  % Posizione del grafico nel pannello
hold(ax, 'on');

% Plot delle coordinate X, Y (tutte le stazioni)
scatter(ax, coords(:,1), coords(:,2), 50, 'Marker', '^', 'MarkerFaceColor', [0.4660 0.6740 0.1880], 'MarkerEdgeColor', 'k');
xlabel(ax, 'x-direction (m)');
ylabel(ax, 'y-direction (m)');
% title(ax, 'Station Coordinates');
grid(ax, 'on');
box(ax,'on')
set(ax,'FontName','Calibri')
% Variabile per tracciare i marker delle stazioni selezionate (definita globalmente)
global selected_markers;
selected_markers = [];

% Variabile per il testo della distanza (per la visualizzazione accanto al grafico)
distance_label = uilabel(fig2, 'Position', [350 120 300 30], 'FontSize', 14, 'FontName', 'Calibri', 'Text', '');

% Callback per la selezione delle stazioni dalla listbox
listbox.ValueChangedFcn = @(src, event) update_plot(src, ax, coords, sta_name, distance_label);

% Attende la selezione dell'utente
uiwait(fig2);

% Recupera le tracce selezionate
receiv = listbox.Value;
% [~, idx] = ismember(receiv, sta_name);

idx = [];  % Array vuoto per gli indici
for i = 1:length(receiv)
    % Trova l'indice per ogni stazione selezionata
    idx = [idx; find(strcmp(sta_name, receiv{i}))];  % Trova l'indice usando strcmp
end

fsValue = fs.Value;
delete(fig2)
% Numero di tracce selezionate
nrec = length(receiv);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5





%%
% Assegna le variabili all'ambiente di lavoro
assignin('base','nrec',nrec)
assignin('base','receiv',receiv)
assignin('base','idx',idx)
assignin('base','fs',fsValue)  % Assegna anche fs

end


%%

% Funzione per aggiornare il plot ogni volta che cambia la selezione nella listbox
function update_plot(src, ax, coords, sta_name, distance_label)
    % Rimuovi i marker precedenti (se esistono)
    global selected_markers;
    if ~isempty(selected_markers)
        delete(selected_markers);  % Rimuovi i marker precedenti
    end

    % Ottieni gli indici delle stazioni selezionate
    selected_station = src.Value;
    % idx = ismember(sta_name, selected_station);  % Trova gli indici delle stazioni selezionate
        idx = [];  % Array vuoto per gli indici
        for i = 1:length(selected_station)
            % Trova l'indice per ogni stazione selezionata
            idx = [idx; find(strcmp(sta_name, selected_station{i}))];  % Trova l'indice usando strcmp
        end    


    % Plot delle stazioni selezionate con marker rosso
    selected_markers = scatter(ax, coords(idx,1), coords(idx,2), 100, 'Marker', '^', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');  % Marker rosso

    % Se sono selezionate due stazioni, calcola la distanza
    if length(selected_station) == 2
        % Calcola la distanza tra le due stazioni selezionate
        x_diff = coords(idx(2),1) - coords(idx(1),1);  % Differenza X
        y_diff = coords(idx(2),2) - coords(idx(1),2);  % Differenza Y
        dist = sqrt(x_diff.^2 + y_diff.^2);  % Distanza tra le due stazioni

        % Debug per vedere il valore della distanza
        % disp(['Distance between ', selected_station{1}, ' and ', selected_station{2}, ' = ', num2str(dist), ' meters']);
        distance_label.Position = [570, 360, 300, 30];
        % Aggiorna il testo accanto al grafico con il nome delle stazioni e la distanza
        distance_label.Text = sprintf('%s - %s: r = %.2fm', selected_station{1}, selected_station{2}, dist);
    else
        % Se ci sono meno di due stazioni selezionate, non mostrare la distanza
        distance_label.Text = ' ';
    end

    % Aggiorna il grafico
    drawnow;
end

function accept(fig2,list)

if length(list)<2
    warndlg("Select at least two traces");
else
    uiresume(fig2)
end



end
