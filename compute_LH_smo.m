function [L,H] = compute_LH_smo(alpha1,alpha2,y1,y2,C)
%COMPUTE_LH: compute the alphas range (L <= alpha <= H)
% Inputs: 
    % alpha1,alpha2: The 2 chosen alphas
    % y1,y2:         The target values for the alphas being optimized
    % C:             The C parameter in SVM

% Outputs: 
    %L,H:            The boundaries for the chosen alpha
 
if y1==y2
   gamma = alpha1 + alpha2; 
   L = max(0,gamma-C);
   H = min(C,gamma);
else
   gamma = alpha2 - alpha1;
   L = max(0,gamma);
   H = min(C,C+gamma);
end
    
 

end