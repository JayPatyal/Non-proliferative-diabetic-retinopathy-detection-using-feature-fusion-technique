imshow(I_red5)
close all;
mask = strel('disk',27);
red_close = imclose(I_red5,mask);
figure,imshow(red_close);
red_open = imopen(red_close,mask);
figure,imshow(red_open);
[L1,num1] = bwlabel(red_open,4);
%disp(L);
disp1 = ['The number of red lessions are:',num2str(num1)];
disp(disp1);
bright_close = imclose(I_bright2,mask);
figure,imshow(bright_close);
bright_open = imopen(bright_close,mask);
figure,imshow(bright_open);
[L2,num2] = bwlabel(bright_open,4);
disp2 = ['The number of bright lessions are:',num2str(num2)];
disp(disp2);