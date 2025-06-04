
function multi_plot_win_bis(project)


cd(project)

% check if report folder exists
if exist('report.csv','file')
    report = readcell('report.csv');
else
    msgbox("No synthetic file  has been found, first create it and then use the plot function to display curves ")
end   

cd ..\


for kk = 1:size(report,1)
    for kkk = 1:size(report,2)
        if ismissing(report{kk,kkk})
            report{kk,kkk} = nan;
        end
    end
end


% ----- select file stations and choose  stations in the report file ---- %

[file_sta,sta_path] = uigetfile('*.*','Select file with station coordinates');
cd(sta_path)
receiv = readcell(file_sta);

local_sta = report(1,2:end);
i = 0;
usta = cell(1,1);
for kk = 1:length(local_sta)
    i=i+1;
    [usta{i,1},rest] = strtok(local_sta{kk},'_');
    i=i+1;
    usta{i,1} = strtok(rest,'_');
end
usta = unique(usta);

jj = 0;
for kk = 1:length(usta)
    for i = 1:size(receiv,1)
        if strcmp(usta{kk},receiv{i,1})
            jj = jj +1;
            STA(jj,:) = receiv(i,:);
        end
    end
end

sta = STA(:,1);
for kk = 1:size(STA,1)
xsta(kk,1) = STA{kk,2};
ysta(kk,1) = STA{kk,3};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
parts = split(project, filesep);
name = parts{end};
% main GUI
fig = figure('Units', 'normalized', ...
             'Position', [0.12,0.15,0.75,0.75], ...
             'Name', name, ...
             'MenuBar', 'none', ...
             'ToolBar', 'none', ...
             'NumberTitle', 'off');


axax = uiaxes(fig, ...
    'Units', 'Normalized', ...
    'Position', [0.01 0.3 0.7 0.65], ...
    'Box', 'on', ...
    'FontSize', 12);





xlim(axax, 'auto');
ylim(axax, 'auto');
box(axax,'on');
grid(axax,'on');
xlabel(axax,'Frequency (Hz)')
ylabel(axax,'Velocity (m/s)')

xmin = min(xsta);
xmax = max(xsta);
ymin = min(ysta);
ymax = max(ysta);

% compute axis limits
xrange = xmax - xmin;
yrange = ymax - ymin;
   
marginX = 0.1 * xrange;
marginY = 0.1 * yrange;

axInset = uiaxes(fig, ...
    'Units', 'normalized', ...
    'Position', [0.715, 0.57, 0.27, 0.37], ...
    'Box', 'on', ...
    'FontSize', 10);
title(axInset, 'Station Location','FontSize',12);

% plot stations
scatter(axInset, xsta, ysta, 40, '^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
axInset.XLim = [xmin - marginX, xmax + marginX];
axInset.YLim = [ymin - marginY, ymax + marginY];    
axis(axInset,'equal')
grid(axInset,"on");
axInset.XColor = [0 0 0];
axInset.YColor = [0 0 0];

  
yrange = range(axInset.YLim);
xOffset = 0;
yOffset = -0.017* yrange;


% label for stations
for i = 1:length(xsta)
    text(axInset, xsta(i) + xOffset, ysta(i) + yOffset, STA{i}, ...
        'FontSize', 12, ...
        'FontName','Lucida Console', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Clipping','on');
end


% =================== Main plot cycle with dataTips ===================== %
frequency = cell2mat(report(2:end, 1));              
nCurve = size(report, 2) - 1;              

legendHandles = gobjects(1, nCurve);        
legendTexts = report(1, 2:end);           

hold(axax, 'on')

for i = 1:nCurve
    velocity = cell2mat(report(2:end, i+1));

    f_valid = frequency(~isnan(frequency) & ~isnan(velocity));
    v_valid = velocity(~isnan(frequency) & ~isnan(velocity));

    h = plot(axax, f_valid, v_valid, 'o-', ...
             'Color', 'k', ...
             'LineWidth', 0.75, ...
             'MarkerSize', 2);

    % Personalizza i DataTip
    dt1 = h.DataTipTemplate.DataTipRows(1);
    dt1.Label = 'f (Hz):';
    dt2 = h.DataTipTemplate.DataTipRows(2);
    dt2.Label = 'v (m/s):';

    % Nome della curva
    curveName = strrep(legendTexts{i}, '_', '-');
    dt3 = dataTipTextRow('Curve', repmat({curveName}, numel(f_valid), 1));

    % Calcolo distanza tra stazioni
    parts = split(legendTexts{i}, {'-', '_'});
    if numel(parts) == 2
        idx1 = find(strcmp(STA(:,1), parts{1}));
        idx2 = find(strcmp(STA(:,1), parts{2}));
        if ~isempty(idx1) && ~isempty(idx2)
            x1 = STA{idx1,2}; y1 = STA{idx1,3};
            x2 = STA{idx2,2}; y2 = STA{idx2,3};
            dist = sqrt((x1 - x2)^2 + (y1 - y2)^2);
            distStr = sprintf('%.1f m', dist);
        else
            distStr = 'n/a';
        end
    else
        distStr = 'n/a';
    end

    dt4 = dataTipTextRow('Distance', repmat({distStr}, numel(f_valid), 1));

    % Assegna tutti i datatip
    h.DataTipTemplate.DataTipRows = [dt1; dt2; dt3; dt4];

    datacursormode(fig, 'on');

    legendHandles(i) = h;
end




hold(axax, 'off')

fig.UserData.legendHandles = legendHandles;
fig.UserData.legendTexts = legendTexts;

xl = axax.XLim;
yl = axax.YLim;

%%

% Main parameters %

% set lower frequency of axax
uicontrol(fig, 'Style', 'text', ...
    'String', 'lower frequency (hz):', ...
    'Units', 'normalized', ...
    'Position', [0.01 0.2 0.2 0.05], ...
    'FontSize', 10);
editXmin = uicontrol(fig, 'Style', 'edit', ...
    'String', num2str(xl(1)), ...
    'Units', 'normalized', ...
    'Position', [0.18 0.22 0.05 0.03]);


% set upper frequency
uicontrol(fig, 'Style', 'text', ...
    'String', 'upper frequency (hz):', ...
    'Units', 'normalized', ...
    'Position', [0.01 0.15 0.2 0.05], ...
    'FontSize', 10);    
editXmax = uicontrol(fig, 'Style', 'edit', ...
    'String', num2str(xl(2)), ...
    'Units', 'normalized', ...
    'Position', [0.18 0.17 0.05 0.03]);

% button to update frequency limits
btn_xlim = uicontrol(fig, 'Style', 'pushbutton', ...
    'String', 'Update frequency limits', ...
    'Units', 'normalized', ...
    'Position', [0.08 0.09 0.12 0.05], ...
    'Callback', @(src, event) updateLimitsX(str2double(get(editXmin, 'string')), str2double(get(editXmax, 'string')), axax));



% set lower velocity   
uicontrol(fig, 'Style', 'text', ...
    'String', 'lower velocity (m/s):', ...
    'Units', 'normalized', ...
    'Position', [0.26 0.2 0.12 0.05], ...
    'FontSize', 10);
editYmin = uicontrol(fig, 'Style', 'edit', ...
    'String', num2str(yl(1)), ...
    'Units', 'normalized', ...
    'Position', [0.38 0.22 0.05 0.03]);


% set upper velocity
uicontrol(fig, 'Style', 'text', ...
    'String', 'upper velocity (m/s):', ...
    'Units', 'normalized', ...
    'Position', [0.26 0.15 0.12 0.05], ...
    'FontSize', 10);    
editYmax = uicontrol(fig, 'Style', 'edit', ...
    'String', num2str(yl(2)), ...
    'Units', 'normalized', ...
    'Position', [0.38 0.17 0.05 0.03]);


% button to update velocity limits
btn_ylim = uicontrol(fig, 'Style', 'pushbutton', ...
        'String', 'Update velocity limits', ...
        'Units', 'normalized', ...
        'Position', [0.285 0.09 0.12 0.05], ...
        'Callback', @(src, event) updateLimitsY(str2double(get(editYmin, 'string')), str2double(get(editYmax, 'string')), axax));

%%
fig.UserData.searchFields = {};  % each element will be a struct with .edit1 e .edit2


% panel to select dispersion curves
panelSearch = uipanel(fig, ...
    'Units', 'normalized', ...
    'Position', [0.74, 0.05, 0.23, 0.5], ...
    'Title', 'Select curves','BackgroundColor','w');


% show oncly selected dispersion curves
chkVisible = uicontrol(panelSearch, ...
    'Style', 'checkbox', ...
    'String', 'Display only selected curves', ...
    'Units', 'Normalized', ...
    'Position', [0.05 0.01 0.7 0.1], ...
    'Value', 0, ...
    'BackgroundColor', 'w');

set(chkVisible, 'Callback', @(src, event) updateHighlight(fig, axax, chkVisible, editXmin, editXmax, editYmin, editYmax));


fig.UserData.chkVisible = chkVisible;

% name of station 1
label1 = uicontrol(panelSearch, ...
    'Style', 'text', ...
    'String', 'sta:', ...
    'Units', 'Normalized', ...
    'Position', [0.03 0.85 0.2 0.1], ...
    'BackgroundColor', 'w', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 10);
editSta1 = uicontrol(panelSearch, ...
    'Style', 'edit', ...
    'String', '', ...
    'Units', 'Normalized', ...
    'Position', [0.12 0.89 0.16 0.06], ...
    'BackgroundColor', [0.95 0.95 0.95], ...
    'ForegroundColor', [0 0 0], ...
    'Callback', @(src, event) updateHighlight(fig, axax, chkVisible, editXmin, editXmax, editYmin, editYmax));


% name of station 2
label2 = uicontrol(panelSearch, ...
    'Style', 'text', ...
    'String', 'sta:', ...
    'Units', 'Normalized', ...
    'Position', [0.32 0.85 0.2 0.1], ...
    'BackgroundColor', 'w', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 10);
editSta2 = uicontrol(panelSearch, ...
    'Style', 'edit', ...
    'String', '', ...
    'Units', 'Normalized', ...
    'Position', [0.41 0.89 0.16 0.06], ...
    'BackgroundColor', [0.95 0.95 0.95], ...
    'ForegroundColor', [0 0 0], ...
    'Callback', @(src, event) updateHighlight(fig, axax, chkVisible, editXmin, editXmax, editYmin, editYmax));


fig.UserData.searchFields{end+1} = struct('edit1', editSta1, 'edit2', editSta2);

%%

% plot confidence interval for selected curve
chkErr = uicontrol(panelSearch, ...
    'Style', 'checkbox', ...
    'String', 'conf.', ...
    'Units', 'Normalized', ...
    'Position', [0.65 0.89 0.18 0.06], ...
    'TooltipString', 'confidence interval', ...
    'Value', 0, ...
    'BackGroundColor','w'); 

set(chkErr, 'Callback', @(src, event) toggle_conf(src, fig, axax, project));



fig.UserData.searchFields{end+1} = struct( ...
    'edit1', editSta1, ...
    'edit2', editSta2, ...
    'checkbox', chkErr);



% button to select others curves 
btnAdd = uicontrol(panelSearch, ...
    'Style', 'pushbutton', ...
    'String', 'Add curve', ...
    'Units', 'Normalized', ...
    'Position', [0.68 0.03 0.27 0.07]);

set(btnAdd, 'Callback', @(src, event) AddLine(fig, panelSearch, axax, project, editXmin, editXmax, editYmin, editYmax));


btnSave = uicontrol(fig, ...
    'Style', 'pushbutton', ...
    'String', 'Save plot', ...
    'Units', 'normalized', ...
    'Position', [0.02, 0.02, 0.1, 0.05]);

set(btnSave, 'Callback', @(src, event) saveAxAsJPEG(axax));

%%
 

uicontrol(fig, 'Style', 'text', ...
    'String', 'Min distance (m):', ...
    'Units', 'normalized', ...
    'Position', [0.48 0.2 0.12 0.05], ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [.95 .95 .95], ...
    'FontSize', 10);

editDistMin = uicontrol(fig, 'Style', 'edit', ...
    'String', '', ...
    'Units', 'normalized', ...
    'Position', [0.58, 0.22, 0.05, 0.03]);



uicontrol(fig, 'Style', 'text', ...
    'String', 'Max distance (m):', ...
    'Units', 'normalized', ...
    'Position', [0.48, 0.15, 0.12, 0.05], ...
    'HorizontalAlignment', 'left', ...
    'BackgroundColor', [.95 .95 .95], ...
    'FontSize',10);

editDistMax = uicontrol(fig, 'Style', 'edit', ...
    'String', '', ...
    'Units', 'normalized', ...
    'Position', [0.58, 0.17, 0.05, 0.03]);

btnFilter = uicontrol(fig, 'Style', 'pushbutton', ...
    'String', 'Select by distance', ...
    'Units', 'normalized', ...
    'Position', [0.48, 0.09, 0.15, 0.05]);

set(btnFilter, 'Callback', @(src, event) filterByDistance(fig, axax, STA, editDistMin, editDistMax));
   


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

function updateLimitsX(editXmin, editXmax, axax)
    if ~isempty(editXmin) && ~isempty(editXmax) && ~isnan(editXmin) && ~isnan(editXmax) && editXmin < editXmax
        xlim(axax, [editXmin editXmax]);
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

function updateLimitsY(editYmin, editYmax, axax)
    if ~isempty(editYmin) && ~isempty(editYmax) && ~isnan(editYmin) && ~isnan(editYmax) && editYmin < editYmax
        ylim(axax, [editYmin editYmax]);
    end
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

function updateHighlight(fig, axax, chkVisible, editXmin, editXmax, editYmin, editYmax)

% Applica eventuale maschera filtrata per distanza
if isfield(fig.UserData, 'curveMask') && ~isempty(fig.UserData.curveMask)
    visibleMask = fig.UserData.curveMask;
else
    visibleMask = true(1, length(fig.UserData.legendTexts));
end




for ii = 1:length(fig.UserData.legendHandles)
    fig.UserData.legendHandles(ii).Color = [0.7 0.7 0.7];
    fig.UserData.legendHandles(ii).LineWidth = 0.8;
    fig.UserData.legendHandles(ii).Visible = visibleMask(ii);  % mostra solo se ammessa
end



    daMostrare = false(1, length(fig.UserData.legendHandles));  % tracking visibility

    % Iteration over all pairs in fig.UserData.searchFields
    for riga = 1:numel(fig.UserData.searchFields)
        name1 = lower(strtrim(get(fig.UserData.searchFields{riga}.edit1, 'String')));
        name2 = lower(strtrim(get(fig.UserData.searchFields{riga}.edit2, 'String')));

        if isempty(name1) || isempty(name2)
            continue;
        end

        for ii = 1:length(fig.UserData.legendTexts)
            % Split del nome tipo 'sta1-sta5'
            splitName = split(lower(fig.UserData.legendTexts{ii}), {'-', '_'});

            if numel(splitName) ~= 2
                continue;
            end

            staA = strtrim(splitName{1});
            staB = strtrim(splitName{2});

            % Verifica entrambe le combinazioni
            % if (strcmp(name1, staA) && strcmp(name2, staB)) || ...
            %    (strcmp(name1, staB) && strcmp(name2, staA))              
            
                
            if visibleMask(ii) && ...
               ((strcmp(name1, staA) && strcmp(name2, staB)) || ...
                (strcmp(name1, staB) && strcmp(name2, staA)))              
                
                fig.UserData.legendHandles(ii).Color = 'k';
                fig.UserData.legendHandles(ii).LineWidth = 1.5;
                uistack(fig.UserData.legendHandles(ii), 'top');
                daMostrare(ii) = true;
            end
        end
    end

    % Nasconde le curve non selezionate, se richiesto
    if get(chkVisible, 'Value')  % anche chk è uicontrol!
        for ii = 1:length(fig.UserData.legendHandles)
            if ~daMostrare(ii)
                fig.UserData.legendHandles(ii).Visible = 'off';
            end
        end
    end

    % Aggiorna i limiti visualizzati nei campi edit
    xl = xlim(axax);
    yl = ylim(axax);
    set(editXmin, 'String', num2str(xl(1)));
    set(editXmax, 'String', num2str(xl(2)));
    set(editYmin, 'String', num2str(yl(1)));
    set(editYmax, 'String', num2str(yl(2)));
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%



function AddLine(fig, panelSearch, axax, project, editXmin, editXmax, editYmin, editYmax)
    nLines = numel(fig.UserData.searchFields);
    yPos = 0.92 - nLines * 0.07;

    % Label 1
    label1 = uicontrol(panelSearch, ...
        'Style', 'text', ...
        'String', 'sta:', ...
        'Units', 'Normalized', ...
        'Position', [0.03 yPos 0.2 0.1], ...
        'BackgroundColor', 'w', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 10);

    % Campo edit1
    edit1 = uicontrol(panelSearch, ...
        'Style', 'edit', ...
        'String', '', ...
        'Units', 'Normalized', ...
        'Position', [0.12 yPos+0.04 0.16 0.06], ...
        'BackgroundColor', [0.95 0.95 0.95], ...
        'ForegroundColor', [0 0 0], ...
        'Callback', @(src, event) updateHighlight(fig, axax, fig.UserData.chkVisible, editXmin, editXmax, editYmin, editYmax));

    % Label 2
    label2 = uicontrol(panelSearch, ...
        'Style', 'text', ...
        'String', 'sta:', ...
        'Units', 'Normalized', ...
        'Position', [0.32 yPos 0.2 0.1], ...
        'BackgroundColor', 'w', ...
        'HorizontalAlignment', 'left', ...
        'FontSize', 10);

    % Campo edit2
    edit2 = uicontrol(panelSearch, ...
        'Style', 'edit', ...
        'String', '', ...
        'Units', 'Normalized', ...
        'Position', [0.41 yPos+0.04 0.16 0.06], ...
        'BackgroundColor', [0.95 0.95 0.95], ...
        'ForegroundColor', [0 0 0], ...
        'Callback', @(src, event) updateHighlight(fig, axax, fig.UserData.chkVisible, editXmin, editXmax, editYmin, editYmax));

    % Checkbox conf.
    chkErr = uicontrol(panelSearch, ...
        'Style', 'checkbox', ...
        'String', 'conf.', ...
        'Units', 'Normalized', ...
        'Position', [0.65 yPos+0.04 0.18 0.06], ...
        'TooltipString', 'confidence interval', ...
        'Value', 0, ...
        'BackGroundColor','w');
    set(chkErr, 'Callback', @(src, event) toggle_conf(src, fig, axax, project));

    % Bottone "X"
    btnClose = uicontrol(panelSearch, ...
        'Style', 'pushbutton', ...
        'String', 'X', ...
        'Units', 'Normalized', ...
        'Position', [0.85 yPos+0.04 0.12 0.07]);
set(btnClose, 'Callback', @(src, event) deleteLine(src, fig, axax, editXmin, editXmax, editYmin, editYmax));

    % Salva tutto
    fig.UserData.searchFields{end+1} = struct( ...
        'label1', label1, ...
        'label2', label2, ...
        'edit1', edit1, ...
        'edit2', edit2, ...
        'checkbox', chkErr, ...
        'button', btnClose);
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%


    function deleteLine(button, fig, axax, editXmin, editXmax, editYmin, editYmax)
    for ij = 1:numel(fig.UserData.searchFields)
        r = fig.UserData.searchFields{ij};
        if isfield(r, 'button') && isequal(r.button, button)
            delete(r.label1);
            delete(r.label2);
            delete(r.edit1);
            delete(r.edit2);
            delete(r.checkbox);
            delete(r.button);
            delete(findall(axax, 'Tag', ['inc_' num2str(ij)]));
            fig.UserData.searchFields(ij) = [];
            updateHighlight(fig, axax, fig.UserData.chkVisible, editXmin, editXmax, editYmin, editYmax);
            break;
        end
    end
end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

    function toggle_conf(src, fig, axax, project)
    for ik = 1:numel(fig.UserData.searchFields)
        r = fig.UserData.searchFields{ik};
        
        if ~isfield(r, 'checkbox')
            continue;  
        end

        if isequal(r.checkbox, src)
            
            delete(findall(axax, 'Tag', ['inc_' num2str(ik)]));

            if get(src, 'Value')
                name1 = lower(strtrim(get(r.edit1, 'String')));
                name2 = lower(strtrim(get(r.edit2, 'String')));

                if ~isempty(name1) && ~isempty(name2)
                    plot_conf(name1, name2, project, axax, ik);
                end
            end
            break;
        end
    end
end





%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

    function plot_conf(name1, name2, project, ax, idx)
    % Generate two potential stations names
    c1 = [lower(name1), '_', lower(name2), '_SWAPS'];
    c2 = [lower(name2), '_', lower(name1), '_SWAPS'];

    % Try both directions (staA-staB or staB-staA)
    possible_folder = {fullfile(project, c1), fullfile(project, c2)};
    found_folder = '';

    for k = 1:2
        if exist(possible_folder{k}, 'dir')
            found_folder = possible_folder{k};
            break;
        end
    end

    if isempty(found_folder)
        warning('No folder found in %s-%s', name1, name2);
        return;
    end

fileCSV = fullfile(found_folder, 'phasevelocity.csv');

if exist(fileCSV, 'file')
    dati = readtable(fileCSV, 'VariableNamingRule', 'preserve');
else
    warning('File CSV phasevelocity.csv not found in %s', found_folder);
    return;
end

    % Take columns of data
    f = dati{:,1};
    v = dati{:,2};
    vmin = dati{:,3};
    vmax = dati{:,4};

    % compute error bar
    errLow = v - vmin;
    errHigh = vmax - v;

    % Plot error bar
    hold(ax, 'on');
    errorbar(ax, f, v, errLow, errHigh, ...
        'LineStyle', 'none', ...
        'Color', [0 0 0], ...
        'Tag', ['inc_' num2str(idx)]);
    hold(ax, 'off');
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

function saveAxAsJPEG(ax)
    [file, path] = uiputfile('*.jpg', 'Save plot as');
    if isequal(file, 0)
        return; % annullato
    end
    f = figure('Units','Normalized','Position',[0.15 0.2 0.7 0.6],'Visible', 'off');
    copyax = copyobj(ax, f); % copia l'asse
    set(copyax, 'Units','Normalized','Position', [0.05 0.05 0.9 0.9]);
    saveas(f, fullfile(path, file));
    close(f);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

function filterByDistance(fig, axax, STA, editMin, editMax)
    dmin = str2double(get(editMin, 'String'));
    dmax = str2double(get(editMax, 'String'));
    if isnan(dmin) || isnan(dmax) || dmin > dmax
        warndlg('Check min and max distance values.', 'Input error');
        return;
    end

    % Inizializza maschera per curve da mostrare
    mask = false(1, length(fig.UserData.legendTexts));

    % Nasconde tutte le curve
    for hh = fig.UserData.legendHandles
        hh.Visible = 'off';
    end

    % Valuta la distanza per ogni coppia
    for ii = 1:length(fig.UserData.legendTexts)
        name = fig.UserData.legendTexts{ii};
        parts = split(name, {'-', '_'});
        if numel(parts) ~= 2, continue; end

        idx1 = find(strcmp(STA(:,1), parts{1}));
        idx2 = find(strcmp(STA(:,1), parts{2}));
        if isempty(idx1) || isempty(idx2), continue; end

        x1 = STA{idx1,2}; y1 = STA{idx1,3};
        x2 = STA{idx2,2}; y2 = STA{idx2,3};
        dist = sqrt((x1 - x2)^2 + (y1 - y2)^2);

        if dist >= dmin && dist <= dmax
            fig.UserData.legendHandles(ii).Visible = 'on';
            mask(ii) = true;
        end
    end

    % Salva la maschera nella figura
    fig.UserData.curveMask = mask;
end























end




















