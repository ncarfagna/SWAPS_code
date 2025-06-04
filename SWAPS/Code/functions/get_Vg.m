function [f_interp,vg_snt] = get_Vg(f,v)

fmod = fit(f,v, 'smoothingspline', 'SmoothingParam', 0.25);
f_interp = linspace(min(f), max(f), size(f,1)*2)';
Vf_interp = feval(fmod, f_interp);
wvno = (2 * pi * f_interp) ./ Vf_interp;

dcdk = gradient(Vf_interp,wvno);



vg_snt = Vf_interp + wvno .* dcdk;



end

