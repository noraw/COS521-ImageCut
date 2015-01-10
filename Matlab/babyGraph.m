function babyGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/baby.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/baby.mat', 'W');
end
