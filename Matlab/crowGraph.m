function crowGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/crow.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/crow.mat', 'W');

    I = imread('../pictures/100/crow.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/crow.mat', 'W');

    I = imread('../pictures/50/crow.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/crow.mat', 'W');
end
