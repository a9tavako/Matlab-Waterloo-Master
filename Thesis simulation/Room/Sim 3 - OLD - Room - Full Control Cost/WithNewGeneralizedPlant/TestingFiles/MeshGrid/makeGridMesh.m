% Gives a grid mesh, too slow for resolution less than 0.1 
clear;
xResolution = 0.1; % must divide 1 so an integer repetition of it fits into the room
yResolution = 0.1; % must divide 1
numGridSquares = int32(3*1^2/(xResolution*yResolution)); 

roomCornersCoord = [0,0,1,1,2,2,0,1,1,2,2,0]; % first x then y
room             = [2,6,roomCornersCoord]' ; % a polygon with 6 sides, see decsg in matlab
geometryObjectLength  = length(room);


objects = zeros(geometryObjectLength,numGridSquares+1);
objects(1:geometryObjectLength,1) = room;

GridSquare = [3,4,zeros(1,geometryObjectLength-2)]';
boxCounter = 2;
for i=0:xResolution:2-xResolution
    for j=0:yResolution:2-yResolution
       if ( i < 1 && j >= 1)
           continue;
       end
       GridSquare(3:10) = [i,i,i+xResolution,i+xResolution,j,j+yResolution,j+yResolution,j];
       objects(1:length(GridSquare),boxCounter) = GridSquare;
       boxCounter = boxCounter + 1;
    end
end

geom = decsg(objects);
[p,e,t] = initmesh(geom,'Hmax',inf);
pdemesh(p,e,t);
axis square;
save('all-TheVariables');
