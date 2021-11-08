function [Fused_Feats, red_Feats, bright_Feats] = DR_feats_fcn(I)


% Preprocessing step
Iycr = rgb2ycbcr(I);
Iy = Iycr(:, :, 1);
Iypre = medfilt2(imadjust(adapthisteq(Iy)), [7 7]);
Irec1 = Iycr; Irec1(:, :, 1) = Iypre;
Ipre = im2double(ycbcr2rgb(Irec1)) .* double(rescale(rgb2gray(I)) > 0.2);


% Detection of red lesions
% close all
% figure, imshowpair(I, Ipre, 'montage'), impixelinfo
% I_red_pre = adapthisteq(I);
I_red = imbinarize(Ipre, 'adaptive', 'ForegroundPolarity','dark','Sensitivity',0.15);
I_red = ~(sum(I_red, 3) >= 2);

% I_red2 = imclose(I_red, strel('disk', 4));
I_red2 = imclearborder(imclose(I_red, strel('disk', 4)));
I_red3 = bwareafilt(imclose(I_red2, strel('disk', 10)), [200, inf]);
% figure, imshowpair(I_red2, I_red3, 'montage')
%

I_red_props = regionprops(I_red3, 'All');
Extents = [I_red_props.Extent];
Aspect = [I_red_props.MinorAxisLength] ./ [I_red_props.MajorAxisLength];

I_red5 = zeros(size(I_red3));
for i = 1:length(I_red_props)
    if Extents(i) > 0.15 && Aspect(i) > 0.15
        I_red5 = or(I_red5, ismember(bwlabel(I_red3), i));
    end
end

% figure, imshowpair(I_red3, I_red5, 'montage')
% figure, imshowpair(I_red5, I)
% % figure, imshowpair(I_red5, I, 'montage')
% for i = 1:length(I_red_props)
%    text(Centroids(i, 1), Centroids(i, 2), num2str(Extents(i)))
% end

% Red lesions features
%%
red2_props = regionprops(I_red5, 'All');
num_red = length(red2_props);
meanArea = mean([red2_props.Area]);
maxArea = max([red2_props.Area]);
meanPerimeter = mean([red2_props.Perimeter]);
meanSolidity = mean([red2_props.Solidity]);

red_Feats = [num_red, meanArea, maxArea, meanPerimeter, meanSolidity]';

%% Detection of bright lesions 
I_bright = imbinarize(Ipre, 'adaptive', 'ForegroundPolarity','dark','Sensitivity',0.85);
I_bright = sum(I_bright, 3) >= 2;
% figure, imshow(double(I_bright), []), impixelinfo
I_bright2 = and(I_bright, (rescale(rgb2gray(Ipre) > 0.85)));
I_bright2 = bwareafilt(imclearborder(imclose(I_bright2, strel('disk', 20))), [200, inf]);
% figure, imshowpair(I_bright, I_bright2, 'montage')
% figure, imshowpair(I, I_bright2), impixelinfo
% figure, imshow(rescale(rgb2gray(Ipre))), impixelinfo
%%
%
bright_props = regionprops(I_bright2, 'All');
num_red = length(bright_props);
meanArea = mean([bright_props.Area]);
maxArea = max([bright_props.Area]);
meanPerimeter = mean([bright_props.Perimeter]);
meanSolidity = mean([bright_props.Solidity]);

bright_Feats = [num_red, meanArea, maxArea, meanPerimeter, meanSolidity]';

%% Fusion
Fused_Feats = [red_Feats; bright_Feats];

end