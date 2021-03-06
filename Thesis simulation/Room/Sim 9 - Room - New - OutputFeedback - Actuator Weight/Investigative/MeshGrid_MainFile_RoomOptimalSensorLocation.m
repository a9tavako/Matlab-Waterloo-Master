clear; clc;
tic
%0.1 takes 240 seconds 4 minutes
xRes   = 0.2;
yRes   = 0.2;

heatX  = 1.3; %coord for center of heater
heatY  = 1.3;
heatdx = 0.1; %half width of heater
heatdy = 0.4;

winX   = 1.3; %coord for center of window
winY   = 1.4;
windx  = 0.1; %half width of window
windy  = 0.4;

senX   = 0; %coord for center of sensor
senY   = 0;  %it varies in search of the optimal
sendx  = 0.1;  %half width of sensor
sendy  = 0.1;

roomCornersCoord = [0,0,1,1,2,2,0,1,1,2,2,0]; % first x then y
wantRefinedMesh  = 0; %refine all of mesh more, 1 yes 0 no 
refineActSen     = 0; %%refine act-dist of mesh more, 1 yes 0 no 
a = 1; % not sure what these values represent
c = 0.000019; %diffusitivity constant
f = 0; % dummy f , later defined properly
disturbStrength = 1;
actStrength = 100;
stateWeightInCost   = 1;
controlWeightInCost = 1;%must be one, don't change
stateWeightInSen    = 1;
disturbWeightInSen  = 1;% must be one, don't change

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
    
    [A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant_Normalized(p,e,t,xRes,yRes,...
                                           boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex,...
                                           a,c,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen);
   
    [h2scores(counterX,counterY),X,Y] = calculateOptimalH2OutputFeedbackCost(A,B1,B2,...
                                                     C1,C2,D11,D12,D21,D22);
    end
end


figure(3)
clf
contourf(senXPos,senYPos,h2scores')                  ; % plotting the results, 2D color map
contourcbar                                          ;
title('H_2 Output Feedback Cost') ;
xlabel('x coordinate of sensor')                     ;
ylabel('y coordinate of sensor')                     ;
set(findall(gcf,'type','text'),'fontSize',16)        ;
axis square;

save('roomSimulation-AllTheVariables');
toc