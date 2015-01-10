tic
load('data/baby.mat');
g = IG.graph;
clear IG;
[a, b] = KargersMinCut(g, 1, 2);
a
b
toc

