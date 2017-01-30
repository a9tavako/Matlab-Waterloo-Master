function X = arefact2x_Local(X1,X2,D)
% Computes Riccati solution X = D*(X2/X1)*D from X1,X2,D.
   % Solve X * X1 = X2
   [l,u,p] = lu(X1,'vector');
   CondX1 = rcond(u);
%    if CondX1>eps,
      % Solve for X based on LU decomposition
      X(:,p) = (X2/u)/l;
      % Symmetrize
      X = (X+X')/2;
      % Factor in scaling D (X -> DXD)
      X = lrscale(X,D,D);
%    else
%       % X1 is singular
%       X = [];  Report = -2;
%    end
end

      
