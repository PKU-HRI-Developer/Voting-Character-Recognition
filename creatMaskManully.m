close all;
% InputDir = 'test_img';
[fileName,pathName] = uigetfile({'*.jpg;*.png;*.bmp;*.jpeg;*.pgm;*.tif'},'Choose a image file'); 
img = imread(fullfile(pathName,fileName));
figure;
h_im = imshow(img);

% Draw poly as mask
h = impoly;
position = wait(h); 

% Transform mask to Binary mask
mask = createMask(h,h_im);
figure;
imshow(mask);
imwrite(mask, fullfile(pathName,['Mask',fileName]))
