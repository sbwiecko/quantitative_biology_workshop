load('SVM_prediction.mat');
load('MEG_decoding_data_final.mat');
        
% Train your SVMStruct classifier, then use it with fitcsvm here.
SVMStruct =  fitcsvm(train_data,train_cat_labels,'Standardize','on');

% Display the pred and test_cat_labels here so you can visually compare them. 
% Add an apostrophe to either to properly orient the data.
pred = predict(SVMStruct, test_data)
actual = test_cat_labels'
        
% Calculate the accuracy of the SVM Prediction by replacing the question marks.
A = sum(pred == actual)
accuracy = A/length(pred)