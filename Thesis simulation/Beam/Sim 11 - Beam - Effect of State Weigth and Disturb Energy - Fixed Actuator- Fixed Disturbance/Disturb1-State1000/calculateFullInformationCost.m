function optimalH2Norm =   calculateFullInformationCost(A,B1,B2,C1,C2,D11,D12,D21,D22)

%Solve Riccati eqn based on page 377 and 385 of zhou optimal and robust
%control book
%The Control Riccati
[X,junk,junk2,report1] = care(A,B2,C1'*C1);
if (report1 == -1 || report1 == -2)
    disp('Error in solving the Riccati');
    exit();
end
F = -B2'*X;
A_F = A+ B2*F;
C_F = C1 + D12*F;
G_c = ss(A_F,B1,C_F,0);

% %Observer Riccati
% [Y,junk,junk2,report2] = care(A'-C2'*D21*B1',C2',B1*B1');
% if (report2 == -1 || report2 == -2)
%     disp('Error in solving the Riccati');
%     exit();
% end
% L = -(Y*C2'+B1*D21');
% A_L = A+ L*C2;
% B_L = B1 + L*D21;
% G_f = ss(A_L,B_L,F,0);

%optimalH2Norm =  sqrt(norm(G_c,2)^2);% + norm(G_f,2)^2);
optimalH2Norm = sqrt(trace(B1'*X*B1));
end