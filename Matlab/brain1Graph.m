function brain1Graph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/brain1.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/brain1.mat', 'W');

    I = imread('../pictures/100/brain1.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/brain1.mat', 'W');

    I = imread('../pictures/50/brain1.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/brain1.mat', 'W');
end
