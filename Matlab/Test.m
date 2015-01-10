IG = load('data/BW5.mat');
NC = NormalizedCut(IG.IG, 7, .01);
K = normalizedCutIntoKParts(NC, 1);
%[S, cut] = splitOnEigIn2(NC);