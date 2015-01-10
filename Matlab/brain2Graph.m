function brain2Graph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/brain2.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/brain2.mat', 'W');
end
