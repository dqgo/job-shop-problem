%%主程序
function MAIN()
tic
global thisAGVCmax;
global thisMinCmax
%thisCmax=9999;
%%%%%%%%%%系数%%%%%%%%%%%%%
    popu=500;%得是偶数，要不然交叉就错了
    maxIterate=100;
    nowIterate=0;
    Pcross=0.8;
    Pmuta=0.2;
    muteNum=4;
    tubeSearchIterate=1;
    numCross=50;
%%%%%%%%%%系数%%%%%%%%%%%%%
    %载入算例
    [changeData,workpieceNum,machNum]=changeDataFunction();
    %初始化种群
    chromos = createInitialPopus(popu,machNum,workpieceNum);
    %遗传开始
    while all([thisMinCmax ~= 930, nowIterate < maxIterate])


        %对种群进行禁忌搜索
        for i=1:popu
            chromos(i,:)=tabuSearch(chromos(i,:),tubeSearchIterate,changeData,workpieceNum,machNum);
        end
        
        %选择操作
        chromos=selectChromos(chromos,popu,changeData,workpieceNum,machNum);
        nowAGVCmax(nowIterate+1)=thisAGVCmax;
        nowMinCmax(nowIterate+1)=thisMinCmax;
        
        %交叉操作 %动态的交叉概率 %随机选择一种交叉方式 %多次交叉
        %Pcross=dynamicPCross();
        %chromos=crossChromosPMX(chromos,Pcross,popu);
        %chromos=crossChromosPOX(chromos,Pcross,popu,workpieceNum);
        chromos=crossChromos(chromos, Pcross, popu, workpieceNum,numCross,machNum,changeData);
        
        %变异操作 %动态的变异概率
        %Pmuta=dynamicPMuta();
        chromos=mutatedChromos(chromos,Pmuta,popu,muteNum,changeData,workpieceNum,machNum);

        % 开始进行禁忌搜索
        % 对种群的每个染色体搜索进行禁忌搜索
        % for i=1:popu
        %     %解码，得到schedule1，并进行适应度评价，找到该染色体的最大完工时间
        %     schedule1 = createSchedule(changeData,chromos(i,:),workpieceNum,machNum);
        %     Cmax=max(schedule1(:,5));
        %     %对染色体进行逆解码，得到schedule2
        %     schedule2=createFlipSchedule(changeData,chromos(i,:),workpieceNum,machNum,Cmax);
        %     %找到关键路径，找到染色体关键块
        %     keyPath = searchKeyPath2(schedule1,schedule2);
        %     keyBlock = searchKeyBlock(keyPath);
        %     %对关键块进行N5邻域结构操作，得到邻域解
        %     neighborhoodChromos=creatneighborhoodChromos(chromos(i,:),keyBlock);
        %     %对所有的邻域解进行评价，得到邻域解的适应度排序
        %     fitness = calcFitness(neighborhoodChromos,size(neighborhoodChromos,1),changeData,workpieceNum,machNum);
        %     %sizeFitness=size(fitness,1);
        %     %%%%%%%%%%%%TEST%%%%%%%%%%%
        %     [~,index]=sortrows(fitness,1);
        %     chromos(i,:)=neighborhoodChromos(index(1,1),:);
        %     %%%%%%%%%%%%TEST%%%%%%%%%%%
        %     %theBestneighborhoodChromo=createBestChromo();
        %     %更新染色体和禁忌表
        %     %tabooTable=changeTabooTable();
        % end
        nowIterate=nowIterate+1;
    end
    %至此，已完成，下面找出种群内的最优解染色体和最优解数目，并输出gant图
    MAINEND(popu,chromos,changeData,workpieceNum,machNum);
    toc
    figure;
    plot(1:maxIterate,nowAGVCmax);
    figure;
    plot(1:maxIterate,nowMinCmax);
end



