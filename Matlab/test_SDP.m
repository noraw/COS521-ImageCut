tic
load('data/baby.mat');
g = IG.graph;
g = g(1:1000, 1:1000);
clear IG;
t = SDPCut(g, 2)
t
toc

