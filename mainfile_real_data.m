%% reading csv file
%use https://www.mathworks.com/help/matlab/ref/readmatrix.html
%or https://www.mathworks.com/help/matlab/ref/readtable.html
%----------------------------------------------------------------
%y = [1 -1 1 1]; %target
%x = [1 2 3 4; %features
%    5 6 7 8];
%initialize
clc; clear;
%% get data
data = readmatrix('bill_authentication.csv');
range = (400:800);
x = data(range,1:end-1)';
y = data(range,end)';
[d ,N] = size(x);
N_test = floor(N/10);
y = y';
x_test = x(:,N-N_test+1:end); y_test = y(N-N_test+1:end,1);
x = x(:,1:N-N_test);         y = y(1:N-N_test,1);
[d ,N] = size(x);
alphas = zeros(size(y));
b = 0;
examineAll = 1;
numChanged = 0;
C = 1;
tol = 0.001; %based on Platt 1998
errors = y.*(-1); %assuming that all u vector initially = 0
w = zeros(d,1);
clf_function = @(t) w'*t - b;

while(examineAll || numChanged > 0)
    numChanged = 0;
    if (examineAll)
        for i = 1:length(y)
            [alphas_new,success,w_new,b_new,errors_new] = examinExample(i,alphas,x,y,C,w,b,errors,tol);
            if success
                numChanged = numChanged + 1;%examinExample(i,y,alphas,errors,tol,c);
                alphas = alphas_new; w = w_new; b = b_new; errors = errors_new;
            end
        end
    else
        for i = 1:length(y)
            if alphas(i) ~= 0 && alphas(i) ~= C
                [alphas_new,success,w_new,b_new,errors_new] = examinExample(i,alphas,x,y,C,w,b,errors,tol);
                if success
                    numChanged = numChanged + 1;%examinExample(i,y,alphas,errors,tol,c);
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
[y_predicted, error] = predict_smo(w,b,x_test,y_test);
100*(1- error/length(y_predicted))
[y_predicted, error] = predict_smo(w,b,x,y);
100*(1- error/length(y_predicted))