%% get data
clc; clear;
data = readmatrix('bill_authentication.csv');
data = data(randperm(size(data, 1)), :);
range = (1:500);
x = data(range,1:end-1)';
y = data(range,end)';
y(y==0) = -1;
[d ,N] = size(x);
N_test = floor(N/10);
y = y';
x_test = x(:,N-N_test+1:end); y_test = y(N-N_test+1:end,1);
x = x(:,1:N-N_test);         y = y(1:N-N_test,1);
[d ,N] = size(x);
%Initializations
alphas = zeros(size(y));
b = 0;
tol = 0.001; %based on Platt 1998
%% train and test our implemetnation 
examineAll = 1;
numChanged = 0;
errors = y.*(-1); %assuming that all u vector initially = 0
C = 100;
w = zeros(d,1);
w_old = w;
clf_function = @(t) w'*t - b;
imp_start = now;
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
%      abs(abs(w_old)-abs(w));
         if(success)
             if(abs(abs(w_old)-abs(w)) < 0.003*ones(size(w)))
                 break;
             end
         end
          w_old = w;
        if (examineAll)
            examineAll = 0;
        elseif numChanged == 0
            examineAll = 1;
        end
end
imp_end= now;
% training and test accurecy 
[y_predicted, error] = predict_smo(w,b,x_test,y_test);
our_test_acc = 100*(1- error/length(y_predicted));
[y_predicted, error] = predict_smo(w,b,x,y);
out_train_acc = 100*(1- error/length(y_predicted));
%calculate time in seconds
implemented_time = (imp_end - imp_start)*86400;
%% test Matlab built-in function
ready_start = now;
SVMModel = fitcsvm(x',y,'KKTTolerance',tol,'Solver','SMO','Alpha',zeros(size(y)),'BoxConstraint',C,'ClipAlphas',true);%,'OptimizeHyperparameters','auto')
ready_end = now;
%calculate time in seconds
ready_time = (ready_end - ready_start)*86400;
%test accurecy 
label = predict(SVMModel,x_test');
matlab_test_acc = 100*(1- (sum(label ~= y_test)/length(y_test)));
%getting some parameters for comparison
Matlab_weights  = SVMModel.Beta;
Matlab_bias = SVMModel.Bias;
our_weights = w;
our_bias = b;
 
