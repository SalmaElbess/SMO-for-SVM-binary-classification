function  [alphas_new,success,w_new,b_new,errors_new] = examineAllNonBound(i1,alphas,x,y,C,w,b,errors,tol)
%start at random locations
randomIndex = randi(length(y));
for i = randomIndex : length(y)
    alpha2 = alphas(i);
    if alpha2 <C && alpha2 >0 && i~=i1%%25r and de mn 3ndy
        [alphas_new,success,w_new,b_new,errors_new] = take_step_sayed(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
for i = 1 : randomIndex - 1
    alpha2 = alphas(i);
    if alpha2 <C && alpha2 >0 && i~=i1%%25r and de mn 3ndy
        [alphas_new,success,w_new,b_new,errors_new] = take_step_sayed(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
alphas_new= 0;success= 0;w_new= 0;b_new = 0;errors_new =0;
end