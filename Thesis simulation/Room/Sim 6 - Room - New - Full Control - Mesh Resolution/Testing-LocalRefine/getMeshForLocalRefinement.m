function [p,e,t,boundaryPointsIndex,windowPointsIndex,heaterPointsIndex,sensorPointsIndex] = getMeshForLocalRefinement(heatX,heatY,heatdx,heatdy,...
        winX ,winY ,windx ,windy ,...
        senX ,senY ,sendx ,sendy ,...
        roomCornersCoord)

room   = [2,6,roomCornersCoord]'                                                                                       ;
sensor = [3,4,senX-sendx,senX-sendx,senX+sendx,senX+sendx,senY-sendy,senY+sendy,senY+sendy,senY-sendy]'                ;
window = [3,4,winX-windx,winX-windx,winX+windx,winX+windx,winY-windy,winY+windy,winY+windy,winY-windy]'                ;
heater = [3,4,heatX-heatdx,heatX-heatdx,heatX+heatdx,heatX+heatdx,heatY-heatdy,heatY+heatdy,heatY+heatdy,heatY-heatdy]';

[geom,~,~,~,~] = decsg(room); % packing the geometric info
[p,e,t] = initmesh(geom); % makes the mesh;

[SenTriangles,HeatTriangles,WinTriangles] = findAllIntersectingTriangles(p,e,t,heatX,heatY,heatdx,heatdy,...
winX ,winY ,windx ,windy ,...
senX ,senY ,sendx ,sendy);

TriangleToRefine = zeros(length(SenTriangles)+length(WinTriangles),1);
TriangleToRefine(1:length(SenTriangles)) = SenTriangles;
TriangleToRefine(length(SenTriangles)+1:length(SenTriangles)+length(WinTriangles)) = WinTriangles;
[p,e,t]=refinemesh(geom,p,e,t,TriangleToRefine,'regular');



boundaryPointsIndex = zeros(1,length(p));
windowPointsIndex = zeros(1,length(p));
heaterPointsIndex = zeros(1,length(p));
sensorPointsIndex = zeros(1,length(p));

boundaryCounter = 1;
windowCounter = 1;
heaterCounter = 1;
sensorCounter = 1;
for k=1:length(p)
  
      myPointIndex = k;
      i = p(1,k);
      j = p(2,k);
      
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

boundaryPointsIndex(boundaryPointsIndex==0) = [];
windowPointsIndex(windowPointsIndex==0) = [];
heaterPointsIndex(heaterPointsIndex==0) = [];
sensorPointsIndex(sensorPointsIndex==0) = [];



