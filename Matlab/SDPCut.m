function ids = SDPCut(similarity_matrix, k)

	if nargin < 2
		k = 2
	end

	% Defines and runs the SDP
	gram_matrix = run_SDP(similarity_matrix);

	% Factors the gram matrix into embedded vectors
	embedding = chol(gram_matrix);

	% Clusters the resulting vectors by alignment with random vectors
	ids = randomly_cluster(embedding, k);

end

function gram_matrix = run_SDP(similarity_matrix)

	s = size(similarity_matrix);

	cvx_begin SDP

	variables gram_matrix(s) semidefinite

	% Max magnitude of each vector is 1
	gram_matrix >= 0
	diag(gram_matrix) == ones(s(1),1)

	% Objective Function
	maximize (sum(sum(similarity_matrix .* gram_matrix + ...
		(1-similarity_matrix) .* (1-gram_matrix))))

	cvx_end

end

function ids = randomly_cluster(embedding, k)

	s = size(embedding);

	% Finding random points on the unit sphere
	random_vectors = randn([k s(1)]);
	random_vectors = bsxfun(@rdivide,random_vectors,sqrt(sum(random_vectors.^2,2)));

	% Finding which random vector has the largest dot product
	%  with each embedded vector
	[m, ids] = max(random_vectors * embedding);

end
