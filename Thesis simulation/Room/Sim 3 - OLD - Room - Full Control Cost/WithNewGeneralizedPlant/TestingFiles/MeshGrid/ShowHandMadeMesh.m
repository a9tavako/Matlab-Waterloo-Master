clear;
xRes = 0.05; % must divide 1 so an integer repetition of it fits into the room
yRes = 0.05; % must divide 1
[p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = makeHandMadeMesh(xRes,yRes);
pdemesh(p,e,t);