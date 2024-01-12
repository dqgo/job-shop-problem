%%主程序
function MAIN()
tic
global thisAGVCmax;
global thisMinCmax
thisMinCmax=9999;
%%%%%%%%%%系数%%%%%%%%%%%%%
    popu=200;%得是偶数，要不然交叉就错了
    maxIterate=5;
    nowIterate=0;
    Pcross=0.9;
    Pmuta=0.2;
    muteNum=4;
    tubeSearchIterate=13;
    %numCross=10;
    tubeSearchLength=5;
    immigrantNum=4;
    immigrantSize=0.4;
%%%%%%%%%%系数%%%%%%%%%%%%%
    %载入算例
    [changeData,workpieceNum,machNum]=changeDataFunction();
    %初始化种群
    chromos = createInitialPopus(popu,machNum,workpieceNum);
    %遗传开始
    while all([thisMinCmax ~= 930, nowIterate < maxIterate])

        % 对种群进行禁忌搜索
        for i=1:popu
            chromos(i,:)=tabuSearch(chromos(i,:),tubeSearchIterate,changeData,workpieceNum,machNum,tubeSearchLength);            
        end
                
        %计算适应度
        fitness = calcFitness(chromos, popu, changeData, workpieceNum, machNum);
        
        %判断是否需要引入灾难和移民    
        if nowIterate>immigrantNum
            if all(nowMinCmax(end-immigrantNum+1:end)==min(fitness))
                chromos= joinImmigrant(chromos,fitness,machNum,workpieceNum,immigrantSize);
                disp('use immigrant一次');
            end
        end

        %选择操作
        chromos=selectChromos(chromos,popu,changeData,workpieceNum,machNum,fitness);
        nowAGVCmax(nowIterate+1)=thisAGVCmax;
        nowMinCmax(nowIterate+1)=thisMinCmax;
        
        %交叉操作 %动态的交叉概率 %随机选择一种交叉方式 %多次交叉
        %Pcross=dynamicPCross();
        % chromos=crossChromosPMX(chromos,Pcross,popu);
        chromos=crossChromosPOX(chromos,Pcross,popu,workpieceNum);
        % chromos=crossChromos(chromos, Pcross, popu, workpieceNum,numCross,machNum,changeData); 
        % chromos=crossChromos(chromos,Pcross,popu,workpieceNum);
        
        %变异操作 %动态的变异概率
        %Pmuta=dynamicPMuta();
        chromos=mutatedChromos(chromos,Pmuta,popu,muteNum,changeData,workpieceNum,machNum);

        nowIterate=nowIterate+1;
        % disp(nowMinCmax(nowIterate));
    end
    %至此，已完成，下面找出种群内的最优解染色体和最优解数目，并输出gant图
    MAINEND(popu,chromos,changeData,workpieceNum,machNum);
    disp(nowIterate);
    toc
    % figure;
    % plot(1:nowIterate,nowAGVCmax);
    % figure;
    % plot(1:nowIterate,nowMinCmax);
end



