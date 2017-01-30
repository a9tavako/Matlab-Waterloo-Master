function [optimalH2Norm,X] =   calculateOptimalH2ControlCost(A,B1,B2,C1,C2,D11,D12,D21,D22)

%The Control Riccati
[X,junk,junk2,report1] = care(A,B2,C1'*C1);
if (report1 == -1 || report1 == -2)
    disp('Error in solving the Riccati');
    exit();
end

optimalH2Norm = sqrt( trace(B1'*X*B1));
end