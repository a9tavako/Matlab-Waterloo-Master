clear all;clf;
Length          = 1     ;%length
NumNode         = 10         ;%number of modes
Stiffness       = 0.491      ;%stiffness is EI in the Euler-Bernoulli
Mu              = 0.093      ;%mass density mu
KVDamp          = 0.0000649  ;%Kelvin-Voigt damping
VisDamp         = 0.0013     ;%viscous damping
ActLoc          = 0.3*Length ;
%SenLoc         = varies on the beam, in a search for optimal place
StateWeight     = 1000       ;%state weight in the cost function
ControlWeight   = 1          ;%control weight in the cost function
DisturbanceMean = Length*0.2 ;%disturbance is a gaussian function 
DisturbanceVar  = Length*0.05; 
DisturbancePower= 7000       ;%norm of B1 
DisturbanceWeightOnMeasurement = 2 ; %norm of D21
StateWeightOnSensor            = 1 ; %norm of C2


NumSenLoc = 50; % num of positions available for sensor, evenly spaced, excluding the end points
costs     = zeros(1,NumSenLoc);

for i=1:NumSenLoc
    SenLoc = Length*i/(NumSenLoc+1);
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlantHacked(Length,NumNode,Stiffness,Mu,KVDamp,VisDamp,...
                                                           ActLoc,SenLoc,...
                                                           StateWeight,ControlWeight,StateWeightOnSensor,...
                                                           DisturbanceMean,DisturbanceVar,...
                                                           DisturbancePower,DisturbanceWeightOnMeasurement);
    %costs(i)                       = calculateH2OptimalCostSensorOnly(A,B1,B2,C1,C2,D11,D12,D21,D22);
    costs(i)                        = calculateH2OptimalCostFull(A,B1,B2,C1,C2,D11,D12,D21,D22);
end

plot((Length/(NumSenLoc+1))*(1:NumSenLoc),costs);  


xlabel('Sensor Position on Beam');
ylabel('Output Feedback H_2 Cost');
title('Optimal Sensor Location');
set(findall(gcf,'type','text'),'fontSize',16);
