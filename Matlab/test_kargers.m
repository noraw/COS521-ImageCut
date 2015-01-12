tic
load('data/50/baby.mat');
g = W;
[a, b] = KargersMinCut(g, 1, 2);
a
b
toc

