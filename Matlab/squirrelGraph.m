function squirrelGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/squirrel.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/squirrel.mat', 'W');

    I = imread('../pictures/100/squirrel.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/squirrel.mat', 'W');

    I = imread('../pictures/50/squirrel.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/squirrel.mat', 'W');
end
