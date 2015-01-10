function brain3Graph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/brain3.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/brain3.mat', 'W');
end
