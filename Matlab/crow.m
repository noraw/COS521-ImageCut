function crow(write, k)
crow = load('data/50/crow.mat');
sNcut = 0.14; sArea = 220;
I = imread('../pictures/50/crow.jpg');
tic
[segI] = NcutImageSegment(I, crow.W, sNcut, sArea, k+1);
toc
% show
for i=1:length(segI)
    if ~write
        figure; imshow(segI{i});
    else
        imwrite(segI{i}, sprintf('results/50/crowNC%d-%d.png', k, i));
    end
end
end
