clf;clc;clear;
Length            = 5; %0.4573        ;%length
NumNode           = 10000  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.5 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1          ;%state weight in the cost function
ControlWeight     = 1          ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1000          ;
DisturbanceMean   = Length*0.25 ;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;        

L = Length;
DisturbanceWidth = DisturbanceVar;
dx   = 0.001;
x    = 0:dx:L;

a = zeros(1,NumNode);
for n=1:NumNode
    a(n) = (2/(n*pi))*(cos((n*pi/L)*(ActLoc-ActWidth)) - cos((n*pi/L)*(ActLoc+ActWidth)));
end
sensor = zeros(1,length(x));
for n=1:NumNode
    sensor = sensor + a(n)*sin((n*pi/L)*x);
end

Disutrbance    = exp((-1/2)*((x-DisturbanceMean)/DisturbanceWidth).^2); %Disturbance a normalized gaussian function
Disutrbance    = Disutrbance/(norm(Disutrbance)*sqrt(dx));          %Normalizing L2 norm to one


hold;
plot(x,sensor,'LineWidth',3)
plot(x,Disutrbance,'LineWidth',3);
hold off;
xlabel('X Position on Beam');
ylabel('Y');
title('Shape of Actuator and Disturbance');
set(findall(gcf,'type','text'),'fontSize',24);
