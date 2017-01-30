clear all;clf;clc;


Length            = 1; %0.4573        ;%length
Stiffness         = 1; %0.491      ;
MassDensity       = 1; %  0.093
DampingVis        = 0.00001;%0.0013     ;
DampingKV         = 0*0.0000649;%0.00000000000649  ;%0.0000649 



ActLoc            = Length*0.7 ; 
SenLoc            = Length*0.7 ; %fixed, here only order of approximation is changed.
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1     ;%state weight in the cost function
ControlWeight     = 1     ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1  ;
DisturbanceMean   = Length*0.1;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 40         ;% num of available positions, evenly spaced on th beam, excluding the end points

MinMode = 1;
MaxMode = 9;
RangeOfModes = MaxMode - MinMode;
LowestEigVals = zeros(1,RangeOfModes);
for NumNode=MinMode:MaxMode;        
        [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,Stiffness,MassDensity,DampingVis,DampingKV,...
            ActLoc,SenLoc,ActWidth,SenWidth,...
            StateWeight,ControlWeight, DisturbanceEnergy, DisturbanceMean,DisturbanceVar,DistWeightOnMeasurement);
        ObsGramian = lyap(A',C2'*C2);
        LowestEigVals(NumNode-MinMode+1) = min(eig(ObsGramian));
end

figure(1);
plot(MinMode:MaxMode,LowestEigVals);
xlabel('Number of Modes');
ylabel('Min Eigenvalue of Observ-Gramian');
title('Min Eigenvalue vs Number of Modes');
set(findall(gcf,'type','text'),'fontSize',16);

figure(2);
semilogy(MinMode:MaxMode,LowestEigVals,'*','MarkerSize',10);
set(gca,'FontSize',15);
xlabel('Number of Modes');
ylabel('Min Eigenvalue');
title('Log Scale of Min Eigenvalue vs Number of Modes');
set(findall(gcf,'type','text'),'fontSize',24);
