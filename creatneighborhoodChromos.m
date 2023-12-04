%函数输入对应的染色体和他的关键块 输出他的所有N5邻域操作之后的邻域染色体
%keyBlock是元胞
function neighborhoodChromos=creatneighborhoodChromos(chromo,keyBlock)
    j=1;
    blockNum=size(keyBlock,2); 
    if blockNum==0
        neighborhoodChromos=chromo;
    end
    for i=1:blockNum
        thisBlock=keyBlock{i};
        sizeBlock=size(thisBlock);
        if sizeBlock==2            
            chromo=swap(thisBlock(1),thisBlock(2),chromo);
        else
            chromo=swap(thisBlock(1),thisBlock(2),chromo);
            chromo=swap(size(thisBlock,2)-1,size(thisBlock,2),chromo);
        end
        neighborhoodChromos(j,:)=chromo;
        j=j+1;
    end
end

function chromo = swap(id1,id2,chromo)
    temp=chromo(1,id1);
    chromo(1,id1)=chromo(1,id2);
    chromo(1,id2)=temp;
end


% function neighborhoodChromos = creatneighborhoodChromos(chromo, keyBlock)
%     numOperations = length(chromo);
%     numKeyBlocks = length(keyBlock);
%     neighborhoodChromos = cell(1, numOperations * (numOperations - 1) * numKeyBlocks);
% 
%     index = 1;
%     for i = 1:numOperations
%         for j = (i + 1):numOperations
%             for k = 1:numKeyBlocks
%                 % 复制原染色体以进行修改
%                 neighborChromo = chromo;
% 
%                 % 交换位于关键块内的两个工序的位置
%                 block = keyBlock{k};
%                 neighborChromo(block(i)) = chromo(block(j));
%                 neighborChromo(block(j)) = chromo(block(i));
% 
%                 % 存储邻域染色体
%                 neighborhoodChromos{index} = neighborChromo;
%                 index = index + 1;
%             end
%         end
%     end
% end
