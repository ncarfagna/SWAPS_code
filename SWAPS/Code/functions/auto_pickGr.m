function [ffilt,c] = auto_pickGr(ENVEL,ffilt,v)


i = 0;
picking = struct();
for k = 1:size(ENVEL,2)
[pks,loc,wd,prom] = findpeaks(ENVEL(:,k),'Annotate','extents');
if isempty(pks) == 0
i=i+1;
picking(i).freq = ffilt(k);
picking(i).V = v(loc);
picking(i).pks = pks;
picking(i).wd = wd;
picking(i).prom = prom;
end
end
clear i k loc pks prom wd




for i = 1:length(picking)

    ff(i) = picking(i).freq;
    V = picking(i).V;
    pks = picking(i).pks;

    if length(pks) == 1

        c(i) = V;

    elseif length(pks) > 1 && i == 1

        wd = picking(i).wd;
        prom = picking(i).prom;

        norm_pks = pks/max(ENVEL(:,i));
        norm_wd = wd/length(ENVEL(:,i));
        norm_prom = prom/max(ENVEL(:,i));
        w1 = 0.5; w2 = 0.3; w3 = 0.2;
        score = w1 * norm_pks + w2 * norm_wd + w3 * norm_prom;
        [~,xscore] = max(score);

        c(i) = V(xscore);

    elseif length(pks) > 1 && i > 1

        dc = abs(c(i-1) - V);
        [~,xv] = min(dc);
        c(i) = V(xv);

    end

end


end

