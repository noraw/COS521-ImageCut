function brain2Graph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/brain2.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/brain2.mat', 'W');

    I = imread('../pictures/100/brain2.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/brain2.mat', 'W');

    I = imread('../pictures/50/brain2.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/brain2.mat', 'W');
end
