function [alphas_new,success,w_new,b_new,errors_new] = maxE1E2(e1,i1,alphas,x,y,C,w,b,errors,tol)
tmax = 0;
i2 = -1;
numberOfNonBound = sum(alphas ~= 0 & alphas ~= C);
if numberOfNonBound>1
    for i = 1:length(y)
        alpha2 = alphas(i);
        if alpha2 <C && alpha2 >0
            e2 = errors(i); %%check error cache part
            if abs(e2-e1) > tmax
                tmax = abs(e2-e1);
                i2 = i;
            end
        end
    end
    if (i2 >=0)
        [alphas_new,success,w_new,b_new,errors_new] = take_step_sayed(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
alphas_new= 0;success= 0;w_new= 0;b_new = 0;errors_new =0;
end