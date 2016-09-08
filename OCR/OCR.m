% OCR (Optical Character Recognition) for Voting system
% Author: zhang xuewu
% e-mail: zhangxuewu@pku.edu.cn
warning('off','verbose');
clc, close all, clear all
% Read image
imagen=imread('test_img/A/1.jpg');
% Show image
imshow(imagen);
% Convert to gray scale
if size(imagen,3)==3 %RGB image
    imagen=rgb2gray(imagen);
end
% Convert to BW. Using automtic threshold
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);
% Remove all object containing fewer than 30 pixels
imagen = bwareaopen(imagen,30);
%Storage matrix word  and score from image
word=[ ];
score = [];
re=imagen;
%Opens text.txt as file for write
fid = fopen('result.txt', 'wt');
% Load templates
global templates
load templates
% Compute the number of letters in template file
num_letras=size(templates,2);
%%
imgn = clip(re);
if isempty(imgn)
    fprintf(fid,'%s  %f\n','other', -1);% write result to text file, the final result
else
    [L, Ne] = bwlabel(imgn);    
    for n=1:Ne
        [r,c] = find(L==n);
        % Extract letter
        n1=imgn(min(r):max(r),min(c):max(c));  
        % Resize letter (same size of template)
        img_r=imresize(n1,[42 24]);
        %Uncomment line below to see letters one by one
         %imshow(img_r);pause(0.5)
        %-------------------------------------------------------------------
        % Call function to convert image to text
        [letter, confidence] = read_letter(img_r,num_letras);
        % Letter concatenation
        word=[word letter];
        score = [score confidence];
    end
    ind = find(score == max(score));  % this can hanle kuangkuang
     if (max(score) < 0.1)   % set up threshold, ****************************** set here*******************
        fprintf(fid,'%s  %f\n','other', -1);% write result to text file, the final result
     else         
        fprintf(fid,'%s  %f\n',word(ind), score(ind));% write result to text file, the final result
     end
    % Clear 'word' variable
    word=[ ];
end
fclose(fid);
%Open 'text.txt' file
winopen('result.txt')
clear all