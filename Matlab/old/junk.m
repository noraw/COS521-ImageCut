            for i1 = 1 : IG.rows
                for j1 = 1 : IG.columns
                    current = [imagePositionToGraphID(IG, i1,j1), i1, j1]
                    for i2 = max(i1-IG.r, 1) : min(i1+IG.r, IG.columns)
                        for j2 = max(i2-IG.r, 1) : min(i2+IG.r, IG.columns)
                            p1 = [i1, j1];
                            p2 = [i2, j2];
                            compare = [imagePositionToGraphID(IG, i2,j2), i2, j2]
                            dist = norm(p1 - p2);
                            if dist < IG.r
                                EDist = exp(-dist^2 / IG.oX);
                                EColor = colorExp(IG, p1, p2);
                                weight = EColor * EDist;
                                id1 = imagePositionToGraphID(IG, i1, j1);
                                id2 = imagePositionToGraphID(IG, i2, j2);
                                IG.graph(id1, id2) = weight;
                                a = [id1, id2, weight, EColor, EDist]
                            end
                        end
                    end
                end
            end
