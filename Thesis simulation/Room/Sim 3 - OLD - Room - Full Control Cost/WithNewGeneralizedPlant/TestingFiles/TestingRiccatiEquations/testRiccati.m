tic

[Y,junk,junk2,report2] = care(A'-C2'*D21*B1',C2',B1*B1');
if (report2 == -1 || report2 == -2)
    disp('Error in solving the Riccati');
    exit();
end

riccatiSolutionNormal = Y;

H = [A', -C2'*C2; -B1*B1', -A];
[z,t] = schur(full(H));
n = size(z,1)/2;
X1 = z(1:n,1:n);
X2 = z(n+1:2*n,1:n);
D = ones(n,1);
X = arefact2x_Local(X1,X2,D);

toc