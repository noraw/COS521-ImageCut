function brain1Graph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/brain1.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/brain1.mat', 'W');
end
