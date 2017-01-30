function optimalH2Norm =   calculateFullControlCost(A,B1,B2,C1,C2,D11,D12,D21,D22)

[Y,junk,junk2,report2] = care(A'-C2'*D21*B1',C2',B1*B1');
if (report2 == -1 || report2 == -2)
    disp('Error in solving the Riccati');
    exit();
end

optimalH2Norm = sqrt(trace(C1*Y*C1'));
end