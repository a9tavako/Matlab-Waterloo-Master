clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectangle is code 3, 4 sides
% followed by x-coordinates and then y-coordinates
% actX = 1.5; %coord for center of square
% actY = 1;
% d = 0.1; %act half width
% % L shaped Polygon, polygon code is 2, 6 sides
% P = [2,6,0,0,1,1,2,2,0,1,1,2,2,0]';
% %Disturbance region, a thin rectange as a window
% winX   = 1.15;
% winY   = 1.5;
% dx     = 0.05;
% dy     = 0.45;
% 
% %sensor, small square
% senX   = 1.7;
% senY   = 0.3;
% sdx    = 0.05;
% sdy    = 0.05;

xRes = 0.05;
yRes = 0.05;

heatX  = 0.5; %coord for center of heater
heatY  = 0.6;
heatdx = 0.3; %half width of heater
heatdy = 0.2;
winX   = 1.4; %coord for center of window
winY   = 1.4;
windx  = 0.2; %half width of window
windy  = 0.4;
senX   = xRes/2; %coord for center of sensor
senY   = yRes/2;  %it varies in search of the optimal
sendx  = 0.1;  %half width of sensor
sendy  = 0.1;



advection = 1; % not sure what these values represent
diffusivity = 1;
f = 0; % dummy f , later defined properly
disturbStrength = 10;
actStrength = 100;
stateWeightInCost   = 1;
controlWeightInCost = 1;
stateWeightInSen    = 1;
disturbWeightInSen  = 1;

[p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = makeHandMadeMesh(xRes,yRes,...
        heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy);
    
    
 [M,K,A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant_Correct(p,e,t,...
                                           boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex,...
                                           advection,diffusivity,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen);


 indexes = boundaryPointsIndex;
                                       
% Simulation
U0 = ones(length(p)-length(indexes),1);
U0 = U0/(norm(U0)*sqrt(xRes*yRes));
U0 = U0*1000;

time = [0,0.3];

%RHS =  @(t,x)  (-1)*M\K*x + B2*sin(t) + B1*[1;0] ;
%RHS =  @(t,x)  A*x + B2*sin(t) + B1*[1;0]*sin(3*t);
RHS =  @(t,x)  A*x;
[T,U] = ode23s(RHS,time,U0);


%padding zeros to U for boundary points
U_Full = zeros(size(U,1),length(p));
SolIndexes = setdiff(1:length(p),indexes); % set difference
for i=1:length(SolIndexes)
    U_Full(:,SolIndexes(i)) = U(:,i);
end
U  = U_Full;

[n,m] = size(U);
max(max(U(n,:)))

for i=1:size(U,1)
   pdeplot(p,e,t,'zdata',U(i,:));
   set(gca,'ZLIM',[-10,20]);
   set(gca,'CLIM',[-10,15]);
   drawnow;
end

