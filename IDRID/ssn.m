imds = imageDatastore('Training_set', 'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

Fused_Feats = [];
Red_Feats = [];
Bright_Feats = [];

num_images = imds.numpartitions;
for i = 1:imds.numpartitions
    [Fused, red, bright] = DR_feats_fcn(imds.readimage(i));
    Fused_Feats = [Fused_Feats, Fused]; %#ok<*AGROW>
    Red_Feats = [Red_Feats, red];
    Bright_Feats = [Bright_Feats, bright];
    fprintf('Currently processing image no. %s of %s\n', num2str(i), num2str(num_images))
end

% This in case some error occured after this and after finishing
save UpdatedWork_Checkpoint.mat 
%%

t = templateSVM('kernelFunction','gaussian', 'Standardize', 1);
svm_fused = fitcecoc(Fused_Feats', imds.Labels, 'learner', t);
disp('Fused Feats classification accuracy')
(1 - resubLoss(svm_fused)) * 100

%
svm_red = fitcecoc(Red_Feats', imds.Labels, 'learner', t);
disp('Red Feats only classification error')
(1 - resubLoss(svm_red)) * 100

%
disp('Bright Feats only classification error')
svm_bright = fitcecoc(Bright_Feats', imds.Labels, 'learner', t);
(1 - resubLoss(svm_bright)) * 100
%%
% Change labels ftom Tr_0 to numbers (integers) instead of folder names
Predictions = predict(svm_fused, Fused_Feats');

Tar = zeros(1, length( imds.Labels));
SVM_Out = zeros(1, length(Predictions));

for i = 1:length(Tar)
    sTar = sprintf('%s', imds.Labels(i));
    Tar(i) = str2double(sTar(end));
    
    sSVM_Out = sprintf('%s', Predictions(i));
    SVM_Out(i) = str2double(sSVM_Out(end));
end

% For the calculation of senssitivity and specifity the only allowed
% classes are (0, 1) so that all severiies will be considered as 1 and the
% normal classes will be zeros
%%
True_Tar = Tar >= 1;
True_Out = SVM_Out >= 1;

TP = sum(True_Tar == 1 & True_Out == 1);
FP = sum(True_Tar == 1 & True_Out == 0);
TN = sum(True_Tar == 0 & True_Out == 0);
FN = sum(True_Tar == 0 & True_Out == 1);

Sensitivity = TP / (TP + FP)
Specificity = TN / (TN + FN)
Accuracy = (TP + TN) / (TP + TN + FP + FN)
Recall = TP/(TP+FN)
Precision = TP/(TP+FP)
F1Score = 2*(Recall * Precision) / (Recall + Precision)
% The confusion matrix allows you to see the exact outputs and where they
% are being classed, for each severity separately. 
plotconfusion(imds.Labels, Predictions)
%%
save UpdatedWork.mat 
