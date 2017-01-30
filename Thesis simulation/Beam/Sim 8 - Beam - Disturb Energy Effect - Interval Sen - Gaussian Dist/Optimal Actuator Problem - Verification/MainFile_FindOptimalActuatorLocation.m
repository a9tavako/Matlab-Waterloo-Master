clear all;clf;
Length            = 4; %0.4573        ;%length
NumNode           = 30  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
%ActLoc           = Length*0.3 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1000       ;%state weight in the cost function
ControlWeight     = 1          ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1          ;
DisturbanceMean   = Length*0.25 ;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100         ;% num of available positions, evenly spaced on th beam, excluding the end points


h2scores = zeros(1,NumLoc);
for i=1:NumLoc
    ActLoc = Length*i/(NumLoc+1);
    
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,Stiffness,MassDensity,DampingVis,DampingKV,...
        ActLoc,SenLoc,ActWidth,SenWidth,...
        StateWeight,ControlWeight, DisturbanceEnergy, DisturbanceMean,DisturbanceVar,DistWeightOnMeasurement);
    
    h2scores(i)                     = calculateFullInformationCost(A,B1,B2,C1,C2,D11,D12,D21,D22);
end


plot(Length*(1:NumLoc)/(NumLoc+1), h2scores);
xlabel('Actuator Position on Beam');
ylabel('H_2 Cost Full Information Cost');
title('H_2 Full Info Cost vs Act Pos');
set(findall(gcf,'type','text'),'fontSize',16);
