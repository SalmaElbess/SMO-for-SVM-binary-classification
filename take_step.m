%% TakeStep function is SMO Algorithm

function [alphas,success,w,b,error_cashe] = take_step(index1,index2,alphas,x,y,C,w,b,error_cashe)
%TAKE_STEP: Execute the updating procedures for the 2 chosen alphas in SMO
%algorithm
% Inputs: 
    % index1,index2: The indecies of the 2 chosen alphas
    % alphas:        The vector of alphas
    % x:             The features matrix
    % y:             The target values vector
    % C:             The C paramter in SVM
    % w:             The svm equation weights
    % b:             The svm equation threshold
% Outputs: 
    %alpha1,alpha2: The new values for alphas
    %success:       Flag variable indicates whether the step is done or not
    % w:            The svm equation weights (Updated)
    % b:            The svm equation threshold (Updated) 

% The SVM objective function handler
  clf_function = @(t) w'*t - b;

alpha1 = alphas(index1);   alpha2 = alphas(index2); 
%save the old_values for ever
old_alpha1 = alpha1; old_alpha2 = alpha2;

success = 0;
%error_cashe = w'*x-b-y;

if index1 == index2
   disp('The same index is passed twice'); 
   return; 
end
% Get the values
x1 = x(:,index1); x2 = x(:,index2); y1=y(1,index1); y2=y(1,index2); 
s = y1*y2;
% Compute the errors
E1 = clf_function(x1) - y1;
E2 = clf_function(x2) - y2;

% Error function handler
  % my_x (d*1)
get_Exy = @(my_x,my_y) sum(alphas.*y*x'*my_x) - b - my_y; %(number)

% Compute delta_threshold
get_delta_b = @(my_x,my_y,delta_alpha1,delta_alpha2) get_Exy(my_x,my_y)+delta_alpha1.*y1.*(x1')*my_x + delta_alpha2.*y2.*(x2')*my_x;


% Compute L,H
[L,H] = compute_LH(alpha1,alpha2,y1,y2,C);
if L == H
   return; 
end

% Compute eta
eta = compute_eta(x1,x2);
if eta < 0
   new_alpha2 = alpha2 + y2*(E2-E1)/eta;
   if new_alpha2<L
      new_alpha2 = L;
   elseif new_alpha2 > H
       new_alpha2 = H;
   end
else
    %compute the objective function at the 2 ends
   f_at_L = 0.5*eta*L^2 + L*(y2*(E1-E2) - eta*alpha2);
   f_at_H = 0.5*eta*H^2 + H*(y2*(E1-E2) - eta*alpha2);
    
   if f_at_L > f_at_H
      new_alpha2 = L;
   elseif f_at_L < f_at_H
       new_alpha2 = H;
   else
       new_alpha2 = alpha2; %keep the old value
   end
end
 
alpha1 = alpha1 - s*(new_alpha2 - alpha2);
if (alpha1 < 0)
   new_alpha2 = new_alpha2 + s*alpha1; %to let the linear constraint valid
   alpha1 = 0;
elseif alpha1>C
    new_alpha2 = new_alpha2 + s*(alpha1-C); 
    alpha1 = C;
end
    %finally value of alpha2 is set
    alpha2 = new_alpha2;
    success = 1;
    alphas(1,index1) = alpha1; 
    alphas(1,index2) = alpha2;
    
   %Compute delta alphas
   delta_alpha1 = alpha1-old_alpha1;
   delta_alpha2 = alpha2-old_alpha2;

  %Update the weights
  delta_w = delta_alpha1*y1*x1 + delta_alpha2*y2*x2;
  w = w + delta_w;

  %Update Error cashe
  for i=1:length(y)
      error_cashe(i) = get_Exy(x(i),y(i));
  end
   my_index = index1; %sayed
  if (alpha1 >0 && alpha1 < C)
      error_cashe(index1) = 0;
      my_index = index1;
  end
  if (alpha2 >0 && alpha2 < C)
      error_cashe(index2) = 0;
      my_index = index2;
  end
  
  %Update thresholds
  delta_b = get_delta_b(x(:,my_index),y(1,my_index),delta_alpha1,delta_alpha2);
  b = b + delta_b;
  
end %end_function

 