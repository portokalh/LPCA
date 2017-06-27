function [RawImg,Dim,HeaderFormat] = readDwi(file,BlockSize)
tic;
InitialFile = load_nii(file); % ~1.4 sec
RawImg = InitialFile.img;
InitialFile = rmfield(InitialFile,'img'); % save mem space by deleting duplicate img
HeaderFormat = InitialFile;
%Force all outputs to be of the single type
if isa(RawImg,'integer')
    RawImg = im2single(RawImg);
elseif isa(RawImg, 'double')
    RawImg = im2single(RawImg);
end
Dim = size(RawImg);
RawImg = padarray(RawImg,BlockSize,'circular','post');
end

