xRes   = 0.1;
yRes   = 0.1;

heatX  = 1.4; %coord for center of heater
heatY  = 0.3;
heatdx = 0.4; %half width of heater
heatdy = 0.1;

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
c = 1; %diffusitivity constant
f = 0; % dummy f , later defined properly
disturbStrength = 10;
actStrength = 1;
stateWeightInCost   = 1;
controlWeightInCost = 1;%must be one, don't change
stateWeightInSen    = 1;
disturbWeightInSen  = 1;% must be one, don't change



[p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = Reference_makeHandMadeMesh(xRes,yRes,...
        heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy);
    
figure(4); 
clf;
hold on;
room = fill([0,0,1,1,2,2],[0,1,1,2,2,0],'w');
set(room,'EdgeColor',[1,0,0]);
pdemesh(p,e,t);    
fill([winX-windx,winX-windx,winX+windx,winX+windx],[winY-windy,winY+windy,winY+windy,winY-windy],'b');
fill([heatX-heatdx,heatX-heatdx,heatX+heatdx,heatX+heatdx],[heatY-heatdy,heatY+heatdy,heatY+heatdy,heatY-heatdy],'r');
%fill([senX-sendx,senX-sendx,senX+sendx,senX+sendx],[senY-sendy,senY+sendy,senY+sendy,senY-sendy],'k');
text(winX-0.03, winY, 'D', 'Color', [1,1,1],'FontSize', 18);
text(heatX-0.03, heatY, 'A', 'Color', [1,1,1],'FontSize', 18);
%text(senX-0.03, senY, 'S', 'Color', [1,1,1],'FontSize', 18);

x1 = 0.25;
y1 = 0.47;
d1 = 0.2;
d2 = 0.1;
d3 = 0.05;
h1 = 0.05;
h2 = 0.05;

%starXCord = [x1,x1,x1+d1,x1+d1-d3,x1+d1,x1+d1+d2,x1+d1,x1+d1-d3,x1+d1];
%starYCord = [y1,y1+h1,y1+h1,y1+h1+h2,y1+h1+h2,y1+h1/2,y1-h2,y1-h2,y1];
%fill(starXCord,starYCord,'r');

hold off;
axis square;