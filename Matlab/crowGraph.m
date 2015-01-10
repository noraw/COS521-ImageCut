function crowGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/crow.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/crow.mat', 'W');
end
