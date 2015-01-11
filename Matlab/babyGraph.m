function babyGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/baby.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/baby.mat', 'W');

    I = imread('../pictures/100/baby.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/baby.mat', 'W');

    I = imread('../pictures/50/baby.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/baby.mat', 'W');
end
