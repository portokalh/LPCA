function [HeaderFormat] = OverCompleteLpca(Input)
% Input Variable is a struct with arguments
%       Block: size of the local chunks by default [4 4 4]
%     DwiFile: 'File Path' read from for DWI data
%      B0File: 'File Path' read from for B0 data
%     DwoFile: 'File Path' written to for output Dwi
%        Comp: Completeness, 1 - total overcompleteness 0- zero proccesing
%        Vout: logical, whether or not a visual is displayed at end
%        Save: logical, whether or not a file is saved
%         Pre: logical, whether or not a premature termination is allowed
%      Thresh: coeffient of number of eigen vecotors retained
%
%  Start Gui Program brings up a gui that auto fills in Input Struct

canceled = 0;
WorkDone = 0;
% take Inputs From Input Struct
BlockSize = Input.Block;
Coeff = Input.Thresh;
Completeness = Input.Comp;
% use ReadDWI function to convert the files to 4D - Single Arrays
[RawImg,Dim,HeaderFormat] = readDwi(Input.DwiFile,BlockSize);
B0Img = readDwi(Input.B0File,BlockSize);
% number of unintersecting blocks required to fill the whole image
BlockCount = ceil(Dim(1:3) ./ BlockSize);

tic;
%creates a waitbar
if Input.Pre
    W = waitbar(0,'Progress','CreateCancelBtn','setappdata(gcbf,''Cancel'',1)');
else
    W = waitbar(0);
end
for ShiftC = 1:floor(prod(BlockSize)*Completeness)
    Shift = num2index(ShiftC,BlockSize);
    for i = 1:3
        coords(:,i) =  Shift(i):BlockSize:Dim(1)+BlockSize+Shift(i);
    end
    for k = coords(1:BlockCount(3),1)'
        for j = coords(1:BlockCount(2),1)'
            for i = coords(1:BlockCount(1),1)'
                % Extract the portion of the image used for local analysis
                % using chunk function, from both image and B0's
                CurBlock = chunk(RawImg,[i,j,k],BlockSize);
                CurB0 = chunk(B0Img,[i,j,k],BlockSize);
                ReShaped = reshape(CurBlock,prod(BlockSize),Dim(4));
                MeanArr = repmat(mean(ReShaped), prod(BlockSize), 1 );
                Normalized = ReShaped - MeanArr;
                StdVal = std(Normalized(:));
                Normalized = Normalized / StdVal; % To prevent very small numbers
                CovarMat = Normalized' * Normalized;
                [EigVec , EigVal] = eig(CovarMat); %eigenvectors of Covar is equal to PCA
                for B0layers = 1:(size(CurB0,4))
                noise(:,:,:,B0layers) = CurB0(:,:,:,B0layers) - CurBlock(:,:,:,B0layers);
                end
                NoiseVariance = std(noise(:));
                Thresh = NoiseVariance / Coeff;
                NewEigVec = EigVec * (EigVal > Thresh);
                DeNoised = (Normalized * NewEigVec) * NewEigVec';
                DeNormalized = (DeNoised * StdVal) + MeanArr;
                DeShaped = reshape(DeNormalized,BlockSize(1),BlockSize(2),BlockSize(3),Dim(4));
                Weight(ShiftC,i:i+BlockSize(1)-1,j:j+BlockSize(2)-1,...
                    k:k+BlockSize(3)-1) = 1/sum(sum(EigVal > Thresh));
                WeightedVals = DeShaped * Weight(ShiftC,i,j,k);
                SummedVals(i:i+BlockSize(1)-1,j:j+BlockSize(2)-1,...
                    k:k+BlockSize(3)-1,:,2) = WeightedVals;
            end
        end
        time = toc;
        WorkDone =  WorkDone + 1/BlockCount(3);
        Percent = WorkDone / floor(prod(BlockSize)*Completeness);
        TimeLeft = time/Percent-time;
        Y = ['Their are about ', num2str(TimeLeft/60) , ' minutes left.'];
        W = waitbar(Percent,W,Y);
        if getappdata(W,'Cancel')
            canceled = 1;
            F = findall(0,'type','figure','tag','TMWWaitbar');
            delete(F)
            break
        end
    end
    SummedVals = sum(SummedVals,5);
    if canceled
        'You Have Canceled'
        break
    end
end
WeightSum = permute(repmat(sum(Weight,1),Dim(4),1,1,1),[2,3,4,1]);
IntOut = int16(SummedVals./WeightSum);
IntOut = IntOut(1:Dim(1),1:Dim(2),1:Dim(3),:);
HeaderFormat = setfield(HeaderFormat,'img',IntOut);
if Input.Vout
    view_nii(HeaderFormat);
end
if Input.Save
    save_nii(HeaderFormat,Input.DwoFile)
end
    F = findall(0,'type','figure','tag','TMWWaitbar');
    delete(F)
end