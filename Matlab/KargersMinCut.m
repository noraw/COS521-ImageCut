function [ids, value] = KargersMinCut(IG, num_iterations, k)

	s = size(IG);

	ids = num2cell(1:s(1));

	final_graphs = zeros([k k num_iterations]);
	memberships = cell(num_iterations, 1);

	for i = 1:num_iterations
		
		[final_graph membership] = KargerIter(IG, k, ids);

		final_graphs(:,:,i) = final_graph;
		memberships{i} = membership;

	end

	cut_edges = sum(sum(final_graphs)) / 2;
	[value index] = min(cut_edges(:));

	ids = format_ids(memberships{index}, s(1));

end

function [IG, ids] = KargerIter(IG, k, ids)
	s = size(IG);

	terminating_number_vertices = k;
	if s(1) > 3*k
		terminating_number_vertices = s(1) / sqrt(2) + 1;
	end

	while s(1) > terminating_number_vertices
		noSelfLoops = IG - diag(diag(IG));


		r,c = select_random_edge(noSelfLoops);

		[IG, ids] = contractGraph(noSelfLoops, r, c, ids);

		s = size(IG);

	end % while

	if s(1) > k
		%Recursing
		[IG1 ids1] = KargerIter(IG, k, ids);
		[IG2 ids2] = KargerIter(IG, k, ids);

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
	end % recursion if

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
	s_new = s-1;

	ind = ones( s(1), 1 );
	ind = logical(ind);
	ind(r) = 0;
	ind(c) = 0;

	ids = [ {[ids{not(ind)}]} ids{ind} ];

	% Combining the indices of the selected edge, and sorting them
	%  in line with the new ids
	[i,j,values] = combine_indices(r,c, i,j);

	% Summing duplicate entries
	[i,j,values] = consolidate_combined_edges(i,j,values);

	% Creating new sparse graph
	new_graph = sparse(i,j,values, s(1),s(2));

	% Removing self loop
	new_graph(1,1) = 0;

end

function [i,j,values] = combine_indices(index1, index2, i,j)

	i(i == index1) = 0;
	j(j == index1) = 0;

	i(i > index1) = i(i > index1) - 1;
	j(j > index1) = j(j > index1) - 1;

	if index2 > index1
		index2 = index2-1;
	end

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

	[sorted_paired_indices locations] = sortrows(paired_indices);
	duplicates = [];

	for row = 1:(s(1) - 1)

		if min(sorted_paired_indices(row,:) == sorted_paired_indices(row+1,:))
			row_locations = [locations(row) locations(row+1)];
			duplicates = [duplicates; row_locations];
		end

	end

	% Summing duplicate entry duplicates within first slot
	values(duplicates(:,1)) = values(duplicates(:,1)) + values(duplicates(:,2));
	% Removing second duplicate entry from all lists
	i(duplicates(:,2)) = [];
	j(duplicates(:,2)) = [];
	values(duplicates(:,2)) = [];

end

function ids = format_ids(membership_array, num_vertices)

	ids = zeros(1, num_vertices);

	for i = 1:length(membership_array)

		ids(membership_array{i}) = i;

	end

end