function saveInput()

receiv = evalin('base','receiv');

fs = evalin('base','fs');
ti = evalin('base','ti');
tf = evalin('base','tf');
w = evalin('base','w');
lim = evalin('base','lim');


if length(receiv) == 2
start_frequency = evalin('base','start_frequency');
end_frequency = evalin('base','end_frequency');
lb = evalin('base','lb');
ub = evalin('base','ub');
elseif length(receiv) > 2
start_frequency = evalin('base',"str2double(get(fiInput,'string'))");
end_frequency = evalin('base',"str2double(get(ffInput,'string'))");
lb = evalin('base',"str2double(get(viInput,'string'))");
ub = evalin('base',"str2double(get(vfInput,'string'))");    
end


win = evalin('base',"str2double(get(winInput,'string'))");
fstep1 = evalin('base',"str2double(get(stepInput,'string'))");
k1 = evalin('base',"str2double(get(k1Input,'string'))");
k2 = evalin('base',"str2double(get(k2Input,'string'))");


sdi = evalin('base',"str2double(get(sdiInput,'string'))");
sdf = evalin('base',"str2double(get(sdfInput,'string'))");
fstep2 = evalin('base',"str2double(get(fstepInput,'string'))");


dirname = evalin('base','dirname');
outputDir = evalin('base','outputDir');

cd(outputDir)
cd(dirname)








fileID = fopen('input_parameters.asc', 'w');

fprintf(fileID, 'Input Parameters \n\n');
fprintf(fileID, 'Time-windows selection:  \n\n');

fprintf(fileID, 'Sampling frequency (Hz)      : %g\n', fs);
fprintf(fileID, 'Initial time (s)             : %g\n', ti);
fprintf(fileID, 'Final time (s)               : %g\n', tf);
fprintf(fileID, 'Time window (s)              : %g\n', w);
fprintf(fileID, 'Amplitude threshold (nSTD)   : %.2f\n\n\n', lim);

fprintf(fileID, 'Parameters for analysis in frequency domain: \n\n');

fprintf(fileID, 'Start frequency (Hz)         : %.2f\n', start_frequency);
fprintf(fileID, 'End frequency (Hz)           : %.2f\n', end_frequency);
fprintf(fileID, 'Start velocity (m/s)         : %.2f\n', lb);
fprintf(fileID, 'End velocity (m/s)           : %.2f\n\n', ub);

fprintf(fileID, 'Frequency window (Hz)        : %.2f\n', win);
fprintf(fileID, 'Frequency step (Hz)          : %.2f\n', fstep1);
fprintf(fileID, 'k_1                          : %.2f\n', k1);
fprintf(fileID, 'k_2                          : %.2f\n\n\n', k2);

fprintf(fileID, 'Parameters for analysis in time domain: \n\n');

fprintf(fileID, 'Initial filter sigma (Hz)    : %.2f\n', sdi);
fprintf(fileID, 'Final filter sigma (Hz)      : %.2f\n', sdf);
fprintf(fileID, 'Frequency-step (Hz)          : %.2f\n\n', fstep2);

fclose(fileID);




cd ..\

cd ..\ 


end

