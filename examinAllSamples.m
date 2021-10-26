function [alphas_new,success,w_new,b_new,errors_new] = examinAllSamples(i1,alphas,x,y,C,w,b,errors,tol)
%examineAllNonBound: third heuristic to choose the second multiplier by 
%iterating over all the examples.
% Inputs: 
    % i1 :           The index of the first multiplier
    % alphas:        The vector of alphas
    % x:             The features matrix (d x N)
    % y:             The target values vector (N x 1)
    % C:             The C paramter in SVM
    % w:             The svm equation weights (d x 1)
    % b:             The svm equation threshold
    % errors:        A vector saves the errors from the fitting data
    % tol:           A hyperparameter for tolerance in violating the KKT
    % conditions
    
% Outputs: 
    %alphas_new:     The new values for alphas
    %success:        Flag variable indicates whether the step is done or not
    % w_new:         The svm equation weights (Updated)
    % b_new:         The svm equation threshold (Updated) 
    % errors_new:    A vector saves the errors from the fitting data (Updated)
    
%start at random location
randomIndex = randi(length(y));
for i = randomIndex:length(y)
    if i ~= i1
        %try to get the joint optimization
        [alphas_new,success,w_new,b_new,errors_new] = take_step_smo(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
randomIndex = randi(length(y));
for i = 1:randomIndex-1
    if i ~= i1
        %try to get the joint optimization
        [alphas_new,success,w_new,b_new,errors_new] = take_step_smo(i1,i,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
alphas_new= 0;success= 0;w_new= 0;b_new = 0;errors_new =0;
end