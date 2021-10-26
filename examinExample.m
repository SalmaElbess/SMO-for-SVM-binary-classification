function [alphas_new,success,w_new,b_new,errors_new] = examinExample(i1,alphas,x,y,C,w,b,errors,tol)
%examineExample: Checks if the passed multiplier violates the KKT conditions. If
% it violates it calles the heurirstics of choosing the second multiplier
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
clf = @(w,t) w'*t - b;
y1 = y(i1);
alpha1 = alphas(i1);
e1 = errors(i1);
r1 = e1*y1;
if (r1 < - tol && alpha1<C) || (r1 > tol && alpha1 > 0) %checking the KKT conditions 
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