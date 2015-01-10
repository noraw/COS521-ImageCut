classdef NormalizedCut2
    % Summary of this class goes here
    % Detailed explanation goes here
    
    properties
        W
        n
        % the number of evenly spaced points that we will check for the
        % min Ncut
        l
        eps
    end
    
    methods
        function NC = NormalizedCut2(IG, l, eps)
            NC.l = l;
            NC.W = IG.graph;
            NC.n = IG.n;
            NC.eps = eps;
        end
 
        function K = normalizedCutIntoKParts(NC, k)
            D=zeros(NC.n, NC.n);
            s=sum(NC.W,2);

            % the diagonal matrix for computing the laplacian matrix
            for i=1:NC.n
                 D(i,i)=s(i);
            end

            A=zeros(NC.n, NC.n);
            A=(D-W); % A is the laplacian matrix

            %  vt has the eigen vectors corresponding to eigen values in vl
            %  other eigs / eig functions in matlab can be used but I'm using the
            %  function to compute the 5 smallest eigenvectors
            [vt,vl]=eigs(A,D,5,'sm');
        end
        
        function K = recursiveNC(NC, W, step, A, K)
            if step == 0
                [r, c] = size(K);
                K(:, c+1) = transpose(A);
                return;
            end
            D = spdiags(sum(W, 2), [0], NC.n, NC.n);
            D2 = sum(W, 2);
            % D2 is D^(-1/2) in the paper
            D2 = spdiags(sqrt(1 ./ D2), [0], NC.n, NC.n);
            [V, E] = eigs((D2 * (D-W) * D2)+NC.eps*speye, 2, 'sm');
            %A = D-W;
            %B = D;
            %A = A + NC.eps*speye;
            %[V, E] = eigs(A, B, 2, 'sm');
            %[v,c]=eig(full(A),full(B));
            %[E,P] = sort(real(c),'descend'); % Here I am assuming you know all the eigenvalues have` negative real parts
            %index = P(2);
            %V(:,1) = v(:,index); % corresponding eigenvector
            %V(:,2) = v(:,index); % corresponding eigenvector
            [S, cut] = splitOnEigIn2(NC, V, A);
            Wa = makeGraph(NC, S(1, :));
            Wb = makeGraph(NC, S(2, :));
            K = recursiveNC(NC, Wa, step-1, S(1, :), K);
            K = recursiveNC(NC, Wb, step-1, S(2, :), K);        
        end
        
        function W = makeGraph(NC, A)
            W = NC.W;
            for i=1:NC.n
                if A(1, i) == 0
                    W(i,:) = 0;
                    W(:,i) = 0;
                end
            end
        end
        
        function [S, cut] = splitOnEigIn2(NC, V, previousA)
            % get 2nd smallest eigenvector
            s = V(:, 2);
            maxS = max(s);
            minS = min(s);
            % shift to range in [0, 1]
            s = (s-minS)./(maxS-minS);
            % vector cotaining evenly spaced parts
            L = linspace(0,1,NC.l+2);
            minCut = 10000;
            minCutLocation = 0;
            for i=2:NC.l-1
                A = zeros(1, NC.n);
                B = ones(1, NC.n);
                for j=1:NC.n
                    if previousA(j) == 0
                        A(1, j) = 0;
                        B(1, j) = 0;
                    elseif s(j) < L(i)
                        A(1, j) = 1;
                        B(1, j) = 0;
                    end
                end
                ncut = calculateNormCut(NC, A, B);
                if ncut < minCut
                    minCut = ncut;
                    minCutLocation = L(i);
                end
            end
            A = zeros(1, NC.n);
            B = ones(1, NC.n);
            for j=1:NC.n
                if s(j) < minCutLocation
                    A(1, j) = 1;
                    B(1, j) = 0;
                end
            end
            S = [A; B];
            cut = [minCut, minCut];
        end
        
        function ncut = calculateNormCut(NC, A, B)
            cutAB = calculateCut(NC, A, B);
            assocAV = calculateAssoc(NC, A);
            assocBV = calculateAssoc(NC, B);
            ncut = cutAB/assocAV + cutAB/assocBV;
        end
        
        function cut = calculateCut(NC, A, B)
            cut = 0;
            for i = 1:NC.n
                for j = 1:NC.n
                    if A(1, i) == 1 && B(1, j) == 1
                        cut = cut + NC.W(i,j);
                    end
                end
            end            
        end
        
        function assoc = calculateAssoc(NC, A)
            assoc = 0;
            for i = 1:NC.n
                if A(1, i) == 1
                    assoc = assoc + sum(NC.W(i,:));
                end
            end
        end
    end
    
end

