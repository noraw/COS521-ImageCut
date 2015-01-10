
function [ids, value] = KargersMinCut(IG, num_iterations, k)
	% Wrapper function for iterations and recursive process

	s = size(IG);

	% Making initial "cluster groups"
	ids = num2cell(1:s(1));

	% Init 
	% storage for each iteration's output
	final_graphs = zeros([k k num_iterations]);
	memberships = cell(num_iterations, 1);

	for i = 1:num_iterations
	
		% Each iteration returns a sparse graph and combined cluster groups
		[final_graph membership] = KargerIter(IG, k, ids)

		% In order to store the sparse graphs, it's sometimes
		%  necessary to get rid of any disconnected nodes
		full_final = full(final_graph);
		full_final(sum(full_final) == 0,:) = [];
		full_final(:,sum(full_final) == 0) = [];

		% Storing output
		final_graphs(:,:,i) = full_final;
		memberships{i} = membership;

	end

	% Determining best solution from all iterations
	cut_edges = sum(sum(final_graphs)) / 2;
	[value index] = min(cut_edges(:));

	% Changing output format of cluster groups
	% disp(memberships{index}) % Debug output
	ids = format_ids(memberships{index}, k, s(1));

end

function [IG, ids] = KargerIter(IG, k, ids)
	s = size(IG);

	terminating_number_vertices = k;
	% Figuring out how many nodes are still connected
	%  to something else within a sparse matrix
	num_nodes_left = nnl(IG);

	if num_nodes_left > 3*k
		terminating_number_vertices = num_nodes_left / sqrt(2) + 1;
	end

	while num_nodes_left > terminating_number_vertices

		% Self loops aren't allowed for Kargers
		%  (otherwise you could join a node to itself and throw off
		%   success probabilities)
		noSelfLoops = IG - diag(diag(IG));

		%disp('selecting edge') %Debug output
		[r,c] = select_random_edge(noSelfLoops);

		%disp('contracting graph') %Debug output
		[IG, ids] = contractGraph(noSelfLoops, r, c, ids);

		num_nodes_left = nnl(IG);
		disp('current graph size: ')
		disp(num_nodes_left)

	end % while

	if num_nodes_left > k
		%Recursing
		[IG1 ids1] = KargerIter(IG, k, ids)
		[IG2 ids2] = KargerIter(IG, k, ids)

		%Determining min cut by number of cut edges
		sum1 = sum(sum(IG1));
		sum2 = sum(sum(IG2));

		if sum1 < sum2
			IG = IG1;
			ids = ids1;
		else
			IG = IG2;
			ids = ids2;
		end % sum if

	else
		% Making sure each cluster returned is connected to the graph
		[i,j,s] = find(IG);
		% IG = sparse(i,j,s); % Don't think this is necessary anymore
		ids = {ids{unique(i)}};

	end % recursion if

end

function num_nodes_left = nnl(sparse_graph)

	[i,j,s] = find(sparse_graph);
	num_nodes_left = length(unique(i));

end

function [i,j] = select_random_edge(graph)

	[ii,jj,ss] = find(graph);

	total_sum = sum(ss);
	threshold_value = rand() * total_sum;

	index = 0;
	while threshold_value > 0

		index = index + 1;
		threshold_value = threshold_value - ss(index);

	end

	i = ii(index);
	j = jj(index);

end

function [new_graph, ids] = contractGraph(graph, r, c, ids)

	s = size(graph);
	[i,j,values] = find(graph);

	%disp('making new ids') % Debug output
	ind = ones( s(1), 1 );
	ind = logical(ind);
	ind(r) = 0;
	ind(c) = 0;

	% Making a new cell array of cluster membership
	% (with the newest merger in the first slot)
	ids = [ {[ids{not(ind)}]} ids{ind} ];

	% Combining the indices of the selected edge, and sorting them
	%  in line with the new ids (new merger first, everything else shifted down)
	%disp('combine_indices')
	[i,j] = combine_indices(r,c, i,j);

	% Summing duplicate entries
	%disp('consolidating')
	[i,j,values] = consolidate_combined_edges(i,j,values);

	% Creating new sparse graph
	%disp('creating new graph')
	new_graph = sparse(i,j,values);

	% Removing self loop
	new_graph(1,1) = 0;

end

function [i,j] = combine_indices(index1, index2, i,j)

	% Combining indices 1 and 2 into 'node 0'
	i(i == index1) = 0;
	j(j == index1) = 0;

	% Keeping other indices consistent by filling the hole left
	%  by index 1 (will do the same below for 2)
	i(i > index1) = i(i > index1) - 1;
	j(j > index1) = j(j > index1) - 1;

	% Keeping track of what index2 should be now
	if index2 > index1
		index2 = index2-1;
	end

	% Same as above
	i(i == index2) = 0;
	j(j == index2) = 0;

	i(i > index2) = i(i > index2) - 1;
	j(j > index2) = j(j > index2) - 1;

	% r -> 1, c -> 1, everything else shifts up one
	% in line with the ids
	i = i + 1;
	j = j + 1;

end

function [i,j,values] = consolidate_combined_edges(i,j,values)

	paired_indices = [i j];

	s = size(paired_indices);

	% Matching up potential duplicates, and storing where these
	%  came from within locations
	[sorted_paired_indices locations] = sortrows(paired_indices);

	% Comparing each row to it's following row
	next_rows = sorted_paired_indices(2:end, :);
	next_rows = [next_rows; 0 0];
	comparisons = sorted_paired_indices - next_rows;

	% The duplicates are where both indices are 0
	%  Using the min because the rows are sorted
	%  => other comparisons will yield a negative value
	%  (aside from the last one, which will always be positive)
	duplicate_sorted_indices = find(min(comparisons,[],2) == 0);

	% Storing the original location of each pair of duplicates 
	%  (each pair stored only once)
	duplicates = [locations(duplicate_sorted_indices) locations(duplicate_sorted_indices+1)];

	if length(duplicates > 0)
		% Summing duplicate entries within first slot
		values(duplicates(:,1)) = values(duplicates(:,1)) + values(duplicates(:,2));

		% Removing second duplicate entry from all lists
		i(duplicates(:,2)) = [];
		j(duplicates(:,2)) = [];
		values(duplicates(:,2)) = [];
	end

end

function ids = format_ids(membership_array, k, num_nodes)

	ids = zeros(num_nodes, k);

	for i = 1:k
		ids(membership_array{i}, i) = 1;
	end

end


