# SMO-for-SVM-binary-classification

Based on the discussed algorithm in SMO algorithm section, MATLAB scripts are
written to implement this algorithm. More hyperparameters are added to compensate for
the difficulty for having exact zero in the KKT conditions for example. The
implementation is generally consists of two main function; ​‘examinExample’​ function to
choose the lagrangian multipliers to optimize ant ​‘take_step_smo’​ function to apply the
joint optimization for the two chosen multipliers and then updates the weight vector w
and the threshold b . The ​‘examinExample’ ​function contains the three different
approaches of choosing the multipliers in three different MATLAB files. For training,
testing and comparing the model, two MATLAB scripts are written to get the data, set the
parameters, fit the model and test. The first script is named ​‘mainfile_artificial_data’​ in
which artificial data is generated and then the model is applied to it. Using the actual
classes values and the predicted ones, the training error is calculated. Similarly, a script
named ​‘mainfile_real_data’​ is used to use a ready real linearly separable dataset in the
classification SVM. The results in this script are compared to the results obtained using
the same dataset by the ready-made MATLAB SVM classifier using the SMO algorithm.
