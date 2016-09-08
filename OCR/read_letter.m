function [letter, confidence] = read_letter(imagn,num_letras)
% Computes the correlation between template and input image
% and its output is a string containing the letter.
% Size of 'imagn' must be 42 x 24 pixels.  aka. the same size as template

global templates
comp=zeros(num_letras,1);
for n=1:num_letras
    sem=corr2(templates{1,n},imagn);
    comp(n)=sem;
end
vd=find(comp==max(comp)); % index of max confidence
confidence = comp(vd);  % calculate confidence
%*-*-*-*-*-*-*-*-*-*-*-*-*-
if vd==1
    letter='A';
elseif vd==2
    letter='B';
else
    letter='C';
end

