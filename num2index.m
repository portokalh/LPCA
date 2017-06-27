function[ind] = num2index(num,BlockSize)
for i = 1:numel(BlockSize)
    ind(i) = ceil((mod(num-1,prod(BlockSize(1:i)))+1)/prod(BlockSize(1:i))*BlockSize(i));
    end
end