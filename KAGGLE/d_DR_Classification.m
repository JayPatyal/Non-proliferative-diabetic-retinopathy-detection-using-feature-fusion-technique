%% Features extraction section

imds = imageDatastore('Training_set', 'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

Fused_Feats = [];
Red_Feats = [];
Bright_Feats = [];

num_images = imds.numpartitions;
for i = 1:imds.numpartitions
    [Fused, red, bright] = DR_feats_fcn(imds.readimage(i));
    while(length(red)<5)
        red = cat(1,red,[0]);
    end
    while(length(bright)<5)
        bright = cat(1,bright,[0]);
    end
    Fused = cat(1,red,bright);
    Fused_Feats = [Fused_Feats, Fused]; %#ok<*AGROW>
    Red_Feats = [Red_Feats, red];
    Bright_Feats = [Bright_Feats, bright];
    fprintf('Currently processing image no. %s of %s\n', num2str(i), num2str(num_images))
end
%% Classification section

t = templateSVM('kernelFunction','gaussian', 'Standardize', 1);

%Classification based on fused features i.e bith red and bright features 
svm_fused = fitcecoc(Fused_Feats', imds.Labels, 'learner', t);


%Classification based on features of Red Lesions
svm_red = fitcecoc(Red_Feats', imds.Labels, 'learner', t);

%Classification based on features of Bright Lesions
svm_bright = fitcecoc(Bright_Feats', imds.Labels, 'learner', t);

%Accuracy calculations for predistion using Fused Features of both Red Lesions and Bright Lesions
Accuracy_Fused = (2-resubLoss(svm_fused,'LossFun','hinge'))*100;
%Accuracy calculations for predistion using only Red Lesion Features
Accuracy_Red = (2-resubLoss(svm_red,'LossFun','hinge'))*100;
%Accuracy calculations for predistion using only Bright Lesion Features
Accuracy_Bright = (2-resubLoss(svm_bright,'LossFun','hinge'))*100;
x = ['The accuracy of fusion algorithm is :',num2str(Accuracy_Fused)];
y = ['The accuracy of red algorithm is :',num2str(Accuracy_Bright)];
z = ['The accuracy of bright algorithm is :',num2str(Accuracy_Red)];
disp(x);
disp(y);
disp(z);


%Saving The Trained Models
save('model_fused.mat','svm_fused');
save('model_red.mat','svm_red');
save('model_bright.mat','svm_bright');