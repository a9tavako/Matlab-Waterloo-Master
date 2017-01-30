function [optimalH2Norm,X,Y] =   calculateOptimalH2OutputFeedbackCost(A,B1,B2,C1,C2,D11,D12,D21,D22)

%Solve Riccati eqn based on page 377 and 385 of zhou optimal and robust
%control book
%The Control Riccati
[X,junk,junk2,report1] = care(A,B2,C1'*C1);
if (report1 == -1 || report1 == -2)
    disp('Error in solving the Riccati');
    exit();
end
%Observer Riccati
[Y,junk,junk2,report2] = care(A',C2',B1*B1');
if (report2 == -1 || report2 == -2)
    disp('Error in solving the Riccati');
    exit();
end

%save('Y','Y');
%save('X','X');
%trace(Y)
optimalH2Norm = sqrt( trace(B1'*X*B1) + trace(B2'*X*Y*X*B2) );
%optimalH2Norm = sqrt( trace(C1*Y*C1') + trace(C2*Y*X*Y*C2') );

%A'*X+X*A -X*(B2 *B2')*X + C1'*C1 ;
%A*Y +Y*A'-Y*(C2'*C2 )*Y + B1 *B1';
end