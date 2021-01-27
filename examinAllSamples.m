function [alphas_new,success,w_new,b_new,errors_new] = examinAllSamples(i1,alphas,x,y,C,w,b,errors,tol)
randomIndex = randi(length(y));
for i = randomIndex:length(y)
    if i ~= i1
        [alphas_new,success,w_new,b_new,errors_new] = take_step_sayed(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
randomIndex = randi(length(y));
for i = 1:randomIndex-1
    if i ~= i1
        [alphas_new,success,w_new,b_new,errors_new] = take_step_sayed(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
alphas_new= 0;success= 0;w_new= 0;b_new = 0;errors_new =0;
end