function [A,B,C] = beamMatrixABC(Length,NumNode,Stiffness,MassDensity,DampingVis,DampingKV,ActLoc,SenLoc,ActWidth,SenWidth)
%@Inputs:length of the beam, number of nodes, damping costant and
%locations of a point actuator and a sensor
%&Output: Matrices A,B,C for the equation dot{x} = Ax+ Bu


L  = Length; % length
N  = NumNode; % approximation order, number of modes
EI = Stiffness;
Mu = MassDensity;
Cv = DampingVis;
Cd = DampingKV;
ActLoc = ActLoc;
senLoc = SenLoc;
Actdx  = ActWidth;
Sendx  = SenWidth;


A   = zeros(2*N,2*N); 
A11 = zeros(N,N);
A12 = eye(N,N);
A21 = diag((1:N).^4)*(-1*EI*pi^4)/(Mu*L^4);
A22 = diag((1:N).^4)*(-1*Cd*pi^4)/(Mu*L^4) + eye(N,N)*(-1*Cv/Mu);
A   = [A11,A12;A21,A22];

%-------------------
B  = zeros(2*N,1); % Matrix B for dot{x} = Ax+Bu, interval actuator
b1 = zeros(N,1);   
b2 = zeros(N,1);
for n=1:N
    b2(n) = (2/(n*pi))*(cos((n*pi/L)*(ActLoc-Actdx)) - cos((n*pi/L)*(ActLoc+Actdx))); 
end
B  = [b1;b2];


%-------------------
C  = zeros(1,2*N); % Matrix C for y = Cx, interval sensor
c1 = zeros(1,N);
for n=1:N
   c1(n) =  (2/(n*pi))*(cos((n*pi/L)*(senLoc-Sendx)) - cos((n*pi/L)*(senLoc+Sendx))); 
end
c2 = zeros(1,N);
C  = [c1,c2];

end