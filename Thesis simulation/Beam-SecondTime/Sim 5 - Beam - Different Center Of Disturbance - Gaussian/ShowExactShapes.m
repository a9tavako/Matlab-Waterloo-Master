clc;clear;
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
DisturbanceMean   = Length*0.75;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;        

L = Length;
sensorLoc = SenLoc;
sensorWidth = SenWidth;
DisturbanceWidth = DisturbanceVar;
dx   = 0.0001;
x    = 0:dx:L;


sensor  = zeros(1,length(x));
I1 = floor((SenWidth/Length)*length(x));
I2 = floor(length(x)*SenLoc/Length);
sensor(I2-I1:I2+I1) = 1/(2*SenWidth);

Disutrbance    = 10*exp((-1/2)*((x-DisturbanceMean)/DisturbanceWidth).^2); %Disturbance a normalized gaussian function


figure(2);
clf;
hold;
%plot(x,sensor,'LineWidth',3)
plot(x,Disutrbance,'LineWidth',3);
hold off;
xlabel('position on beam');
%ylabel('Y');
title('Disturbance Shape');
axis([0 5 0 12])
set(findall(gcf,'type','text'),'fontSize',24);
