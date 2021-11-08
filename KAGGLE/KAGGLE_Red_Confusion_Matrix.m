imdst = imageDatastore('Training_set', 'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

%{
%% Features extraction section test data
load('model_fused.mat','svm_fused');
load('model_red.mat','svm_red');
load('model_bright.mat','svm_bright');
imdst = imageDatastore('Testing_set', 'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

%t = templateSVM('kernelFunction','gaussian', 'Standardize', 1);
%svm_red = fitcecoc(Red_Feats', imdst.Labels, 'learner', t);

Fused_Feats_test = [];
Red_Feats_test = [];
Bright_Feats_test = [];

num_images = imdst.numpartitions;
for i = 1:imdst.numpartitions
    [Fused, red, bright] = DR_feats_fcn(imdst.readimage(i));
    Fused_Feats_test = [Fused_Feats_test, Fused]; %#ok<*AGROW>
    Red_Feats_test = [Red_Feats_test, red];
    Bright_Feats_test = [Bright_Feats_test, bright];
    fprintf('Currently processing image no. %s of %s\n', num2str(i), num2str(num_images))
end
%}
%% Classification section

t = templateSVM('kernelFunction','gaussian', 'Standardize', 1);
Predictions = predict(svm_red, Red_Feats');

Tar = zeros(1, length( imdst.Labels));
SVM_Out = zeros(1, length(Predictions));

for i = 1:length(Tar)
    sTar = sprintf('%s', imdst.Labels(i));
    Tar(i) = str2double(sTar(end));
    
    sSVM_Out = sprintf('%s', Predictions(i));
    SVM_Out(i) = str2double(sSVM_Out(end));
end


True_Tar = Tar >= 1;
True_Out = SVM_Out >= 1;

TP = sum(True_Tar == 1 & True_Out == 1);
FP = sum(True_Tar == 1 & True_Out == 0);
TN = sum(True_Tar == 0 & True_Out == 0);
FN = sum(True_Tar == 0 & True_Out == 1);

% The confusion matrix allows you to see the exact outputs and where they
% are being classed, for each severity separately. 
figure
plotconfusion(imdst.Labels, Predictions)
title('Confusion matrix for Red lesions')


Sensitivity_red = TP / (TP + FP);
Specificity_red = TN / (TN + FN);
Recall_red = TP/(TP+FN);
Precision_red = TP/(TP+FP);
F1Score_red = 2*(Recall_red * Precision_red) / (Recall_red + Precision_red);
