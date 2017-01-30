function [optimalH2Norm,X,Y] =   calculateOptimalH2OutputFeedbackCost(A,B1,B2,C1,C2,D11,D12,D21,D22)
[X,junk,junk2,report1] = care(A,B2,C1'*C1);
if (report1 == -1 || report1 == -2)
    disp('Error in solving the Riccati');
    exit();
end

[Y,junk,junk2,report2] = care(A',C2',B1*B1');
if (report2 == -1 || report2 == -2)
    disp('Error in solving the Riccati');
    exit();
end

optimalH2Norm = sqrt( trace(B1'*X*B1) + trace(B2'*X*Y*X*B2) );
%optimalH2Norm = sqrt( trace(C1*Y*C1') + trace(C2*Y*X*Y*C2') );
end