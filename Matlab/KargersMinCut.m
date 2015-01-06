function [IG, ids] = KargersMinCut(IG, ids)

	s = size(IG);

	if nargin < 2
		ids = num2cell(1:s(1));
	end

	terminating_number_vertices = 2;
	if s(1) > 6
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

	if s(1) > 2
		%Recursing
		[IG1 ids1] = KargersMinCut(IG, ids);
		[IG2 ids2] = KargersMinCut(IG, ids);

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
