clear all; clc;
heatX  = 0.2; %coord for center of heater
heatY  = 0.1;
heatdx = 0.1; %half width of heater
heatdy = 0.05;
winX   = 1.5; %coord for center of window
winY   = 0.15;
windx  = 0.45; %half width of window
windy  = 0.05;
%senX   = 1.15; %coord for center of sensor
%senY   = 1.5;  %it varies in search of the optimal
sendx  = 0.05;  %half width of sensor
sendy  = 0.05;
roomCornersCoord = [0,0,1,1,2,2,0,1,1,2,2,0]; % first x then y
wantRefinedMesh  = 0; %refine all of mesh more, 1 yes 0 no 
refineActSen     = 0; %%refine act-dist of mesh more, 1 yes 0 no 
a = 1; % not sure what these values represent
c = 1;
f = 0; % dummy f , later defined properly
disturbStrength = 2000;
actStrength = 1;
stateWeightInCost   = 1000;
controlWeightInCost = 1;
stateWeightInSen    = 1;
disturbWeightInSen  = 1;

resolution = 0.1; % distance between adjacent points in simulation
senXPos = sendx:resolution:2-sendx; %possible sensor x coordinates
senYPos = sendy:resolution:2-sendy; %possible sensor y coordinates
h2scores = zeros(length(senXPos),length(senYPos));

for counterX = 1:length(senXPos)
    for counterY = 1:length(senYPos)
    if senXPos(counterX) <= 1 && senYPos(counterY) >= 1 
        h2scores(counterX,counterY) = NaN;
        continue; %if in the top left area, skip cause it's outside the domain
    end
    senX   = senXPos(counterX); 
    senY   = senYPos(counterY); 
    
    [p,e,t] = getMesh(heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy ,...
        roomCornersCoord,wantRefinedMesh,refineActSen);
    
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant_New(...
                                           p,e,t,a,c,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen,...
                                           heatX,heatY,...
                                           winX ,winY,senX, senY);
    
    h2scores(counterX,counterY) = calculateOptimalH2SensorCost(A,B1,B2,...
                                                     C1,C2,D11,D12,D21,D22);
    end
end


contourf(senXPos,senYPos,h2scores')                  ; % plotting the results, 2D color map
contourcbar                                          ;
title('H_2 Optimal State Estimation Cost In a Room') ;
xlabel('x coordinate of sensor')                     ;
ylabel('y coordinate of sensor')                     ;
set(findall(gcf,'type','text'),'fontSize',16)        ;


save('roomSimulation-AllTheVariables');