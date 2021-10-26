function [alphas_new,success,w_new,b_new,errors_new] = maxE1E2(e1,i1,alphas,x,y,C,w,b,errors,tol)
%maxE1E2: First heuristic to choose the second multiplier based on
%maximizing the step size in alpha.
% Inputs: 
    % e1 :           The error of the first multiplier
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
tmax = 0;
i2 = -1;
numberOfNonBound = sum(alphas ~= 0 & alphas ~= C);
if numberOfNonBound>1
    for i = 1:length(y)
        alpha2 = alphas(i);
        if alpha2 <C && alpha2 >0
            e2 = errors(i); 
            if abs(e2-e1) > tmax
                tmax = abs(e2-e1);
                i2 = i;
            end
        end
    end
    if (i2 >=0)
        %try to get the joint optimization                
        [alphas_new,success,w_new,b_new,errors_new] = take_step_smo(i1,i2,alphas,x,y,C,w,b,errors,tol);
        if success
            return;
        end
    end
end
alphas_new= 0;success= 0;w_new= 0;b_new = 0;errors_new =0;
end