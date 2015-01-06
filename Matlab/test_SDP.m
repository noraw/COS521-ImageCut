
grades = rand(10,10);

%Making the grades matrix symmetric
grades = grades + grades';
grades = grades ./ max(max(grades))

s = size(grades);

cvx_begin SDP

variables dot_products(s)

dot_products == semidefinite(s(1))
diag(dot_products) == ones(s(1),1)

maximize (sum(sum(grades .* dot_products + (1-grades) .* (1-dot_products))))

cvx_end

dot_products

