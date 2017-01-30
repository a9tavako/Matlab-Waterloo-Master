function [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlantHacked(Length,NumNode,Stiffness,Mu,KVDamp,VisDamp,...
                                                                ActLoc,SenLoc,...
                                                                StateWeight,ControlWeight,StateWeightOnSensor,...
                                                                DisturbanceMean,DisturbanceVar,DisturbancePower,...
                                                                DisturbanceWeightOnMeasurement)
N = NumNode;
L = Length;

[A,B2,C2] = beamMatrixABCHacked(Length,NumNode,Stiffness,Mu,KVDamp,VisDamp,ActLoc,SenLoc,StateWeightOnSensor);

%----------- B1 the spatial part of the disturbance
B1   = zeros(2*N,1);    
mean  = DisturbanceMean; %variance of the gaussian function for disturbance
sig = DisturbanceVar;  %mean of the gaussian function
dx   = 0.001;
x    = 0:dx:L;
f    = exp((-1/2)*((x-mean)/sig).^2); %Disturbance a normalized gaussian function
f    = f/(norm(f)*sqrt(dx));          %Normalizing L2 norm to one

f_fourier = zeros(N,1);  %finding the fourier coefficients of f
for i=1:N
    y = sin(i*pi*x/L);
    y = y/(norm(y)*sqrt(dx));%normalizing L2 norm to one
    f_fourier(i) = f*y'*dx;
end

b1 = zeros(N,1);
b2 = f_fourier;
B1 = (1/Mu)*[b1;b2];
B1 = B1*DisturbancePower;


%----------- C1 the state weight in the cost function
C1          = zeros(N+1,2*N);
c1          = eye(N,N)*StateWeight;
C1(1:N,1:N) = c1;

%----------- Matrices D11,D12,D21,D22
D11        = zeros(N+1,1); %can be set to zero for H2 control
D12        = zeros(N+1,1); %weight on the control signal in the cost function
D12(N+1,1) = ControlWeight;
D21        = eye(1,1);  %must have full row rank
D21        = D21*DisturbanceWeightOnMeasurement;
D22        = zeros(1,1);%can be set to zero for H2 control
end