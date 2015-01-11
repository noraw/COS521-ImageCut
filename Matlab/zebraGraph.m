function zebraGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/zebra.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/zebra.mat', 'W');

    I = imread('../pictures/100/zebra.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/zebra.mat', 'W');

    I = imread('../pictures/50/zebra.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/zebra.mat', 'W');
end
