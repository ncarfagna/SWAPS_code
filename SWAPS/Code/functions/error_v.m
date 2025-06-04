
function [xm,xp] = error_v(v,col,loc,mode)


% qua prendo come limiti quando scendo oltre una certa soglia rispetto al
% valore di picco

if mode == "auto"

xp = ones(size(loc))*(-1);
xm = ones(size(loc))*(-1);

for ii = 1:length(loc)

for k = loc(ii)+1:length(col)-1
    if col(k)<(col(loc(ii))*0.90) % || col(k)<col(k+1) && col(k)<col(k-1)
        xm(ii) = v(k);
        break
    end
end


for j = loc(ii)-1:-1:2
    if col(j)<(col(loc(ii))*0.90) % || col(j)<col(j+1) && col(j)<col(j-1)
        xp(ii) = v(j);
        break
    end
end


if xm(ii) == -1
    xm(ii) = v(end);
end

if xp(ii) == -1
    xp(ii) = v(1);
end

end


elseif mode == "manual"

xp = -1;
xm = -1;



for k = loc+1:length(col)-1
    if col(k)<(col(loc)*0.90) % || col(k)<col(k+1) && col(k)<col(k-1)
        xm = v(k);
        break
    end
end


for j = loc-1:-1:2
    if col(j)<(col(loc)*0.90) % || col(j)<col(j+1) && col(j)<col(j-1)
        xp = v(j);
        break
    end
end


if xm == -1
    xm = v(end);
end

if xp == -1
    xp = v(1);
end





end


end