clear all; clc;clf;

% first six x are coordinates, next 6 six are y coordinates
roomCornersCoord    = [0,0,1,1,2,2,0,1,1,2,2,0]; 
RegionSCornersCoord = [0.05,0.05,0.15,0.15,0.45,0.55,0.55,0.45];
RegionDCornersCoord = [1.1,1.1,1.2,1.2,1.05,1.95,1.95,1.05];
RegionACornersCoord = [1.05,1.05,1.95,1.95,0.1,0.2,0.2,0.1];

room   = [2,6,roomCornersCoord]';% 2 is for polygon, 6 sides 
S = [3,4,RegionSCornersCoord]';% 3 for rectangle, 4 sides  
D = [3,4,RegionDCornersCoord]';
A = [3,4,RegionACornersCoord]';

% pad  enable concatenation, room is the longest
A    = [A;zeros(length(room)-length(A),1)];
D    = [D;zeros(length(room)-length(D),1)];
S    = [S;zeros(length(room)-length(S),1)];
objects   = [A,room,D,S];

geom = decsg(objects); % packing the geometric info
[p,e,t]        = initmesh(geom);

pdemesh(p,e,t);
axis square;