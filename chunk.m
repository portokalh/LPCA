function [chunk] = chunk(RawImg,coord,BlockSize)
chunk = RawImg(coord(1):coord(1)+BlockSize(1)-1,...
    coord(2):coord(2)+BlockSize(2)-1,coord(3):coord(3)+BlockSize(3)-1,:);
end