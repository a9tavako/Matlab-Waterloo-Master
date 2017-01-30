%Observer Riccati
% [Y,junk,junk2,report2] = care(A',C2',B1*B1');
% if (report2 == -1 || report2 == -2)
%     disp('Error in solving the Riccati');
%     exit();
% end
% 
% result1 = sqrt(trace(C1*Y*C1'));

% X1 = care(A,B2,C1'*C1);
% ans1 = sqrt(trace(B1'*X1*B1));
%tic
%X = solveRiccatiWithLyaPack(A,C2',B1');
%toc
tic
%result = (-1)*M\K;
result = care(A',C2',B1*B1');
toc
%result = A'*X + X*A - X*(B*B')*X + C'*C;

%result = A*X + X*A' - X*(C2'*C2)*X + B1*B1';
%max(max(result))

%X = care(A,B,C'*C);
%remainder = A'*X1 + X1*A - X1*B2*B2'*X1 + C1'*C1;

% R = D12'*D12;
% n = size(A,1);
% S = zeros(n,1);
% K = full(K);
% M = full(M);
% X2 = care(-K,M*B2,C1'*C1,R,S,M);
% ans2 = sqrt(trace(B1'*X2*B1));
% toc


