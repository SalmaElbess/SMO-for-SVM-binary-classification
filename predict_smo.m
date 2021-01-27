function [y_p,error] = predict_smo(w,b,x_test,y_test)

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