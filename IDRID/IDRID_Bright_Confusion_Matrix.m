%% Classification section

t = templateSVM('kernelFunction','gaussian', 'Standardize', 1);
Predictions = predict(svm_bright, Bright_Feats_test');

Tarb = zeros(1, length( imdst.Labels));
SVM_Outb = zeros(1, length(Predictions));

for i = 1:length(Tarb)
    sTarb = sprintf('%s', imdst.Labels(i));
    Tarb(i) = str2double(sTarb(end));
    
    sSVM_Outb = sprintf('%s', Predictions(i));
    SVM_Outb(i) = str2double(sSVM_Outb(end));
end


True_Tar = Tarb >= 1;
True_Out = SVM_Outb >= 1;

TP = sum(True_Tar == 1 & True_Out == 1);
FP = sum(True_Tar == 1 & True_Out == 0);
TN = sum(True_Tar == 0 & True_Out == 0);
FN = sum(True_Tar == 0 & True_Out == 1);

% The confusion matrix allows you to see the exact outputs and where they
% are being classed, for each severity separately. 
figure
plotconfusion(imdst.Labels, Predictions)
title('Confusion matrix for Bright lesions')


Sensitivity_bright = TP / (TP + FP)
Specificity_bright = TN / (TN + FN)
Recall_bright = TP/(TP+FN)
Precision_bright = TP/(TP+FP)
F1Score_bright = 2*(Recall_bright * Precision_bright) / (Recall_bright + Precision_bright)