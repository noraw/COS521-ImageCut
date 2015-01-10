[r, c] = size(K);
max(K(:,1))
max(K(:,2))
for i=1:c
    mask = convertGraphVectorToImage(IG.IG, K(:, i));
    mask3 = uint8(cat(3, mask, mask, mask));
    image = IG.IG.image .* mask3;
    imshow(full(image));
    file = ['results/BW5_', num2str(i), '.jpg'];
    imwrite(full(image), file);
end