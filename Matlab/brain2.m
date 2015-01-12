function brain2(write, k)
graph = load('data/50/brain2.mat');
if ~exist('write', 'var'), write = false; end;
sNcut = 0.14; sArea = 220;
I = imread('../pictures/50/brain2.jpg');
tic
[segI] = NcutImageSegment(I, graph.W, sNcut, sArea, k+1);
toc
% show
for i=1:length(segI)
    if ~write
        figure; imshow(segI{i});
    else
        imwrite(segI{i}, sprintf('results/50/brain2NC%d-%d.png', k, i));
    end
end
end
