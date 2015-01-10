IG = load('data/BW5.mat');
%NC = NormalizedCut(IG.IG, 7, .01);
%K = normalizedCutIntoKParts(NC, 1);
%[S, cut] = splitOnEigIn2(NC);

I = ones(IG.IG.n, 1);
W = IG.IG.graph;
sNcut = 0.21; sArea = 15;
k = 2;
[Seg Id Ncut] = NcutPartition(I, W, sNcut, sArea, 'ROOT', k);