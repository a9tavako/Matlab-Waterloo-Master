clear; clc;
tic
%0.1 3 minutes, 0.05 takes 10 hours
xRes   = 0.025;
yRes   = 0.025;

heatX  = 0.4; %coord for center of heater
heatY  = 0.6;
heatdx = 0.2; %half width of heater
heatdy = 0.4;

winX   = 1.4; %coord for center of window
winY   = 1.4;
windx  = 0.2; %half width of window
windy  = 0.4;
senX   = xRes/2; %coord for center of sensor
senY   = yRes/2;  %it varies in search of the optimal
sendx  = 0.1;  %half width of sensor
sendy  = 0.1;


%[heatX,heatY]   = roundToAGridPoint(heatX,heatY,xRes,yRes);
%[heatdx,heatdy] = roundToAGridPoint(heatdx,heatdy,xRes,yRes);
%[winX,winY]     = roundToAGridPoint(winX,winY,xRes,yRes);
%[windx,windy]   = roundToAGridPoint(windx,windy,xRes,yRes);
%[senX,senY]     = roundToAGridPoint(senX,senY,xRes,yRes);
%[sendx,sendy]   = roundToAGridPoint(sendx,sendy,xRes,yRes);


a = 1; % not sure what these values represent
c = 0.001;
f = 0; % dummy f , later defined properly
disturbStrength = 1;
actStrength = 1;
stateWeightInCost   = 1;
controlWeightInCost = 1;
stateWeightInSen    = 1;
disturbWeightInSen  = 1;

senXPos = xRes/2:xRes:2; %possible sensor x coordinates
senYPos = yRes/2:yRes:2; %possible sensor y coordinates
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
    
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant_Correct(p,e,t,...
                                           boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex,...
                                           a,c,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen);
    keyboard;
                                       
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