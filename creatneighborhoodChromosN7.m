%函数输入对应的染色体和他的关键块 输出他的所有N7邻域操作之后的邻域染色体
%keyBlock是元胞
% 这是N7的移动版本
function neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock)
    neighborhoodChromos=[];
    blockNum=size(keyBlock,2); 
    
    if blockNum==0
        neighborhoodChromos=chromo;
    end
    for i=1:blockNum
        chromosTemp=zeros(0);
        thisBlock=keyBlock{i};
        sizeBlock=size(thisBlock,2);
        if sizeBlock==2
            chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
        else
            point=randperm(sizeBlock-2,1)+1;            
            %首移动的关键块
            thisBlockwork=chromo(thisBlock);
            indexChromo=chromo;indexChromo(thisBlock)=-999;
            moveKeyBlockwork = moveFirst(thisBlockwork,point);
            indexChromo(indexChromo==-999)=moveKeyBlockwork;
            chromosTemp=[chromosTemp;indexChromo]; 
            %尾移动的关键块
            indexChromo=chromo;indexChromo(thisBlock)=-999;
            moveKeyBlockwork = moveEnd(thisBlockwork,point);
            indexChromo(indexChromo==-999)=moveKeyBlockwork;
            chromosTemp=[chromosTemp;indexChromo];
            
        end
        neighborhoodChromos=[neighborhoodChromos;chromosTemp];
    end
end

function moveKeyBlock = moveFirst(keyBlock,point)
    % 将第一个元素移动到数组的第point个位置
    point = point+1;
    % 保存第一个元素的值
    elementToMove = keyBlock(1);
    % 移动其他元素以腾出空间
    keyBlock = [keyBlock(2:point-1), elementToMove, keyBlock(point:end)];
    moveKeyBlock=keyBlock;
end

function moveKeyBlock = moveEnd(keyBlock,point)
    % 保存最后一个元素的值
    elementToMove = keyBlock(end);
    % 移动其他元素以腾出空间
    keyBlock = [keyBlock(1:point-1), elementToMove, keyBlock(point:end-1)];
    moveKeyBlock=keyBlock;
end

function chromo = swap(id1,id2,chromo)
    temp=chromo(1,id1);
    chromo(1,id1)=chromo(1,id2);
    chromo(1,id2)=temp;
end






% 这是N7的交换版本
% function neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock)
%     neighborhoodChromos=chromo;
%     blockNum=size(keyBlock,2); 
% 
%     if blockNum==0
%         neighborhoodChromos=chromo;
%     end
%     for i=1:blockNum
%         chromosTemp=zeros(0);
%         thisBlock=keyBlock{i};
%         sizeBlock=size(thisBlock,2);
%         if sizeBlock==2            
%             %chromo=swap(thisBlock(1),thisBlock(2),chromo);
%             chromosTemp=[chromosTemp;swap(thisBlock(1),thisBlock(2),chromo)];
%         else
%             point=randperm(sizeBlock-2,1);
%             %只交换首或尾
%             chromosTemp=[chromosTemp;swap(thisBlock(1),point+1,chromo)];
%             chromosTemp=[chromosTemp;swap(point+1,size(thisBlock,2),chromo)];                  
% 
%             %同时交换首和尾
%             chromoTemp=swap(thisBlock(1),point+1,chromo);
%             chromoTemp=swap(point,size(thisBlock,2),chromo);
%             chromosTemp=[chromosTemp;chromoTemp];
%             %chromo=swap(size(thisBlock,2)-1,size(thisBlock,2),chromo);
%         end
%         neighborhoodChromos=[neighborhoodChromos;chromosTemp];
%     end
% end
% 
% function chromo = swap(id1,id2,chromo)
%     temp=chromo(1,id1);
%     chromo(1,id1)=chromo(1,id2);
%     chromo(1,id2)=temp;
% end
