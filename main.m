% Charecter Detection for Voting system
% Author: Liqian Ma
% e-mail: maliqian@sz.pku.edu.cn
close all;
clear;
addpath(genpath('OCR'));

InputDir = 'test_img';
SaveDir = 'char_img';
if ~isdir(SaveDir)
    mkdir(SaveDir);
end;
delete(fullfile(SaveDir,'*'));
DisplayMidRes = false;

% imgs = dir(InputDir);
% charImgCell = {};
% for t = 1:length(imgs)-2
%     imgName = imgs(t+2).name; % skip . and ..    
%     img = imread(fullfile(InputDir, imgName));
%     if DisplayMidRes
%         figure;
%         imshow(img);
%     end
%     
%     charImgCell = [charImgCell CharDetector(img, DisplayMidRes)];
% end

imgNames = {'1.jpg'};
% imgNames = {'1.jpg','2.jpg'};
imgInfoCell = {};

for t = 1:length(imgNames) 
    img = imread(fullfile(InputDir, cell2mat(imgNames(t))));
    mask = imread(fullfile(InputDir, ['Mask',cell2mat(imgNames(t))]));
    imgSize = size(img);
    mask = imresize(mask,imgSize(1:2));
    if DisplayMidRes
        figure;
        imshow(img);
    end
    [ imgInfo.charImgCell, imgInfo.boxCell ] = CharDetector(img, mask, DisplayMidRes);
    imgInfo.img = img;
    imgInfo.mask = mask;
    imgInfoCell = [imgInfoCell imgInfo];
end

% OCR and statistics
results.A = 0;
results.B = 0;
results.C = 0;
results.D = 0;
results.other = 0;
for i = 1:numel(imgInfoCell)
    imgInfo = cell2mat(imgInfoCell(i));    
    
    % Darken the region beyond ROI to make it easy for observation
    mask01 = imgInfo.mask./max(max(imgInfo.mask));
    img = imgInfo.img;
    for c = 1:size(img,3)
        a = img(:,:,c).*mask01;
        b = img(:,:,c).*(1-mask01)*0.2;
        img(:,:,c) = a+b;
    end    
    figure; 
    imshow(img); hold on;
    
    for j = 1:numel(imgInfo.charImgCell)
    %     imwrite(cell2mat(charImgCell(i)), fullfile(SaveDir, [num2str(i) '.jpg']));
        [wordRes, scoreRes] = OCRwapper( cell2mat(imgInfo.charImgCell(j)) );
        if 'A' == wordRes
            results.A = results.A + 1;
            rectangle('position',cell2mat(imgInfo.boxCell(j)),'edgecolor','r','LineWidth',2);
        elseif 'B' == wordRes
            results.B = results.B + 1;
            rectangle('position',cell2mat(imgInfo.boxCell(j)),'edgecolor','g','LineWidth',2);
        elseif 'C' == wordRes
            results.C = results.C + 1;
            rectangle('position',cell2mat(imgInfo.boxCell(j)),'edgecolor','b','LineWidth',2);
        elseif 'D' == wordRes
            results.D = results.D + 1;
            rectangle('position',cell2mat(imgInfo.boxCell(j)),'edgecolor','y','LineWidth',2);
        elseif 'other' == wordRes
            results.other = results.other + 1;
            rectangle('position',cell2mat(imgInfo.boxCell(j)),'edgecolor','w','LineWidth',1);
        end
    end
    hold off;
end
results