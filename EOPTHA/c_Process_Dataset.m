clear, clc
addpath('B. Disease Grading\2.Groundtruths')
addpath('B. Disease Grading\1. Original Images')

imgsDir = 'B. Disease Grading\1. Original Images';

[~, ~, Trn_Data] = xlsread('Training_image_Labels.xlsx');
[~, ~, Tst_Data] = xlsread('Testing_image_Labels.xlsx');

mkdir Tr_0
mkdir Tr_1

for i = 2:length(Trn_Data)
    copyfile(fullfile(imgsDir, 'a. Training Set', strcat(Trn_Data{i, 1}, '.jpg')), strcat('Tr_', num2str(Trn_Data{i, 2})))
end

%%

mkdir Ts_0
mkdir Ts_1

for i = 2:length(Tst_Data)
    
    disp(fullfile(imgsDir, 'b. Testing Set', strcat(Tst_Data{i, 1}, '.jpg')))
    disp(strcat('Ts_', num2str(Tst_Data{i, 2})))
    copyfile(fullfile(imgsDir, 'b. Testing Set', strcat(Tst_Data{i, 1}, '.jpg')), strcat('Ts_', num2str(Tst_Data{i, 2})))
end

