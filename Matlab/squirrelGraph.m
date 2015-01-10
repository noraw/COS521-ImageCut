function squirrelGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/squirrel.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/squirrel.mat', 'W');
end
