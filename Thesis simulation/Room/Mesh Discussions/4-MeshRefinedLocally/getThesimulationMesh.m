clear;clc;clf;
heatX  = 1.5; %coord for center of heater
heatY  = 0.15;
heatdx = 0.45; %half width of heater
heatdy = 0.05;
winX   = 1.15; %coord for center of window
winY   = 1.5;
windx  = 0.05; %half width of window
windy  = 0.45;
senX   = 0.1; %coord for center of sensor
senY   = 0.5;  %it varies in search of the optimal
sendx  = 0.05;  %half width of sensor
sendy  = 0.05;
roomCornersCoord = [0,0,1,1,2,2,0,1,1,2,2,0]; % first x then y
wantRefinedMesh  = 0; %refine act-dist of mesh more, 1 yes 0 no 
a = 1; % not sure what these values represent
c = 1;
f = 0; % dummy f , later defined properly
disturbStrength = 2000;
actStrength = 1;
stateWeightInCost   = 1000;
controlWeightInCost = 1;
stateWeightInSen    = 1;
disturbWeightInSen  = 1;
refineActSen        = 0;
wantRefinedMesh     = 0;

resolution = 0.05; % distance between adjacent points in simulation
senXPos = sendx:resolution:2-sendx; %possible sensor x coordinates
senYPos = sendy:resolution:2-sendy; %possible sensor y coordinates
h2scores = zeros(length(senXPos),length(senYPos));

[geom,p,e,t] = getMesh(heatX,heatY,heatdx,heatdy,...
    winX ,winY ,windx ,windy ,...
    senX ,senY ,sendx ,sendy ,...
    roomCornersCoord,wantRefinedMesh,refineActSen);
 

triangles = findAllIntersectingTriangles(p,e,t,heatX,heatY,heatdx,heatdy,...
    winX ,winY ,windx ,windy ,...
    senX ,senY ,sendx ,sendy);

[p,e,t]=refinemesh(geom,p,e,t,triangles,'regular');

triangles = findAllIntersectingTriangles(p,e,t,heatX,heatY,heatdx,heatdy,...
    winX ,winY ,windx ,windy ,...
    senX ,senY ,sendx ,sendy);

[p,e,t]=refinemesh(geom,p,e,t,triangles,'regular');


hold on;
win = fill([winX-windx,winX-windx,winX+windx,winX+windx],[winY-windy,winY+windy,winY+windy,winY-windy],'w');
set(win,'EdgeColor',[1,0,0]);
heat = fill([heatX-heatdx,heatX-heatdx,heatX+heatdx,heatX+heatdx],[heatY-heatdy,heatY+heatdy,heatY+heatdy,heatY-heatdy],'w');
set(heat,'EdgeColor',[1,0,0]);
sensor = fill([senX-sendx,senX-sendx,senX+sendx,senX+sendx],[senY-sendy,senY+sendy,senY+sendy,senY-sendy],'w');
set(sensor,'EdgeColor',[1,0,0]);
pdemesh(p,e,t);
axis square;
hold off;

