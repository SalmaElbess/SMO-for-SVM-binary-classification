function [y_p,error] = predict_smo(w,b,x_test,y_test)
%PERDICT_SMO: This function uses the SVM hyperplane weight with the test
%data to generate the output by SVM equation and calucaltes the output
%missclassified output depending on the output target values.

% Inputs: 
    % w:             The svm equation weights (d x 1)
    % b:             The svm equation threshold
    % x:             The features matrix (d x N)   
    % x_test:        The test data   
    % y_test:        The output target data  
% Outputs: 
    % y_p:           The predicted classes
    % error:         The number of missclassified examples.

    
% dimensions:
 % x ( d x N )
 % y ( N x 1 )
 % w ( d x 1 )
 
[~,N] = size(x_test);

y_p = zeros(N,1);
for i=1:N
ex = x_test(:,i);  %( d x 1 )
prod =  w'*ex - b;
if prod >0 
    y_p(i,1) = 1;
else
    y_p(i,1) = -1;
end
end
error = sum(y_p~= y_test);
end