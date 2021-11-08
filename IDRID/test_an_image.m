%Final Model that implements the task

load('model_red.mat','svm_red');
load('model_bright.mat','svm_bright');
load('model_fused.mat','svm_fused');

[fn, path] = uigetfile('*.jpg');

I_test = imread(fullfile(path, fn));

[Fused_Feats, red_Feats, bright_Feats] = DR_feats_fcn(I_test);

image_class_red = predict(svm_red, red_Feats');
image_class_bright = predict(svm_bright, bright_Feats');
image_class_fused = predict(svm_fused, Fused_Feats');

image_class_red = sprintf('%s', image_class_red);
image_class_bright = sprintf('%s', image_class_bright);
image_class_fused = sprintf('%s', image_class_fused);

fprintf('The severity of the disease predicted by Red Lesion Analysis is %s\n', image_class_red(end))
fprintf('The severity of the disease predicted by Bright Lesion Analysis is %s\n', image_class_bright(end))
fprintf('The severity of the disease predicted by Fusion Algorithm is %s\n', image_class_fused(end))
