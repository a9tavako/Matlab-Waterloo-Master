function [A,B1,B2,C1,C2,D11,D12,D21,D22] = getRoomGeneralizedPlant(...
                                           p,e,t,a,c,f,...
                                           disturbStrength,actStrength,...
                                           stateWeightInCost,controlWeightInCost,...
                                           stateWeightInSen,disturbWeightInSen)
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
counter = 1;
windPoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 3 || e(7,i) == 3   % 3 is for the window region
        windPoints(counter) = e(1,i);
        windPoints(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
windPoints = unique(windPoints);  %removing repetitions
windPoints(windPoints==0) = [];     %removing zeros;
windPoints = sort(windPoints);

%windCold = -100; %window's base temperature
B1 = zeros(length(p),1);
for i=1:length(windPoints)
    B1(windPoints(i)) = disturbStrength;
end
B1(boundaryIndexes,:)=[]; %removing boundary points form B1

%--------B2--------%
counter = 1;
actPoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 1 || e(7,i) == 1   % finding edges that form the border of actuator; 1 is the code for the actuator region
        actPoints(counter) = e(1,i);
        actPoints(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
actPoints = unique(actPoints);  %removing repetitions
actPoints(actPoints==0) = [];   %removing zeros;
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
counter = 1;
senPoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 3 || e(7,i) == 3   % 4 is for the sensor region
        senPoints(counter) = e(1,i);
        senPoints(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
senPoints = unique(senPoints);  %removing repetitions
senPoints(senPoints==0) = [];     %removing zeros;
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
D21 = disturbWeightInSen;
D22 = 0;
end