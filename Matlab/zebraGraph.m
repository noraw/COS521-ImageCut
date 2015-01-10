function zebraGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/zebra.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/zebra.mat', 'W');
end
