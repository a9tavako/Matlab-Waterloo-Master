function optimalH2Norm =   calculateOptimalH2OutputFeedbackCost(A,B1,B2,C1,C2,D11,D12,D21,D22)

%Solve Riccati eqn based on page 377 and 385 of zhou optimal and robust
%control book
%The Control Riccati
[X,junk,junk2,report1] = care(A,B2,C1'*C1);
if (report1 == -1 || report1 == -2)
    disp('Error in solving the Riccati');
    exit();
end


%Observer Riccati
[Y,junk,junk2,report2] = care(A'-C2'*D21*B1',C2',B1*B1');
if (report2 == -1 || report2 == -2)
    disp('Error in solving the Riccati');
    exit();
end


optimalH2Norm = sqrt(tr(B1'*X*B1) + tr(B2'*X*Y*X*B2));

end