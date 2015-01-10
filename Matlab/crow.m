function crow(write, k)
crow = load('data/crow.mat');
sNcut = 0.14; sArea = 220;
I = imread('../pictures/crow.jpg');
tic
[segI] = NcutImageSegment(I, crow.W, sNcut, sArea, k+1);
toc
% show
for i=1:length(segI)
    if ~write
        figure; imshow(segI{i});
    else
        imwrite(segI{i}, sprintf('results/crowNC%d-%d.png', k, i));
    end
end
end
