function [ charImgCell, boxCell ] = CharDetector(img, mask, DisplayMidRes)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%     close all
    charImgCell = {};
    boxCell = {};
    
    gray=uint8(rgb2gray(img));
%     gray = medfilt2(gray,[3,3]);
    mask01 = mask./max(max(mask));
    gray = gray.*mask01;
    
    % Darken the region beyond ROI to make it easy for observation
    for c = 1:size(img,3)
        a = img(:,:,c).*mask01;
        b = img(:,:,c).*(1-mask01)*0.2;
        img(:,:,c) = a+b;
    end
    
    % Parameter setting 1
    AeraThrMin = 10; % 连通域最小面积
    AeraThrMax = 400; % 连通域最大面积
    RatioThrMin = 0.5; % 连通域外接矩形最小宽/高比例
    RatioThrMax = 1.2; % 连通域外接矩形最大宽/高比例
    SatMeanMax = 0.6; % 饱和度最大值，超过了则为彩色patch，噪声
    ValueMeanMin = 0.4; % 亮度最小值，超过了则为噪声
    
    % Extract MSER
    % Parameter setting 2
    [R,F] = vl_mser(gray, 'MinDiversity',0.4,...
                 'MaxVariation',0.2,...
                'Delta',10,...
                'BrightOnDark',0,...
                'DarkOnBright',1) ;
%                 'MinArea',0.000015,...
%                 'MaxArea',0.001) ;
    M = zeros(size(gray)) ;
    for r=R'
        s = vl_erfill(gray,r) ;
        M(s) = M(s) + 1;
    end
    if DisplayMidRes
        figure, imshow(M);
    end
    
    % Transform to Binary Image, extract the connected domain, and filter
    % them with area threshold
    BW = im2bw(M,0); % Transform to Binary Image
    CC = bwconncomp(BW); % Extract the connected domain
    numPixels = cellfun(@numel,CC.PixelIdxList);
    idx = find(numPixels<AeraThrMin | numPixels>AeraThrMax);
    for i=1:numel(idx)
        BW(CC.PixelIdxList{idx(i)}) = 0;
    end
    
    % Extract the bounding boxes of connected domain, and filter them with
    % weight-height ratio and color info
    status  = regionprops(BW, 'BoundingBox');
    if DisplayMidRes
        figure, imshow(BW); 
        figure, imshow(img); 
        hold on;
    end
    for i=1:numel(status)
        box = status(i).BoundingBox; % box = [x,y,w,h]
        x=ceil(box(1)); y=ceil(box(2)); w=ceil(box(3)); h=ceil(box(4));
        ratio = w/h;
        if ratio<RatioThrMin || ratio>RatioThrMax
            continue;
        end
        subImg = img(y:y+h-1,x:x+w-1,:);
        hsv = rgb2hsv(subImg);
        satMean  = mean(mean(hsv(:,:,2)));
        valueMean  = mean(mean(hsv(:,:,3)));
        if satMean>SatMeanMax || valueMean<ValueMeanMin
            continue;
        end
        charImgCell = [charImgCell subImg];
        boxCell = [boxCell status(i).BoundingBox];
        % Draw detection results with rectangles
        if DisplayMidRes
            rectangle('position',status(i).BoundingBox,'edgecolor','r','LineWidth',2.5);
        end
    end 
    if DisplayMidRes
        hold off;
    end    

%             
%     figure;
%     bg = zeros(size(img)) ;
%     clf ; imagesc(img) ; hold on ; axis equal off; colormap gray ;
%     [c,h]=contour(BW,(0:max(M(:)))+.5) ;
%     set(h,'color','y','linewidth',3) ;
    
end

