function brain3Graph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/200/brain3.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/200/brain3.mat', 'W');
    
    I = imread('../pictures/100/brain3.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/100/brain3.mat', 'W');

    I = imread('../pictures/50/brain3.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/50/brain3.mat', 'W');
end
