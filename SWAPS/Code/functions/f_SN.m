
function [mPx,mPy,mrPxy] = f_SN(Px,Py,rPxy)
%%
for k = 1:size(Px,2)
    
    mu_Px = mean(log(Px(:,k)));
    mu_Py = mean(log(Py(:,k)));
    st_Px = std(log(Px(:,k)));
    st_Py = std(log(Py(:,k)));

    i = 0;
    for j = 1:size(Px,1)

       if log(Px(j,k)) < mu_Px + st_Px && log(Px(j,k)) > mu_Px - st_Px && ...
          log(Py(j,k)) < mu_Py + st_Py && log(Py(j,k)) > mu_Py - st_Py 

            i = i+1;

            Pxx(i) = Px(j,k); Pyy(i) = Py(j,k); rPxxyy(i) = rPxy(j,k);

       end
    
    end

    mPx(1,k) = mean(Pxx);
    mPy(1,k) = mean(Pyy);
    mrPxy(1,k) = mean(rPxxyy);

    clear Pxx Pyy rPxxyy


end
%%
end
