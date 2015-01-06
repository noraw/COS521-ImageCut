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

	ids = make_ids(memberships{index}, s(1));

end

function [IG, ids] = KargerIter(IG, k, ids)
	s = size(IG);

	terminating_number_vertices = k;
	if s(1) > 3*k
		terminating_number_vertices = s(1) / sqrt(2) + 1;
	end

	while s(1) > terminating_number_vertices
		noSelfLoops = IG - diag(diag(IG));

		total_sum = sum(noSelfLoops(:));
		cumulative_sum = cumsum(noSelfLoops(:));

		% Selecting random edge
		threshold_value = rand() * total_sum;
		i = find(cumulative_sum > threshold_value, 1);

		%Finding coordinates of selected edge
		r = mod(i,s(1));
		c = ceil(i / s(1));
		if(r == 0)
			r = s(1);
		end

	%disp(i)
	%disp(r)
	%disp(c)

		[IG, ids] = contractGraph(noSelfLoops, r, c, ids);

		s = size(IG);

	end % while

	if s(1) > k
		%Recursing
		[IG1 ids1] = KargerIter(IG, k, ids);
		[IG2 ids2] = KargerIter(IG, k, ids);

		%Determining min cut by remaining edges left
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

function [new_graph, ids] = contractGraph(IG, r, c, ids)

	s = size(IG);
	s_new = s-1;

	%disp('coords')
	%disp(r)
	%disp(c)

	ind = ones( s(1), 1 );
	ind = logical(ind);
	ind(r) = 0;
	ind(c) = 0;

	%disp('sizes')
	%disp(s)
	%disp(size(ind))
	%disp(size(ids))

	ids = [ {[ids{not(ind)}]} ids{ind} ];

	new_graph = zeros(s_new);

	new_graph(1,:) = [0  (IG(r,ind) + IG(c,ind))];
	new_graph(:,1) = [0; (IG(ind,r) + IG(ind,c))];

	new_graph(2:end, 2:end) = IG(ind, ind);

end

function ids = make_ids(membership_array, num_vertices)

	ids = zeros(1, num_vertices);

	for i = 1:length(membership_array)

		ids(membership_array{i}) = i;

	end

end