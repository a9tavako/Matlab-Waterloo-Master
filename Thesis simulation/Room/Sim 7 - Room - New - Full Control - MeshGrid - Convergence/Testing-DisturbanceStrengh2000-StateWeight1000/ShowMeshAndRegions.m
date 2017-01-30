xRes   = 0.2;
yRes   = 0.2;

heatX  = 1.4; %coord for center of heater
heatY  = 0.3;
heatdx = 0.4; %half width of heater
heatdy = 0.1;

winX   = 1.4; %coord for center of window
winY   = 1.4;
windx  = 0.2; %half width of window
windy  = 0.4;

senX   = 2*xRes; %coord for center of sensor
senY   = 2*yRes;  %it varies in search of the optimal
sendx  = 0.2;  %half width of sensor
sendy  = 0.2;



[p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = makeHandMadeMesh(xRes,yRes,...
        heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy);
    
figure(4); 
clf;
hold on;
pdemesh(p,e,t);    
fill([winX-windx,winX-windx,winX+windx,winX+windx],[winY-windy,winY+windy,winY+windy,winY-windy],'b');
fill([heatX-heatdx,heatX-heatdx,heatX+heatdx,heatX+heatdx],[heatY-heatdy,heatY+heatdy,heatY+heatdy,heatY-heatdy],'r');
fill([senX-sendx,senX-sendx,senX+sendx,senX+sendx],[senY-sendy,senY+sendy,senY+sendy,senY-sendy],'k');
text(winX-0.03, winY, 'D', 'Color', [1,1,1],'FontSize', 18);
text(heatX-0.03, heatY, 'A', 'Color', [1,1,1],'FontSize', 18);
text(senX-0.03, senY, 'S', 'Color', [1,1,1],'FontSize', 18);
hold off;