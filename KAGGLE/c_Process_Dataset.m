clear, clc
addpath('B. Disease Grading\2.Groundtruths')
addpath('B. Disease Grading\1. Original Images')

imgsDir = 'B. Disease Grading\1. Original Images';

[~, ~, Trn_Data] = xlsread('Training_image_Labels.csv');
[~, ~, Tst_Data] = xlsread('Testing_image_Labels.csv');

mkdir Tr_0
mkdir Tr_1
mkdir Tr_2
mkdir Tr_3
mkdir Tr_4

for i = 2:length(Trn_Data)
    if(~(isstring(Trn_Data{i, 1})))
       q = num2str(Trn_Data{i, 1});
       copyfile(fullfile(imgsDir, 'a. Training Set', strcat(q, '.png')), strcat('Tr_', num2str(Trn_Data{i, 2})))
    else
       copyfile(fullfile(imgsDir, 'a. Training Set', strcat(Trn_Data{i, 1}, '.png')), strcat('Tr_', num2str(Trn_Data{i, 2})))
    end
end

%%

mkdir Ts_0
mkdir Ts_1
mkdir Ts_2
mkdir Ts_3
mkdir Ts_4

for i = 2:length(Tst_Data)
    %{
    if(~(isstring(Trn_Data{i, 1})))
       q = num2str(Trn_Data{i, 1});
       disp(fullfile(imgsDir, 'b. Testing Set', strcat(q, '.png')))
       disp(strcat('Ts_', num2str(Tst_Data{i, 2})))
       copyfile(fullfile(imgsDir, 'b. Testing Set', strcat(q, '.png')), strcat('Ts_', num2str(Tst_Data{i, 2})))
    else
       disp(fullfile(imgsDir, 'b. Testing Set', strcat(Tst_Data{i, 1}, '.png')))
       disp(strcat('Ts_', num2str(Tst_Data{i, 2})))
       copyfile(fullfile(imgsDir, 'b. Testing Set', strcat(Tst_Data{i, 1}, '.png')), strcat('Ts_', num2str(Tst_Data{i, 2})))
    end
    %}
    disp(fullfile(imgsDir, 'b. Testing Set', strcat(Tst_Data{i, 1}, '.png')))
    disp(strcat('Ts_', num2str(Tst_Data{i, 2})))
    copyfile(fullfile(imgsDir, 'b. Testing Set', strcat(Tst_Data{i, 1}, '.png')), strcat('Ts_', num2str(Tst_Data{i, 2})))
end

