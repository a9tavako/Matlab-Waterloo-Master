clc;clear;
Length            = 5; %0.4573        ;%length
NumNode           = 30  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.75 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1          ;%state weight in the cost function
ControlStrengh    = 10         ;%ControlStrengh is the norm of B2
DisturbanceEnergy = 10         ;
DisturbanceMean   = Length*0.25;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;        

L = Length;
sensorLoc = SenLoc;
sensorWidth = SenWidth;
DisturbanceWidth = DisturbanceVar;
dx   = 0.0001;
x    = 0:dx:L;


actuator  = zeros(1,length(x));
I1 = floor((ActWidth/Length)*length(x));
I2 = floor(length(x)*ActLoc/Length);
actuator(I2-I1:I2+I1) = 1/(2*ActWidth);

Disutrbance    = 10*exp((-1/2)*((x-DisturbanceMean)/DisturbanceWidth).^2); %Disturbance a normalized gaussian function


figure(2);
clf;
hold;
plot(x,actuator,'LineWidth',3)
plot(x,Disutrbance,'LineWidth',3);
hold off;
xlabel('position on beam');
%ylabel('Y');
title('Disturbance and Actuator Shape');
axis([0 5 0 12])
set(findall(gcf,'type','text'),'fontSize',24);
