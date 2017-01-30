n = 101;

s = 0:0.01:1;
t = 0:0.01:1;

g = zeros(n,n);

for i=1:n
    for j=1:n
        if j <= i
            g(i,j) = s(j)*(1-t(i));
        end
        if i < j
            g(i,j) = t(i)*(1-s(j));
        end
    end
end

mesh(g)