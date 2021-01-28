function [x,y] = generate_artificial_dataII(N,d,ratio1)
%generate_artificial_dataII: To generate artifical dataset with binary
%target values.

%Inputs:  
        %N:       The number of data points needed
        %d:       The number of features in each data example
        %ration1: The number ratio of ones at each example
%Outputs:
        %x:       The data examples
        %y:       The target values

%Generate weight vector
w = randi([0 1],[d 1]);
w(w==0) = -1;

%Generate random 0,1
x = [];
y = [];
for i= 1:N
N_ones = ratio1*d;
x_example = zeros(d,1);
i_rows = randperm(d,N_ones);
x_example(i_rows,1) = 1;

prod = w'*x_example;
if prod>1
    y = [y 1];
    x = [x x_example];
elseif prod<-1
    y = [y -1];
    x = [x x_example];
end
end

end


