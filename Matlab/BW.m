function BW(write, k, sz)
graph = load(sprintf('data/small/color%d.mat', sz));
if ~exist('write', 'var'), write = false; end;
sNcut = 0.14; sArea = 220;
I = imread(sprintf('../pictures/small/color%d.jpg', sz));
tic
[segI] = NcutImageSegment(I, graph.W, sNcut, sArea, k+1);
toc
% show
for i=1:length(segI)
    if ~write
        figure; imshow(segI{i});
    else
        imwrite(segI{i}, sprintf('results/small/color%dNC%d-%d.png', sz, k, i));
    end
end
end
