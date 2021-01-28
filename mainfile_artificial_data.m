%% SMO for SVM with artificailly generated data 
clc; clear;
%% get data
N = 1210; 
[x,y]=generate_artificial_dataII(N,300,0.1);
y = y'; 
y(y==0) = -1;

[d ,N] = size(x);
alphas = zeros(size(y));
b = 0;
examineAll = 1;
numChanged = 0;
C = 100;
tol = 0.001; 
errors = y.*(-1); 
w = zeros(d,1);
clf_function = @(t) w'*t - b;
tic
while(examineAll || numChanged > 0)
    numChanged = 0;
    if (examineAll)
        for i = 1:length(y)
            [alphas_new,success,w_new,b_new,errors_new] = examinExample(i,alphas,x,y,C,w,b,errors,tol);
            if success
                numChanged = numChanged + 1;
                alphas = alphas_new; w = w_new; b = b_new; errors = errors_new;
            end
        end
    else
        for i = 1:length(y)
            if alphas(i) ~= 0 && alphas(i) ~= C
                [alphas_new,success,w_new,b_new,errors_new] = examinExample(i,alphas,x,y,C,w,b,errors,tol);
                if success
                    numChanged = numChanged + 1;
                    alphas = alphas_new; w = w_new; b = b_new; errors = errors_new;            
                end
            end
        end
    end
        if (examineAll)
            examineAll = 0;
        elseif numChanged == 0
            examineAll = 1;
        end
end
toc

[y_predicted, error] = predict_smo(w,b,x,y);
training_accuracy = 100*(1- error/length(y_predicted))
