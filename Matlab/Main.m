imageIn = '../pictures/zebra.jpg';
IG = imageToGraph(imageIn, .1, 4, 2);
save('zebra.mat', 'IG');

imageIn = '../pictures/squirrel.jpg';
IG = imageToGraph(imageIn, .1, 4, 2);
save('squirrel.mat', 'IG');

imageIn = '../pictures/redEyedTreeFrog.jpg';
IG = imageToGraph(imageIn, .1, 4, 2);
save('redEyedTreeFrog.mat', 'IG');

imageIn = '../pictures/redEyedTreeFrogWhite.jpg';
IG = imageToGraph(imageIn, .1, 4, 2);
save('redEyedTreeFrogWhite.mat', 'IG');

imageIn = '../pictures/baby.jpg';
IG = imageToGraph(imageIn, .1, 4, 2);
save('baby.mat', 'IG');

imageIn = '../pictures/circle.jpg';
IG = imageToGraph(imageIn, .1, 4, 2);
save('circle.mat', 'IG');

%imshow(full(IG.graph));