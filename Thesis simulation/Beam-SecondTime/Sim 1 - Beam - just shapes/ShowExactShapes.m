clc;clear;
Length            = 5; %0.4573        ;%length
NumNode           = 10000  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.8 ; 
SenLoc            = Length*0.1 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1          ;%state weight in the cost function
ControlWeight     = 1          ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1000          ;
DisturbanceMean   = Length*0.5 ;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;        

L = Length;
sensorLoc = SenLoc;
sensorWidth = SenWidth;
DisturbanceWidth = DisturbanceVar;
dx   = 0.001;
x    = 0:dx:L;


sensor  = zeros(1,length(x));
I1 = floor((SenWidth/Length)*length(x));
I2 = floor(length(x)*SenLoc/Length);
sensor(I2-I1:I2+I1) = 1/(2*SenWidth);

actuator  = zeros(1,length(x));
I1 = floor((ActWidth/Length)*length(x));
I2 = floor(length(x)*ActLoc/Length);
actuator(I2-I1:I2+I1) = 1/(2*ActWidth);

Disutrbance    = 10*exp((-1/2)*((x-DisturbanceMean)/DisturbanceWidth).^2); %Disturbance a normalized gaussian function
%Disutrbance    = 10*Disutrbance/(norm(Disutrbance)*sqrt(dx));          %Normalizing L2 norm to one

factor = 10;
x1 = SenLoc + 0.1;
y1 = 0.525*factor;
d1 = 0.2;
d2 = 0.1;
d3 = 0.05;
h1 = 0.05*factor;
h2 = 0.05*factor;
starXCord = [x1,x1,x1+d1,x1+d1-d3,x1+d1,x1+d1+d2,x1+d1,x1+d1-d3,x1+d1];
starYCord = [y1,y1+h1,y1+h1,y1+h1+h2,y1+h1+h2,y1+h1/2,y1-h2,y1-h2,y1];


clf;
hold on;
plot(x,sensor,'LineWidth',3);
plot(x,actuator,'LineWidth',3);
plot(x,Disutrbance,'LineWidth',3);
text(DisturbanceMean-0.08,   11.1, 'D', 'Color', [0,0,0],'FontSize', 10,'FontWeight', 'bold');
text(ActLoc-0.08,  11.1, 'A', 'Color', [0,0,0],'FontSize', 18,'FontWeight', 'bold');
text(SenLoc-0.08, 11.1, 'S', 'Color', [0,0,0],'FontSize', 18,'FontWeight', 'bold');
fill(starXCord,starYCord,'r');
hold off;
axis([0,5,0,14]);
xlabel('position on Beam');
%ylabel*'Y');
title('Sensor, Disturbance and Actuator');
set(findall(gca,'type','text'),'fontSize',30);
