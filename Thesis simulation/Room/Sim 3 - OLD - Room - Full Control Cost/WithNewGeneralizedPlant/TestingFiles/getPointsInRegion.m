clear all; clc;
heatX  = 0.5; %coord for center of heater
heatY  = 0.5;
heatdx = 0.1; %half width of heater
heatdy = 0.05;
winX   = 1; %coord for center of window
winY   = 0.6;
windx  = 0.2; %half width of window
windy  = 0.2;
senX   = 1.15; %coord for center of sensor
senY   = 1.5;  %it varies in search of the optimal
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

resolution = 0.05; % distance between adjacent points in simulation
senXPos = sendx:resolution:2-sendx; %possible sensor x coordinates
senYPos = sendy:resolution:2-sendy; %possible sensor y coordinates
h2scores = zeros(length(senXPos),length(senYPos));

[p,e,t] = getMeshHacked(heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX,senY,sendx ,sendy ,...
        roomCornersCoord,wantRefinedMesh);
 
clf;    
hold on;    
pdemesh(p,e,t);
%fill([winX-windx,winX-windx,winX+windx,winX+windx],[winY-windy,winY+windy,winY+windy,winY-windy],'b');
%text(winX-0.03, winY, 'D', 'Color', [1,1,1],'FontSize', 18);
hold off;
axis square;

% counter = 1;
% FalsePoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
% for i=1:size(e,2)
%     if e(6,i) == 1 || e(7,i) == 1   % finding edges that form the border of actuator; 1 is the code for the actuator region
%         FalsePoints(counter) = e(1,i);
%         FalsePoints(counter+1) = e(2,i);
%         counter = counter + 2;
%     end
% end
% FalsePoints = unique(FalsePoints);  %removing repetitions
% FalsePoints(FalsePoints==0) = [];   %removing zeros;
% FalsePoints = sort(FalsePoints);
% 
% 
% counter = 1;
% regionPoints = zeros(1,3*size(p,2));
% for i=1:size(t,2)
%     if t(4,i) == 2
%         regionPoints(counter) = t(1,i);
%         regionPoints(counter+1) = t(2,i);
%         regionPoints(counter+2) = t(3,i);
%         counter = counter + 3;
%     end
% end
% regionPoints = unique(regionPoints);
% regionPoints(regionPoints==0) = [];
% regionPoints = sort(regionPoints);


[uxy,tn,a2,a3]=tri2grid(p,t,zeros(size(p,2)),senX,senY);%Find sensor subdomain number
senSubDomain = t(4,tn);
[pointsOne,pointsTwo] = pdesdp(p,e,t,senSubDomain);%Find all points in that subdomain number
senPoints = [pointsOne,pointsTwo];
senPoints = sort(senPoints);

