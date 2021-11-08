%% Classification section

t = templateSVM('kernelFunction','gaussian', 'Standardize', 1);
Predictions = predict(svm_fused, Fused_Feats');

Tarf = zeros(1, length( imdst.Labels));
SVM_Outf = zeros(1, length(Predictions));

for i = 1:length(Tarf)
    sTarf = sprintf('%s', imdst.Labels(i));
    Tarf(i) = str2double(sTarf(end));
    
    sSVM_Outf = sprintf('%s', Predictions(i));
    SVM_Outf(i) = str2double(sSVM_Outf(end));
end


True_Tar = Tarf >= 1;
True_Out = SVM_Outf >= 1;

TP = sum(True_Tar == 1 & True_Out == 1);
FP = sum(True_Tar == 1 & True_Out == 0);
TN = sum(True_Tar == 0 & True_Out == 0);
FN = sum(True_Tar == 0 & True_Out == 1);

% The confusion matrix allows you to see the exact outputs and where they
% are being classed, for each severity separately. 
figure
plotconfusion(imdst.Labels, Predictions)
title('Confusion matrix for Fusion Algorithm')


Sensitivity_Fused = TP / (TP + FP);
Specificity_Fused = TN / (TN + FN);
Recall_Fused = TP/(TP+FN);
Precision_Fused = TP/(TP+FP);
F1Score_Fused = 2*(Recall_Fused * Precision_Fused) / (Recall_Fused + Precision_Fused);
