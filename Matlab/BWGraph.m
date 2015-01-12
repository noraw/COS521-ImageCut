function BWGraph()
    SI =5; SX =6; r = 1.5;
    I = imread('../pictures/small/color5.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/small/color5.mat', 'W');

    I = imread('../pictures/small/color10.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/small/color10.mat', 'W');

    I = imread('../pictures/small/color15.jpg');
    tic
    W = NcutComputeW(I, SI, SX, r);
    toc
    save('data/small/color15.mat', 'W');
end
