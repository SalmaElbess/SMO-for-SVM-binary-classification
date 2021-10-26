function [eta,K11,K12,K22] = compute_eta_smo(x1,x2)
%COMPUTE_ETA:compute the second derivative using 2 alphas
% Inputs: 
    % x1,x2:         2 features vectors.
% Outputs: 
    %eta:            The 2nd derivative
    %K11,K12,K22
    
    
 %check 
 if size(x1,1) ~= 1
     x1 = x1'; x2= x2';
 end
 
K11 = x1*x1'; 
K22 = x2*x2';
K12 = x1*x2';

eta = 2*K12 - K11 - K22;
 
end