clear, clc
addpath('B. Disease Grading\2.Groundtruths')
addpath('B. Disease Grading\1.Original Images')

imgsDir = 'B. Disease Grading\1.Original Images';

[~, ~, Trn_Data] = xlsread('Training_images_Labels.xlsx');
[~, ~, Tst_Data] = xlsread('Testing_images_Labels.xlsx');

mkdir Tr_1
mkdir Tr_2
mkdir Tr_5
mkdir Tr_4

for i = 2:length(Trn_Data)
    copyfile(fullfile(imgsDir, 'b. Training Set', strcat(Trn_Data{i, 1}, '.png')), strcat('Tr_', num2str(Trn_Data{i, 2})))
end

%%

mkdir Ts_1
mkdir Ts_2
mkdir Ts_5
mkdir Ts_4

for i = 2:length(Tst_Data)
    
    disp(fullfile(imgsDir, 'a. Testing Set', strcat(Tst_Data{i, 1}, '.png')))
    disp(strcat('Ts_', num2str(Tst_Data{i, 2})))
    copyfile(fullfile(imgsDir, 'a. Testing Set', strcat(Tst_Data{i, 1}, '.png')), strcat('Ts_', num2str(Tst_Data{i, 2})))
end

