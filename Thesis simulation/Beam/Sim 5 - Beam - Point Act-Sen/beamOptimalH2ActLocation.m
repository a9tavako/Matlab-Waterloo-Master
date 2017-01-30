clear all;clf;
Length          = 1          ;%length
NumNode         = 10         ;%number of modes
Stiffness       = 0.491      ;%stiffness is EI in the Euler-Bernoulli
Mu              = 0.093      ;%mass density mu
KVDamp          = 0.0000649  ;%Kelvin-Voigt damping
VisDamp         = 0.0013     ;%viscous damping
%ActLoc          = 0.2*Length ;
SenLoc          = 0.9;
StateWeight     = 1000       ;%state weight in the cost function
ControlWeight   = 1          ;%control weight in the cost function
DisturbanceMean = Length*0.2 ;%disturbance is a gaussian function 
DisturbanceVar  = Length*0.05; 

NumActLoc = 50; % num of positions available for sensor, evenly spaced, excluding the end points
costs     = zeros(1,NumActLoc);

for i=1:NumActLoc
    ActLoc = Length*i/(NumActLoc+1);
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,Stiffness,Mu,KVDamp,VisDamp,...
                                                           ActLoc,SenLoc,...
                                                           StateWeight,ControlWeight,...
                                                           DisturbanceMean,DisturbanceVar);
    costs(i)                        = calculateH2OptimalCostActuatorOnly(A,B1,B2,C1,C2,D11,D12,D21,D22);
end

plot((Length/(NumActLoc+1))*(1:NumActLoc),costs);  


xlabel('Actuator Position on Beam');
ylabel('H_2 Cost');
title('Optimal Actuator Location');
set(findall(gcf,'type','text'),'fontSize',16);
