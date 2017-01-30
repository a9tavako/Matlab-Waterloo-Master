clf;clc;clear;
Length            = 5; %0.4573        ;%length
NumNode           = 30  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.3 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1          ;%state weight in the cost function
ControlWeight     = 1          ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1000       ;
DisturbanceMean   = Length*0.25;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;        

L = Length;
sensorLoc = SenLoc;
sensorWidth = SenWidth;
DisturbanceWidth = DisturbanceVar;
dx   = 0.001;
x    = 0:dx:L;

a = zeros(1,NumNode);
for n=1:NumNode
    a(n) = (sqrt(2*L)/(2*sensorWidth*n*pi))*(cos((n*pi/L)*(sensorLoc-sensorWidth)) - cos((n*pi/L)*(sensorLoc+sensorWidth)));
end
sensor = zeros(1,length(x));
for n=1:NumNode
    sensor = sensor + a(n)*sqrt(2/L)*sin((n*pi/L)*x);
end

Disutrbance    = exp((-1/2)*((x-DisturbanceMean)/DisturbanceWidth).^2); %Disturbance a normalized gaussian function
Disutrbance    = 9*Disutrbance/(norm(Disutrbance)*sqrt(dx));          %Normalizing L2 norm to one

Disturbance_fourier = zeros(NumNode,1);  %finding the fourier coefficients of f
for i=1:NumNode
    y = sqrt(2/L)*sin(i*pi*x/L);
    %y = y/(norm(y)*sqrt(dx));%normalizing L2 norm to one
    Disturbance_fourier(i) = Disutrbance*y'*dx;
end

Disutrbance = zeros(1,length(x));
for n=1:NumNode
    Disutrbance = Disutrbance + Disturbance_fourier(n)*sqrt(2/L)*sin((n*pi/L)*x);
end

figure(2)
hold;
plot(x,sensor,'LineWidth',3);
plot(x,Disutrbance,'LineWidth',3);
hold off;
xlabel('position on Beam');
%ylabel('Y');
title('Approximate Shape with 30 Modes');
axis([0 5 -2 14])
set(findall(gcf,'type','text'),'fontSize',24);
