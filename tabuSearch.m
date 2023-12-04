function outChromo = tabuSearch(inChromo,tubeSearchIterate,changeData,workpieceNum,machNum)
    %初始化
    
    % bestChromo.chromo;
    % bestChromo.fitness;
    % tubeList;
    for i=1:tubeSearchIterate
        %生成解的邻域解
        %解码，得到schedule1，并进行适应度评价，找到该染色体的最大完工时间
        schedule1 = createSchedule(changeData,inChromo,workpieceNum,machNum);
        Cmax=max(schedule1(:,5));
        %对染色体进行逆解码，得到schedule2
        schedule2=createFlipSchedule(changeData,inChromo,workpieceNum,machNum,Cmax);
        %找到关键路径，找到染色体关键块
        keyPath = searchKeyPath2(schedule1,schedule2);
        keyBlock = searchKeyBlock(keyPath);
        %对关键块进行N5邻域结构操作，得到邻域解
        neighborhoodChromos=creatneighborhoodChromos(inChromo,keyBlock);
        %对所有的邻域解进行评价，得到邻域解的适应度排序
        fitness = calcFitness(neighborhoodChromos,size(neighborhoodChromos,1),changeData,workpieceNum,machNum);        
        %%%%%%%%%%TEMP%%%%%%%%%%%
        sizeFitness=size(fitness,1);
        [~,index]=sortrows(fitness,1);
        outChromo=neighborhoodChromos(index(1,1),:);
        %%%%%%%%%%TEMP%%%%%%%%%%%

        %查找禁忌表，检验最优
        %[bestChromo,nowChromo]=isInTube(neighborhoodChromos,fitness,tubeList,bestChromo);
        %更新禁忌表
        %changeTubeList();
    end
end