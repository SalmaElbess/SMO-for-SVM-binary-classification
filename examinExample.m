function [alphas_new,success,w_new,b_new,errors_new] = examinExample(i1,alphas,x,y,C,w,b,errors,tol)
clf = @(t) w'*t - b;
y1 = y(i1);
alpha1 = alphas(i1);
if alpha1> 0 && alpha1< C
    e1 = errors(i1); %%check the error part
else
    e1 = clf(x(:,i1))- y(i1); %still needs to get updated
end
r1 = e1*y1;
if (r1 < - tol && alpha1<C) || (r1 > tol && alpha1 > 0)
    %%choosing the second alpha
    [alphas_new,success,w_new,b_new,errors_new] = maxE1E2(e1,i1,alphas,x,y,C,w,b,errors,tol);
    if success
        return;
    end
    [alphas_new,success,w_new,b_new,errors_new] = examineAllNonBound(i1,alphas,x,y,C,w,b,errors,tol);
    if success
        return;
    end
    [alphas_new,success,w_new,b_new,errors_new] = examinAllSamples(i1,alphas,x,y,C,w,b,errors,tol);
    if success
        return;
    end
end
alphas_new= 0;success= 0;w_new= 0;b_new = 0;errors_new =0;
end