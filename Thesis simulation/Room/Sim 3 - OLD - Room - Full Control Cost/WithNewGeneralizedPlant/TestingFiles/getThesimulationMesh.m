clear all; clc;
heatX  = 0.2; %coord for center of heater
heatY  = 0.1;
heatdx = 0.1; %half width of heater
heatdy = 0.05;
winX   = 1; %coord for center of window
winY   = 0.6;
windx  = 0.2; %half width of window
windy  = 0.2;
%senX   = 1.15; %coord for center of sensor
%senY   = 1.5;  %it varies in search of the optimal
sendx  = 0.05;  %half width of sensor
sendy  = 0.05;
roomCornersCoord = [0,0,1,1,2,2,0,1,1,2,2,0]; % first x then y
wantRefinedMesh  = 0; %refine act-dist of mesh more, 1 yes 0 no
refineActSen = 0;
a = 1; % not sure what these values represent
c = 1;
f = 0; % dummy f , later defined properly
disturbStrength = 2000;
actStrength = 1;
stateWeightInCost   = 1000;
controlWeightInCost = 1;
stateWeightInSen    = 1;
disturbWeightInSen  = 1;

resolution = 0.05; % distance between adjacent points in simulation
senXPos = sendx:resolution:2-sendx; %possible sensor x coordinates
senYPos = sendy:resolution:2-sendy; %possible sensor y coordinates
h2scores = zeros(length(senXPos),length(senYPos));

[p,e,t] = getMesh_justOneRegion(heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        sendx ,sendy ,...
        roomCornersCoord,wantRefinedMesh,refineActSen);
 
clf;    
hold on;    
pdemesh(p,e,t);
%fill([winX-windx,winX-windx,winX+windx,winX+windx],[winY-windy,winY+windy,winY+windy,winY-windy],'b');
%text(winX-0.03, winY, 'D', 'Color', [1,1,1],'FontSize', 18);
hold off;
axis square;


