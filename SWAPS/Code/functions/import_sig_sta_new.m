
function [sig, xsta, ysta] = import_sig_sta_new(input_sig, input_sta, idx, fs)

% 'import_sig_sta' function imports traces and receivers based on the
% selected records
ok = false;

signal = readmatrix(input_sig);
sta = readmatrix(input_sta);

sta_name = readcell(input_sta);
sta_name = sta_name(:,1);

sig = zeros(size(signal,1),2);

% subtract the mean from the signals and normalize them by the st.deviation
for j = 1:size(signal,2)
    signal(:,j) = signal(:,j)-mean(signal(:,j));
    sig(:,j) = signal(:,j)/std(signal(:,j));
end

xsta = sta(:,2);
ysta = sta(:,3);

sig = sig(:,idx); 
xsta = xsta(idx); 
ysta = ysta(idx);

t = 0:1/fs:(length(sig)-1)/fs;

%%

% Crea la finestra per visualizzare i segnali
fig = uifigure('Name', 'Selected traces', 'Units', 'normalized', 'Position', [0.2, 0.3, 0.6, 0.5],'Color',[.95 .95 .95]);

% Pannello per i grafici
panel_name = ['stations: ',sta_name{idx(1)},' - ',sta_name{idx(2)}];
% panel = uipanel(fig, 'Title', panel_name,'Units','normalized', 'Position', [0.025, 0.05, 0.65, 0.9], 'BackgroundColor', [.95 .95 .95], ...
%     'FontSize',16,'FontName','Calibri','FontWeight','bold','BorderColor',[.95 .95 .95]);

annotation(fig, 'textbox','String',panel_name, ...
           'FontSize',15,'FontWeight','bold','FontName','Calibri', ...
           'HorizontalAlignment','center','EdgeColor', 'none','Position', ...
           [0.08, 0.85, 0.5, 0.1]);

% Crea un layout con due subplot uno sopra l'altro
ax1 = axes(fig,'Units','normalized', 'Position', [0.05, 0.52, 0.6, 0.3]);  % Prima traccia sopra
ax2 = axes(fig,'Units','normalized', 'Position', [0.05, 0.13, 0.6, 0.3]);   % Seconda traccia sotto

% Plot delle tracce
plot(ax1, t, sig(:, 1), 'k', 'LineWidth', 0.75);
% title(ax1, 'Traccia 1');
xlabel(ax1, 'Time (s)');
ylabel(ax1, 'Amplitude');
% grid(ax1, 'on');
xlim(ax1,[t(1) t(end)])

plot(ax2, t, sig(:, 2), 'k', 'LineWidth', 0.75);
% title(ax2, 'Traccia 2');
xlabel(ax2, 'Time (s)');
ylabel(ax2, 'Amplitude');
% grid(ax2, 'on');
xlim(ax2,[t(1) t(end)])

% Pannello a destra per i campi di input
% inputPanel = uipanel(fig, 'Title', 'Parametri', 'Units', 'normalized', 'Position', [0.75, 0.2, 0.20, 0.6]);

% Etichetta e campo di input per Start Time
startTimeLabel = uilabel(fig, 'Text', 'Start Time (s)', 'Position', [650, 330, 150, 30],'FontName','Calibri', 'FontSize', 14);
startTimeInput = uieditfield(fig, 'numeric','Value', round(t(1)), 'Position', [800, 330, 50, 30]);

% Etichetta e campo di input per End Time
endTimeLabel = uilabel(fig, 'Text', 'End Time (s)', 'Position', [650, 290, 150, 30],'FontName','Calibri', 'FontSize', 14);
endTimeInput = uieditfield(fig, 'numeric','Value', round(t(end)), 'Position', [800, 290, 50, 30]);

% Etichetta e campo di input per window
winLabel = uilabel(fig, 'Text', 'Window width (s)', 'Position', [650, 250, 150, 30],'FontName','Calibri', 'FontSize', 14);
winInput = uieditfield(fig, 'numeric','Value', 10, 'Position', [800, 250, 50, 30]);

ovlpLabel =  uilabel(fig, 'Text', 'Overlap (%)', 'Position', [650, 210, 150, 30],'FontName','Calibri', 'FontSize', 14);
ovlpInput = uieditfield(fig, 'numeric','Value', 0.9, 'Position', [800, 210, 50, 30]);

% Etichetta e campo di input per soglia
limLabel = uilabel(fig, 'Text', 'amp. threshold', 'Position', [650, 170, 150, 30],'FontName','Calibri', 'FontSize', 14);
limInput = uieditfield(fig, 'numeric','Value', 2, 'Position', [800, 170, 50, 30]);

% Bottone per confermare
btn_plt = uibutton(fig, 'Text', 'Select', 'Position', [650 130 200 30], 'ButtonPushedFcn', @(btn,event) update_win(fig,ax1,ax2,t,sig,fs,startTimeInput.Value,endTimeInput.Value,winInput.Value,limInput.Value,ovlpInput.Value));



btn = uibutton(fig, 'Text', 'Accept', 'Position', [700 30 100 30], 'ButtonPushedFcn', @(btn,event) accept(fig));


% Callback per aggiornare dinamicamente i limiti degli assi (xlim)
startTimeInput.ValueChangedFcn = @(src, event) update_xlim_start(src, ax1, ax2, t);
endTimeInput.ValueChangedFcn = @(src, event) update_xlim_end(src, ax1, ax2, t);

% Attende l'input dell'utente
uiwait(fig);


% Recupera i valori numerici di Start Time, End Time
startTime = startTimeInput.Value;
endTime = endTimeInput.Value;
w = winInput.Value;
lim = limInput.Value;

% Verifica se i valori sono validi
if any(isnan([startTime, endTime]))
    % Se uno dei valori non è valido, mostra un errore
    msgbox('Not valid value for Start and End time!', 'Warning', 'modal');
    return;  % Ferma l'esecuzione
end



% Elimina la finestra
delete(fig)


% Assegna le variabili all'ambiente di lavoro
assignin('base','ti',startTime)  % Assegna Start Time
assignin('base','tf',endTime)  % Assegna End Time
assignin('base','lim',lim)  % Assegna End Time
assignin('base','w',w);


end


% Funzione per aggiornare dinamicamente i limiti di xlim quando si cambia Start Time
function update_xlim_start(src, ax1, ax2, t)
    % Ottieni il valore di startTime
    startTime = src.Value;

    % Ottieni i limiti correnti di xlim
    ax1_xlim = xlim(ax1);
    ax2_xlim = xlim(ax2);

    % Imposta il limite inferiore di xlim per entrambi i plot
    if ~isnan(startTime) && startTime<ax1_xlim(2)
        xlim(ax1, [startTime, ax1_xlim(2)]);
        xlim(ax2, [startTime, ax2_xlim(2)]);
    elseif startTime>ax1_xlim(2)
        warndlg("Check Start and End time");
    end
end

% Funzione per aggiornare dinamicamente i limiti di xlim quando si cambia End Time
function update_xlim_end(src, ax1, ax2, t)
    % Ottieni il valore di endTime
    endTime = src.Value;

    % Ottieni i limiti correnti di xlim
    ax1_xlim = xlim(ax1);
    ax2_xlim = xlim(ax2);

    % Imposta il limite superiore di xlim per entrambi i plot
    if ~isnan(endTime) && endTime>ax1_xlim(1)
        xlim(ax1, [ax1_xlim(1), endTime]);
        xlim(ax2, [ax2_xlim(1), endTime]);
    elseif endTime<ax1_xlim(1)
        warndlg("Check Start and End time");
    end
end

               


function update_win(fig,ax1,ax2,t,sig,fs,startTime,endTime,w,lim,ovlp)

if w<endTime-startTime
startTime = startTime*fs;
endTime = endTime*fs;

plot(ax1,t,sig(:,1),'k','LineWidth',0.75)
xlim(ax1,[startTime/fs endTime/fs])
plot(ax2,t,sig(:,2),'k','LineWidth',0.75)
xlim(ax2,[startTime/fs endTime/fs])

w = w*fs;
startTime = max([startTime 1]);
lim1 = lim*std(sig(startTime:endTime,1));
lim2 = lim*std(sig(startTime:endTime,2));
dw = round(w-ovlp*w);

hold(ax1,'on')
hold(ax2,'on')

ti_win = zeros(length(startTime:dw:endTime),1);
tf_win = zeros(length(startTime:dw:endTime),1);
ht = zeros(length(startTime:dw:endTime),length(1-round(w/2):1+round(w/2)));
hs1 = zeros(length(startTime:dw:endTime),length(1-round(w/2):1+round(w/2)));
hs2 = zeros(length(startTime:dw:endTime),length(1-round(w/2):1+round(w/2)));

i = 0;
for jj = startTime+round(w/2):dw:endTime-round(w/2)
    tr1 = sig(jj-round(w/2):jj+round(w/2),1);
    tr2 = sig(jj-round(w/2):jj+round(w/2),2);
    if std(tr1) < lim1 && std(tr2)<lim2            
    i = i+1;
    ti_win(i) = jj-round(w/2);
    tf_win(i) = jj+round(w/2);

    ht(i,:) = t(jj-round(w/2):jj+round(w/2));
    hs1(i,:) = sig(jj-round(w/2):jj+round(w/2), 1);
    hs2(i,:) = sig(jj-round(w/2):jj+round(w/2), 2);

    end
end

ti_win(ti_win == 0) = [];
tf_win(tf_win == 0) = [];

ht(i+1:end,:) = [];
hs1(i+1:end,:) = [];
hs2(i+1:end,:) = [];

ht = ht'; ht = ht(:);
hs1 = hs1'; hs1 = hs1(:);
hs2 = hs2'; hs2 = hs2(:);

assignin('base','ti_win',ti_win)
assignin('base','tf_win',tf_win)
% w = w/fs;
assignin('base','w',w)

scatter(ax1,ht,hs1,10,'.','Color','r')   
scatter(ax2,ht,hs2,10,'.','Color','r')  



hold(ax1,'off')
hold(ax2,'off')

ok = true;
setappdata(fig, 'ok', ok);

else 
    warndlg("Check parameters");
end
end

function accept(fig)

ok = getappdata(fig, 'ok');
if ok
    uiresume(fig)
else
    warndlg("First set the threshold and press 'select'");
end

end
