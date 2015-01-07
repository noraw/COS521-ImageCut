classdef imageToGraph
    %IMAGETOGRAPH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        image
        imagehsv
        graph
        rows
        columns
        n
        oX
        oI
        r
    end
    
    methods
        function IG = imageToGraph(imageIn, oI, oX, r)
             IG.image = imread(imageIn);
             [IG.rows, IG.columns, x] = size(IG.image);
             if(x == 1)
                 IG.image = cat(3, IG.image,IG.image,IG.image);
             end
             IG.imagehsv = rgb2hsv(IG.image); 
             IG.n = IG.rows*IG.columns;
             IG.graph = sparse(IG.n, IG.n);
             IG.oI = oI;
             IG.oX = oX;
             IG.r = r;
             IG = createGraph(IG);
        end
        
        function pos = graphIDToImagePosition(IG, id)
            id = id -1;
            i = floor(id/IG.columns)+1;
            j = mod(id, IG.columns)+1;
            pos = [i, j];
        end
        
        function id = imagePositionToGraphID(IG, i, j)
            id = (i-1) * IG.columns + j;
        end
        
        function dist = pictureDistance(IG, i, j)
            pos1 = graphIDToImagePosition(IG, i);
            pos2 = graphIDToImagePosition(IG, j);
            dist = norm(pos1 - pos2);
        end
        
        function dist = colorExp(IG, pos1, pos2)
            hsv1 = IG.imagehsv(pos1(1), pos1(2), :);
            hsv2 = IG.imagehsv(pos2(1), pos2(2), :);
            F1 = [hsv1(3), hsv1(3) * hsv1(2) * sin(hsv1(1)), ...
                hsv1(3) * hsv1(2) * cos(hsv1(1))];
            F2 = [hsv2(3), hsv2(3) * hsv2(2) * sin(hsv2(1)), ...
                hsv2(3) * hsv2(2) * cos(hsv2(1))];
            dist = norm(F1 - F2);
            exp(-dist^2 / IG.oI);
        end

        function IG = createGraph(IG)
            for i1 = 1 : IG.rows
                i1
                for j1 = 1 : IG.columns
                    for i2 = max(i1-IG.r, 1) : min(i1+IG.r, IG.rows)
                        for j2 = max(j1-IG.r, 1) : min(j1+IG.r, IG.columns)
                            p1 = [i1, j1];
                            p2 = [i2, j2];    
                            dist = norm(p1 - p2);
                            if dist < IG.r
                                EDist = exp(-dist^2 / IG.oX);
                                EColor = colorExp(IG, p1, p2);
                                weight = EColor * EDist;
                                id1 = imagePositionToGraphID(IG, i1, j1);
                                id2 = imagePositionToGraphID(IG, i2, j2);
                                IG.graph(id1, id2) = weight;
                            end
                        end
                    end
                end
            end
%            for i = 1 : IG.n
%                for j = 1 : IG.n
%                    XDist = pictureDistance(IG, i, j);
%                    if XDist < IG.r
%                        EDist = exp(-XDist^2 / IG.oX);
%                        FDist = colorDistance(IG, i, j);
%                        EColor = exp(-FDist^2 / IG.oI);
%                        weight = EColor * EDist;
%                        IG.graph(i, j) = weight;
%                    end
%                end
%            end
        end
    end
    
end

