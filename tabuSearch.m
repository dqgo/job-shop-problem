% 禁忌搜索
function outChromo = tabuSearch(inChromo,tubeSearchIterate,changeData,workpieceNum,machNum,tubeSearchLength)
    %初始化
    chromo=inChromo;
    bestChromo.chromo=zeros(0);
    bestChromo.fitness=9999;
    tubeList.chromo=zeros(0);
    tubeList.tubeSearchLength=zeros(0);
    for i=1:tubeSearchIterate
        %生成解的邻域解
        %解码，得到schedule1，并进行适应度评价，找到该染色体的最大完工时间
        schedule1 = createSchedule(changeData,chromo,workpieceNum,machNum);
        Cmax=max(schedule1(:,5));
        %对染色体进行逆解码，得到schedule2
        schedule2=createFlipSchedule(changeData,chromo,workpieceNum,machNum,Cmax);
        %找到关键路径，找到染色体关键块
        keyPath = searchKeyPath2(schedule1,schedule2);
        keyBlock = searchKeyBlock(keyPath);
        %对关键块进行N5邻域结构操作，得到邻域解
        neighborhoodChromos=creatneighborhoodChromos(chromo,keyBlock);
        %对所有的邻域解进行评价，得到邻域解的适应度排序
        fitness = calcFitness(neighborhoodChromos,size(neighborhoodChromos,1),changeData,workpieceNum,machNum);
        [fitness,index]=sortrows(fitness);

        if bestChromo.fitness>fitness(1)
            bestChromo.fitness=fitness(1);
            bestChromo.chromo=neighborhoodChromos(index(1),:);
        end

        for j=1:size(neighborhoodChromos,1)

            thisChromoIsin=false;
            if ~isempty(tubeList)
                for k = 1:numel(tubeList)
                    if isequal(neighborhoodChromos(j,:), tubeList(k).chromo)
                        % 在禁忌表内的话就什么都不做
                        thisChromoIsin = true;
                        break;
                    end
                end
            end

            if ~thisChromoIsin
                % 不在禁忌表内
                chromo = neighborhoodChromos(j,:);
                tubeList(end+1).tubeSearchLength = tubeSearchLength;
                tubeList(end+1).chromo = neighborhoodChromos(j,:);
                break;
            end

        %     for k=1:numel(tubeList)
        %         if any(neighborhoodChromos(j,:)==tubeList(k).chromo)
        %             thisChromoIsin=true;
        %             break;
        %         end
        %     end
        % 
        %     if thisChromoIsin
        %         %在禁忌表内的话就什么都不做
        %     else
        %         %不在禁忌表内
        %         chromo=neighborhoodChromos(j,:);
        %         tubeList(size(tubeList,2)+1).tubeSearchLength=tubeSearchLength;
        %         tubeList(size(tubeList,2)+1).chromo=neighborhoodChromos(j,:);
        %         break;
        %     end
        end

        %更新禁忌表
        for k=1:numel(tubeList)
            tubeList(k).tubeSearchLength=tubeList(k).tubeSearchLength-1;
        end
        for k=numel(tubeList)
            if all(tubeList(k).tubeSearchLength<=0)
                tubeList(k)=[];
            end
        end
        

    end
    outChromo=bestChromo.chromo;
end
