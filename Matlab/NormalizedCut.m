classdef NormalizedCut
    % Summary of this class goes here
    % Detailed explanation goes here
    
    properties
        D
        D2
        W
        V
        E
    end
    
    methods
        function NC = NormalizedCut(IG)
            NC.D = spdiags(sum(IG.graph, 2), [0], IG.n, IG.n);
            NC.D2 = sum(IG.graph, 2);
            NC.D2 = spdiags(sqrt(1 ./ NC.D2), [0], IG.n, IG.n);
            NC.W = IG.graph;
            [NC.V, NC.E] = eigs(NC.D2 * (NC.D-NC.W) * NC.D2);
        end
        
        function S = splitOnEigIn2(NC)
            [x, e] = size(NC.V);
            s = NC.V(:, e-2);
        end
        
    end
    
end

