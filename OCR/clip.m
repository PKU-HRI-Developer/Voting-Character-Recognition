% clip letters, if no areas, return []
function img_out=clip(img_in)
[f, c]=find(img_in);
if isempty(f) || isempty(c)
    img_out = [];
else
    img_out=img_in(min(f):max(f),min(c):max(c));%Crops image
end