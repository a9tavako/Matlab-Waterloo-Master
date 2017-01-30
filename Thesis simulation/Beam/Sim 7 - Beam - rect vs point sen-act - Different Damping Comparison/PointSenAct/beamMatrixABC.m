function [A,B,C] = beamMatrixABC(Length,NumNode,damping,ActLoc,SenLoc)
%@Inputs:length of the beam, number of nodes, damping costant and
%locations of a point actuator and a sensor
%&Output: Matrices A,B,C for the equation dot{x} = Ax+ Bu

% damping = 0.001;
% SenLoc = 0.3*L; % sensor location
% ActLoc = 0.4*L; % actuator location

L = Length; % length
N = NumNode; % approximation order, number of modes

A   = zeros(2*N,2*N); %
A11 = zeros(N,N);
A12 = eye(N,N);
A21 = diag(-(pi/L)^4*(1:N).^4);
A22 = diag(-damping*(pi/L)^4*(1:N).^4);
A   = [A11,A12;A21,A22];


B  = zeros(2*N,1); % Matrix B for dot{x} = Ax+Bu, point actuator
b1 = zeros(N,1);
b2 = (2/L)*sin((pi*ActLoc/L)*(1:N))';
B  = [b1;b2];


C  = zeros(1,2*N); % Matrix C for y = Cx, the point sensor
c1 = sin((1:N)*pi*SenLoc/L);
c2 = zeros(1,N);
C  = [c1,c2];

end