function [ids, gram_matrix] = SDPCut(similarity_matrix, k)

	if nargin < 2
		k = 2
	end

	s = size(similarity_matrix);

	% Gets rid of disconnected nodes
	disp('forming parsimonious graph...')
	[i,j,values] = find(similarity_matrix);
	[unique_nodes iai ici] = unique(i);
	[unique_nodes iaj icj] = unique(j);
	parsimonious_graph = sparse(ici, icj, values);

	% Defines and runs the SDP
	gram_matrix = run_SDP(parsimonious_graph)

	% Factors the gram matrix into embedded vectors
	embedding = chol(gram_matrix);

	% Clusters the resulting vectors by alignment with random vectors
	ids = randomly_cluster(embedding, k);

	ids = format_ids(ids, 2 ^ k, s(1), unique_nodes);

end

function gram_matrix = run_SDP(similarity_matrix)

	disp('setting up SDP')
	s = size(similarity_matrix);

	cvx_begin SDP

	disp('adding variables...')
	variable gram_matrix(s) semidefinite

	disp('adding constraints...')
	% The variables should form a PSD matrix
	gram_matrix >= 0
%	gram_matrix(:) >= 0
	% Max magnitude of each vector is 1
	diag(gram_matrix) == ones(s(1),1)

	disp('adding objective function...')
	% Objective Function
	maximize (sum(sum(similarity_matrix .* gram_matrix + ...
		(1-similarity_matrix) .* (1-gram_matrix))))

	disp('solving...')
	cvx_end

end

function ids = randomly_cluster(embedding, k)

	s = size(embedding);

	% Finding random points on the unit sphere
	random_vectors = randn([k s(1)]);
	random_vectors = bsxfun(@rdivide,random_vectors,sqrt(sum(random_vectors.^2,2)));

	% Finding which random vector has the largest dot product
	%  with each embedded vector
	positive_dot_product = ((random_vectors * embedding) >= 0)';

	twos = ones(1, k) * 2;
	powers_of_two = (twos.^[0:(k-1)])';

	ids = (positive_dot_product * powers_of_two) + 1;

end

function new_ids = format_ids(ids, k, num_original_nodes, node_ids)

	new_ids = zeros(num_original_nodes, k);

	for i = 1:k	
		new_ids(node_ids,i) = (ids == i);
	end

end
