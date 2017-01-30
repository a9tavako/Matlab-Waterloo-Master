function [A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant_New_Decoupled(...
                                           p,e,t,a,c,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen,...
                                           heatX,heatY,...
                                           winX ,winY,senX, senY)
                                       
boundaryIndexes = getBoundaryIndexes(e);                                                              

%--------A--------% 
[K,M,F]=assema(p,t,c,a,f);
K(:,boundaryIndexes)=[];
K(boundaryIndexes,:)=[];
M(:,boundaryIndexes)=[];
M(boundaryIndexes,:)=[];
A = (-1)*M\K;

%--------B1--------%
%Finding windows points and making B1, represnting the window
[~,tn,~,~]=tri2grid(p,t,zeros(size(p,2)),winX,winY);%Find sensor subdomain number
winSubDomain = t(4,tn);
[pointsOne,pointsTwo] = pdesdp(p,e,t,winSubDomain);%Find all points in that subdomain number
windPoints = [pointsOne,pointsTwo];
windPoints = sort(windPoints);

%windCold = -100; %window's base temperature
B1 = zeros(length(p),1);
for i=1:length(windPoints)
    B1(windPoints(i)) = disturbStrength;
end
B1(boundaryIndexes,:)=[]; %removing boundary points form B1
B1 = [B1, zeros(size(B1,1),1)]; % extra zeros column for orthogonality condition B1*D21' = 0

%--------B2--------%
[~,tn,~,~]=tri2grid(p,t,zeros(size(p,2)),heatX,heatY);%Find sensor subdomain number
heatSubDomain = t(4,tn);
[pointsOne,pointsTwo] = pdesdp(p,e,t,heatSubDomain);%Find all points in that subdomain number
actPoints = [pointsOne,pointsTwo];
actPoints = sort(actPoints);

% setting the strenght of the actuator
%actStength = 200;
B2 = zeros(length(p),1);
for i=1:length(actPoints)
    B2(actPoints(i)) = actStrength;
end
B2(boundaryIndexes,:)=[]; %removing boundary points form B2

%--------C1--------%
NumStates = length(p)-length(boundaryIndexes);
C1  = eye(NumStates+1,NumStates)*stateWeightInCost;
C1(NumStates+1,NumStates)  = 0;

%--------C2--------%
%Finding mesh points in the sensor area
[~,tn,~,~]=tri2grid(p,t,zeros(size(p,2)),senX,senY);%Find sensor subdomain number
senSubDomain = t(4,tn);
[pointsOne,pointsTwo] = pdesdp(p,e,t,senSubDomain);%Find all points in that subdomain number
senPoints = [pointsOne,pointsTwo];
senPoints = sort(senPoints);

%senStength = 1;
C2 = zeros(length(p),1);
for i=1:length(senPoints)
    C2(senPoints(i)) = 1;
end
C2(boundaryIndexes,:)=[]; %removing boundary points form B1
C2 = C2'/sum(C2); % averaging sensor over the nodes
C2 = C2*stateWeightInSen;
%--------D11,D12,D21,D22--------%
NumStates = length(p)-length(boundaryIndexes);
D11 = zeros(NumStates+1,1);
D12 = zeros(NumStates+1,1);
D12(NumStates+1,1) = controlWeightInCost;
D21 = [0,disturbWeightInSen]; % for orthogonality condition B1*D21' = 0
D22 = 0;
end