clear; clc;
tic
xRes   = 0.1;
yRes   = 0.1;

heatX  = 0.2; %coord for center of heater
heatY  = 0.5;
heatdx = 0.1; %half width of heater
heatdy = 0.4;
winX   = 1.2; %coord for center of window
winY   = 1.5;
windx  = 0.1; %half width of window
windy  = 0.4;
%senX   = 1.15; %coord for center of sensor
%senY   = 1.5;  %it varies in search of the optimal
sendx  = 0.2;  %half width of sensor
sendy  = 0.2;

a = 1; % not sure what these values represent
c = 1;
f = 0; % dummy f , later defined properly
disturbStrength = 2000;
actStrength = 1;
stateWeightInCost   = 1000;
controlWeightInCost = 1;
stateWeightInSen    = 1;
disturbWeightInSen  = 1;

senXPos = 0:xRes:2; %possible sensor x coordinates
senYPos = 0:yRes:2; %possible sensor y coordinates
h2scores = zeros(length(senXPos),length(senYPos));

for counterX = 1:length(senXPos)
    for counterY = 1:length(senYPos)
    if senXPos(counterX) < 1 && senYPos(counterY) > 1 
        h2scores(counterX,counterY) = NaN;
        continue; %if in the top left area, skip cause it's outside the domain
    end
    senX   = senXPos(counterX); 
    senY   = senYPos(counterY); 
    
[p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = makeHandMadeMesh(xRes,yRes,...
        heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy);
    
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant_New(p,e,t,...
                                           boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex,...
                                           a,c,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen);
    
    h2scores(counterX,counterY) = calculateOptimalH2SensorCost(A,B1,B2,...
                                                     C1,C2,D11,D12,D21,D22);
    end
end


contourf(senXPos,senYPos,h2scores')                  ; % plotting the results, 2D color map
contourcbar                                          ;
title('H_2 Full Control Cost') ;
xlabel('x coordinate of sensor')                     ;
ylabel('y coordinate of sensor')                     ;
set(findall(gcf,'type','text'),'fontSize',16)        ;

save('roomSimulation-AllTheVariables');
toc