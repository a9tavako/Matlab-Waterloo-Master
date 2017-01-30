Length            = 5; %0.4573        ;%length
NumNode           = 2000  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.1 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1000       ;%state weight in the cost function
ControlWeight     = 1          ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1000       ;
DisturbanceMean   = Length*0.25 ;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100         ;% num of available positions, evenly spaced on th beam, excluding the end points



[A,B2,C2] = beamMatrixABC(Length,NumNode,Stiffness,MassDensity,...
                          DampingVis,DampingKV,...
                          ActLoc,SenLoc,ActWidth,SenWidth);
                      
dx = 0.5;
EI = Stiffness;
mu = MassDensity;
L = Length;
x = 0:dx:L;
n = 1;
f = exp(n*pi*x/L).*sin(n*pi*x/L);

[V,D] = eig(A);
%min(abs(imag(V)))
%max(abs(imag(V)))

%min(abs(real(V)))
%max(abs(real(V)))
