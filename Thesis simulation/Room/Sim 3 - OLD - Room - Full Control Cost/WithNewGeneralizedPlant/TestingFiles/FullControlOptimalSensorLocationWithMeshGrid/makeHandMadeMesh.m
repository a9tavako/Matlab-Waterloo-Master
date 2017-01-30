function  [p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = makeHandMadeMesh(xRes,yRes,...
        heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy)
%xRes,yRes   must divide 1 so an integer repetition of it fits into the room

[heatX,heatY]   = roundToAGridPoint(heatX,heatY,xRes,yRes);
[heatdx,heatdy] = roundToAGridPoint(heatdx,heatdy,xRes,yRes);

[winX,winY]   = roundToAGridPoint(winX,winY,xRes,yRes);
[windx,windy] = roundToAGridPoint(windx,windy,xRes,yRes);

[senX,senY]   = roundToAGridPoint(senX,senY,xRes,yRes);
[sendx,sendy] = roundToAGridPoint(sendx,sendy,xRes,yRes);


numGridSquares = int32(3*1^2/(xRes*yRes)); 
numTriangles = 2*numGridSquares;
numPoints = int32(3/(xRes*yRes) + 2/xRes + 2/yRes + 1);

p = zeros(2,numPoints);
t = zeros(4,numTriangles);
e = [1,2,0,0,0,0,1]'; % fake just for synatax reasons


boundaryPointsIndex = zeros(int32(2/xRes + 2/yRes),1);
windowPointsIndex   = zeros(int32(2*windx/xRes + 1 + 2*windy/yRes + 1),1);
heaterPointsIndex   = zeros(int32(2*heatdx/xRes + 1 + 2*heatdy/yRes + 1),1);
sensorPointsIndex   = zeros(int32(2*sendx/xRes + 1 + 2*sendy/yRes + 1),1);


boundaryCounter = 1;
windowCounter = 1;
heaterCounter = 1;
sensorCounter = 1;
for i=0:xRes:2
   for j=0:yRes:2
      if ( i < 1 && j > 1)
          continue;
      end      
      myPointIndex = getPointIndex(i,j,xRes,yRes);
      p(1,myPointIndex) = i;
      p(2,myPointIndex) = j;
      
      if (i==0 || i==2 || j==0 || j==2 || (j==1 && i <= 1) || (i==1 && j>= 1) )
          boundaryPointsIndex(boundaryCounter) = myPointIndex;
          boundaryCounter = boundaryCounter+1;
      end    
      if ((winX-windx <= i) && (i <= winX+windx) && (winY-windy <= j) && (j <= winY+windy))
          windowPointsIndex(windowCounter) = myPointIndex;
          windowCounter = windowCounter + 1;
      end
      if ( (heatX-heatdx <= i) && (i <= heatX+heatdx) && (heatY-heatdy <= j) && (j <= heatY+heatdy))
          heaterPointsIndex(heaterCounter) = myPointIndex;
          heaterCounter = heaterCounter + 1;
      end
      if ( (senX-sendx <= i) && (i <= senX+sendx) && (senY-sendy <= j) && (j <= senY+sendy))
          sensorPointsIndex(sensorCounter) = myPointIndex;
          sensorCounter = sensorCounter + 1;
      end      
   end
end

triangelCounter = 1;
for j=0:yRes:2
    for i=0:xRes:2
      if ( i < 1 && j >= 1) || i ==2 || j == 2
          continue;
      end
      p1 = getPointIndex(i,j,xRes,yRes);
      p2 = getPointIndex(i+xRes,j,xRes,yRes);
      p3 = getPointIndex(i,j+yRes,xRes,yRes);
      p4 = getPointIndex(i+xRes,j+yRes,xRes,yRes);
      t(1,triangelCounter) = p1;
      t(2,triangelCounter) = p2;
      t(3,triangelCounter) = p4;
      t(4,triangelCounter) = 1;
      triangelCounter = triangelCounter + 1;
      t(1,triangelCounter) = p1;
      t(2,triangelCounter) = p3;
      t(3,triangelCounter) = p4;
      t(4,triangelCounter) = 1;
      triangelCounter = triangelCounter + 1;
   end
end

%When sensor is too close to the side, all of it doesnt fit inside the
%domain, only the points in the domain count, outside points are discarded.
sensorPointsIndex(sensorPointsIndex==0) = [];
end


function pointIndex = getPointIndex(i,j,xRes,yRes)
if (i < 1 && i <= 1)
    pointIndex = (i/xRes)*((1/yRes) + 1) + ((j/yRes)+1);
elseif ( i >= 1)
   pointIndex = (1/xRes)*(1/yRes + 1) + (i/xRes - 1/xRes)*(2/yRes + 1) + (j/yRes + 1); 
end
pointIndex = int32(pointIndex);
end

function [roundi,roundj] = roundToAGridPoint(i,j,xRes,yRes)

roundi = floor(i/xRes)*xRes;
roundj = floor(j/yRes)*yRes;

end

