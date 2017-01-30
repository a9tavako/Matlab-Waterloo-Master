clear all;clf;
Length            = 5; %0.4573        ;%length
%NumNode           = 30  ; looping over multiple values
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.7 ; 
%SenLoc           = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1     ;%state weight in the cost function
ControlWeight     = 1     ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 1000  ;
DisturbanceMean   = Length*0.1;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 40         ;% num of available positions, evenly spaced on th beam, excluding the end points

MaxMode = 7;
MinMode = 1;
RangeOfModes = MaxMode - MinMode;
h2scores = zeros(RangeOfModes,NumLoc);
hold on
for NumNode=MinMode:MaxMode;
    for i=1:NumLoc
        SenLoc = Length*i/(NumLoc+1);
        
        [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,Stiffness,MassDensity,DampingVis,DampingKV,...
            ActLoc,SenLoc,ActWidth,SenWidth,...
            StateWeight,ControlWeight, DisturbanceEnergy, DisturbanceMean,DisturbanceVar,DistWeightOnMeasurement);
        
        h2scores(NumNode,i)                     = calculateFullControlCost(A,B1,B2,C1,C2,D11,D12,D21,D22);
    end
end
hold off;
n = NumLoc;
plot((1:n)/(n+1),h2scores(1,:),'k-o', ...
     (1:n)/(n+1),h2scores(2,:),'b--', ...
     (1:n)/(n+1),h2scores(3,:),'k--', ...
     (1:n)/(n+1),h2scores(4,:),'r--', ...
     (1:n)/(n+1),h2scores(5,:),'b', ...
     (1:n)/(n+1),h2scores(6,:),'k', ...
     (1:n)/(n+1),h2scores(7,:),'r' ... 
     );

xlabel('Sensor Position on Beam');
ylabel('H_2 Full Control Cost');
title('Multiple Order of Approximation N = 1 to 7 ');
h_legend = legend('N=1','N=2','N=3','N=4','N=5','N=6','N=7','Location','EastOutside');
set(findall(gcf,'type','text'),'fontSize',24);
