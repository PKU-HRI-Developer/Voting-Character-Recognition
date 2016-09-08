%CREATE TEMPLATES USING LETTERS A B C
%Letter
A=imread('letters_numbers\A.bmp');B=imread('letters_numbers\B.bmp');
C=imread('letters_numbers\C.bmp');
letter=[A B C ];
%number=[one two three four five...
%    six seven eight nine zero];
character = letter;
templates = mat2cell(character,42,[24 24 24]);
save ('templates','templates')
clear all
