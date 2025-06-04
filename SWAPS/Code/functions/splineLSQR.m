function [freq,corr] = splineLSQR(freq,corr)

% Definisci il fattore di smoothing per 3 spline
smooth_factor_1 = 0.1;  % Spline più liscia
smooth_factor_2 = 0.2;  % Spline meno liscia
smooth_factor_3 = 0.3;  % Spline che si adatta maggiormente ai dati


% Calcola le 3 spline cubiche di smoothing
pp1 = csaps(freq, corr, smooth_factor_1);  % Prima spline
pp2 = csaps(freq, corr, smooth_factor_2);  % Seconda spline
pp3 = csaps(freq, corr, smooth_factor_3);  

% Valuta le spline nei punti x
y_spline_1 = ppval(pp1, freq);
y_spline_2 = ppval(pp2, freq);
y_spline_3 = ppval(pp3, freq);


% Matrice A per la combinazione lineare delle spline
A = [y_spline_1' y_spline_2' y_spline_3'];


% Risolvere per i coefficienti delle spline
y_col = corr(:);  % Assicurati che y sia una colonna


% coeff = lsqr(A, y_col);  % Risolvere il sistema dei minimi quadrati
coeff = A \ y_col;

% Combinazione lineare delle spline
corr = A * coeff;
corr = corr';
end

