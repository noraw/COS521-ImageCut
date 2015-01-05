function KargersMinCut(IG, ids)


	s = size(IG);

	if nargin < 2
		ids = num2cell(1:s(1));
	end

	% terminating_number_vertices = 2;
	% if s(1) > 6
	% 	terminating_number_vertices = s(1) / sqrt(2) + 1;
	% end

	% while s(1) > terminating_number_vertices
	noSelfLoops = IG - diag(diag(IG));

	total_sum = sum(IG(:));
	cumulative_sum = cumsum(IG(:));

	% Selecting random edge
	threshold_value = random() * total_sum;
	[r,c] = find(cumulative_sum > threshold_value, 1);

	[IG, ids] = contractGraph(IG, r, c, ids)

end

function [new_graph, ids] = contractGraph(IG, r, c, ids)

	s = size(IG);
	s = s-1;

	ind = ones( length(IG), 1 );
	ind = logical(ind);
	ind(r) = 0;
	ind(c) = 0;

	ids = [ {[ids{not(ind)}]} ids{ind} ];

	new_graph = zeros(s);

	new_graph(1,:) = [0  (IG(r,ind) + IG(c,ind))];
	new_graph(:,1) = [0; (IG(ind,r) + IG(ind,c))];

	new_graph(2:end, 2:end) = IG(ind, ind);
