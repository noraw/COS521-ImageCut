function squirrel(write, k)
graph = load('data/50/squirrel.mat');
if ~exist('write', 'var'), write = false; end;
sNcut = 0.14; sArea = 220;
I = imread('../pictures/50/squirrel.jpg');
tic
[segI] = NcutImageSegment(I, graph.W, sNcut, sArea, k+1);
toc
% show
for i=1:length(segI)
    if ~write
        figure; imshow(segI{i});
    else
        imwrite(segI{i}, sprintf('results/50/squirrelNC%d-%d.png', k, i));
    end
end
end
