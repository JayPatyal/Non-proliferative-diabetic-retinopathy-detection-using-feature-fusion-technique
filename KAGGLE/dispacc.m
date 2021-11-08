
load('model_red.mat','svm_red');
load('model_bright.mat','svm_bright');
load('model_fused.mat','svm_fused');

Accuracy_Fused = (2-resubLoss(svm_fused,'LossFun','hinge'))*100;
Accuracy_Red = (2-resubLoss(svm_red,'LossFun','hinge'))*100;
Accuracy_Bright = (2-resubLoss(svm_bright,'LossFun','hinge'))*100;
x = ['The accuracy of fusion algorithm is :',num2str(Accuracy_Fused)];
y = ['The accuracy of bright algorithm is :',num2str(Accuracy_Bright)];
z = ['The accuracy of red algorithm is :',num2str(Accuracy_Red)];

disp(x)
disp(y)
disp(z)