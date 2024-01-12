% 禁忌搜索
function outChromo = tabuSearch(inChromo,tubeSearchIterate,changeData,workpieceNum,machNum,tubeSearchLength)
    %初始化
    chromo=inChromo;
    bestChromo.chromo=zeros(0);
    bestChromo.fitness=99999;
    tubeList=struct('chromo',{},'tubeSearchLength',{});
    for i=1:tubeSearchIterate
        %生成解的邻域解
        %解码，得到schedule1，并进行适应度评价，找到该染色体的最大完工时间
        schedule1 = createSchedule(changeData,chromo,workpieceNum,machNum);        
        Cmax=max(schedule1(:,5));
        %对染色体进行逆解码，得到schedule2
        % schedule2=createFlipSchedule(changeData,chromo,workpieceNum,machNum,Cmax);
        % schedule2=createRightSchedule(schedule1,Cmax,workpieceNum,machNum);
        %应当给出标准化之后的染色体
        [chromo,schedule2]= createRightSchedule(schedule1,Cmax,workpieceNum,machNum);
        %找到关键路径，找到染色体关键块
        keyPath = searchKeyPath2(schedule1,schedule2);
        keyBlock = searchKeyBlock(keyPath);
        %对关键块进行邻域结构操作，得到邻域解
        % neighborhoodChromos=creatneighborhoodChromosN5(chromo,keyBlock);
        neighborhoodChromos=creatneighborhoodChromosN7(chromo,keyBlock);
        %对所有的邻域解进行评价，得到邻域解的适应度排序
        fitness = calcFitness(neighborhoodChromos,size(neighborhoodChromos,1),changeData,workpieceNum,machNum);
        [fitness,index]=sortrows(fitness);
        % disp(fitness);
        if bestChromo.fitness>fitness(1)
            bestChromo.fitness=fitness(1);
            bestChromo.chromo=neighborhoodChromos(index(1),:);
        end        
        for j=1:size(neighborhoodChromos,1)
            thisChromoIsin=false;
            if ~isempty(tubeList)
                % 按适应度依次检查染色体是否在禁忌表内
                for k = 1:numel(tubeList)
                    % if isequal(neighborhoodChromos(j,:), tubeList(k).chromo)
                    if isequal(neighborhoodChromos(index(j),:), tubeList(k).chromo)
                        % 在禁忌表内的话就什么都不做
                        thisChromoIsin = true;
                        break;
                    end
                end
            end %if
            if ~thisChromoIsin
                % 不在禁忌表内
                chromo = neighborhoodChromos(index(j),:);
                tubeList(end+1).tubeSearchLength = tubeSearchLength; %%%%%
                tubeList(end).chromo = neighborhoodChromos(index(j),:); %%%%%
                break;
            end
        end
        %更新禁忌表
        for k=numel(tubeList):-1:1
            tubeList(k).tubeSearchLength=tubeList(k).tubeSearchLength-1;
        end
        for k=numel(tubeList):-1:1
            if all(tubeList(k).tubeSearchLength==-1)
                tubeList(k)=[];
            end
        end
    end

    outChromo=bestChromo.chromo;
end