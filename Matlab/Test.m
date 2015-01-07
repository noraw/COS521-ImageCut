%IG = load('circle.mat');
NC = NormalizedCut(IG, 7, .001);
K = normalizedCutIntoKParts(NC, 2);
%[S, cut] = splitOnEigIn2(NC);