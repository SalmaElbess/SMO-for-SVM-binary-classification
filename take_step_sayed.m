%% TakeStep function is SMO Algorithm

function [alphas,success,w,b,error_cashe] = take_step_smo(index1,index2,alphas,x,y,C,w,b,error_cashe,eps)
%TAKE_STEP: Execute the updating procedures for the 2 chosen alphas in SMO
%algorithm
% Inputs: 
    % index1,index2: The indecies of the 2 chosen alphas
    % alphas:        The vector of alphas
    % x:             The features matrix (d x N)
    % y:             The target values vector (N x 1)
    % C:             The C paramter in SVM
    % w:             The svm equation weights (d x 1)
    % b:             The svm equation threshold
    % error_cashe:   A vector saves the errors from the fitting data
    % eps:           A hyperparameter for tolerance in slightly changing alphas
    
% Outputs: 
    %alphas:        The new values for alphas
    %success:       Flag variable indicates whether the step is done or not
    % w:            The svm equation weights (Updated)
    % b:            The svm equation threshold (Updated) 
    % error_cashe:   A vector saves the errors from the fitting data (Updated)


% ----- The SVM objective function handler
  clf_function = @(w,t) w'*t - b;

% ---- Get the values
x1 = x(:,index1);   x2 = x(:,index2);  %(d x 1)
y1=y(index1,1);     y2=y(index2,1); 
s = y1*y2;  
alpha1 = alphas(index1,1);   alpha2 = alphas(index2,1); 


success = 0;
if index1 == index2
   %disp('The same index is passed twice'); 
   return; 
end

%---- Compute the errors [The orignial way]
E1 = clf_function(w,x1) - y1;
E2 = clf_function(w,x2) - y2;

% ---------- Compute L,H [The constraints]
[L,H] = compute_LH_smo(alpha1,alpha2,y1,y2,C);
if L == H
   return; 
end

% ---------- Compute eta [The second derivative]
[eta,k11,k12,~] = compute_eta_smo(x1',x2');
if eta < 0
        % Compute the new alpha
       new_alpha2 = alpha2 + y2*(E2-E1)/eta;
        % Clipping
       if new_alpha2<L
          new_alpha2 = L;
       elseif new_alpha2 > H
           new_alpha2 = H;
       end
else
     %compute the objective function at the 2 ends
       f_at_L = 0.5*eta*L^2 + L*(y2*(E1-E2) - eta*alpha2);
       f_at_H = 0.5*eta*H^2 + H*(y2*(E1-E2) - eta*alpha2);

       if f_at_L > (f_at_H + eps) 
          new_alpha2 = L;
       elseif f_at_L < (f_at_H - eps)
           new_alpha2 = H;
       else
           new_alpha2 = alpha2; %keep the old value
       end
end
% --------  Check if the difference is not making difference
 if (abs(new_alpha2-alpha2)< eps)
       return;
 end
                
new_alpha1 = alpha1 - s*(new_alpha2 - alpha2);


% --------- Update threshold 
b1 =  b + E1 + y1*(new_alpha1-alpha1)*k11 + y2*(new_alpha2-alpha2)*k12;
b2 =  b + E2 + y1*(new_alpha1-alpha1)*k11 + y2*(new_alpha2-alpha2)*k12;
delta_b = b; %save the old b
if ((new_alpha1 > 0)&&(new_alpha1 < C))
      b = b1;
elseif ((new_alpha2 > 0)&&(new_alpha2 < C))
      b = b2;
else
      b = 0.5*(b1+b2);
end
delta_b = b - delta_b;

%------ Update Error cashe for the joint multipliers
if (alpha1 >0 && alpha1 < C)
      error_cashe(index1) = 0;
end
if (alpha2 >0 && alpha2 < C)
      error_cashe(index2) = 0;
end


% -------------- Updates ....
success = 1;
alphas(index1) = new_alpha1; 
alphas(index2) = new_alpha2;

alpha_y = alphas.*y; %(size = Nx1)
w = (alpha_y'*x')';

for i=1: size(error_cashe,1) 
 if ((i~=index1)&&(i~=index2))
     x_vec = x(:,i);
     error_cashe(i) = clf_function(w,x_vec)-y(i,1);
 end
end




  
end %end_function

 
