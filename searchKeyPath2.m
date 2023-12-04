function  keyPath = searchKeyPath2(schedule1, schedule2)
    % 找到关键路径的逻辑向量
    keyPathLogical = all(schedule1 == schedule2, 2);
    % 找到关键路径的索引
    keyIndices = find(keyPathLogical);   
    keyPath = [keyIndices, schedule1(keyIndices, 3)];
end
