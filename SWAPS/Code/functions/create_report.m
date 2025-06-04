function create_report()
%%
folder = uigetdir('');

cd(folder)

if exist('report.csv','file')
    delete('report.csv')
end


disp = dir(folder);
analysis = disp([disp.isdir]);
analysis = analysis(3:end);

%%

kk = 0;
for k = 1:length(analysis)
    cd(analysis(k).name)

    if ~exist('phasevelocity.csv','file')
        cd ..\
    else
        kk = kk + 1;
        phasevel = readcell("phasevelocity.csv");
        phasevel = phasevel(2:end,1:2);

        data{kk} = phasevel;
        pair{kk} = analysis(k).name(1:end-6);
        clear phasevel
        cd ..\
    end

end

%%

for k = 1:length(data)
    fmax(k) = max(cell2mat(data{k}(:,1)));
end

fmax=max(fmax);
f = 0.5:0.5:fmax;

report = cell(length(0.5:0.5:fmax),length(data)+1);

for k = 1:size(report,1)
    report{k,1} = f(k);
end

for k = 1:length(data)
    phasevel = data{k};

    for kk = 1:length(f)
        for kkk = 1:size(phasevel,1)
            if f(kk) == phasevel{kkk,1}

                report{kk,k+1} = phasevel{kkk,2};

            end
        end
    end
end


header = [{'Frequency[hz]'} pair];


T = cell2table(report, 'VariableNames', ...
    header);

writetable(T, 'report.csv', 'Delimiter', ';');



cd ..\

assignin('base','folder',folder)


end

