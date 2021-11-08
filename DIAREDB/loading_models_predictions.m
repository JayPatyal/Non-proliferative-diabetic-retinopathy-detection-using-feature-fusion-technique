save('model_fused.mat','svm_fused');
save('model_red.mat','svm_fused');
save('model_bright.mat','svm_fused');
load('model_fused.mat','svm_fused');
load('model_red.mat','svm_red');
load('model_bright.mat','svm_bright');
Accuracy_Fused = (2-resubLoss(svm_fused,'LossFun','hinge'))*100;
Accuracy_Red = (2-resubLoss(svm_red,'LossFun','hinge'))*100;
Accuracy_Bright = (2-resubLoss(svm_bright,'LossFun','hinge'))*100;
x = ['The accuracy of fusion algorithm is :',num2str(Accuracy_Fused)];
y = ['The accuracy of red algorithm is :',num2str(Accuracy_Bright)];
z = ['The accuracy of bright algorithm is :',num2str(Accuracy_Red)];
disp(x);
disp(y);
disp(z);

p = categorical({'Fusion Algorithm', 'Bright Lesion', 'Red Lesion'});
p = reordercats(p,{'Fusion Algorithm', 'Bright Lesion', 'Red Lesion'});
q = [Accuracy_Fused, Accuracy_Red, Accuracy_Bright];
figure
bar(p,q)
title('Comparision of Accuracies of all three Techniques')
figure
plot(p,q)
title('Comparision of Accuracies of all three Techniques')

num_red_ = Fused_Feats(1,:);
img_num = 1:104;
figure
plot(img_num ,num_red_)
title('Training Set Plot of count feature')