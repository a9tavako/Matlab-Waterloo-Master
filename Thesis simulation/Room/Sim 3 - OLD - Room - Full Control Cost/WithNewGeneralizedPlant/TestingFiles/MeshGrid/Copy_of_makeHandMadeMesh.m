function  [p,e,t] = makeHandMadeMesh(xRes,yRes)
%xRes  must divide 1 so an integer repetition of it fits into the room
%yRes  must divide 1

numGridSquares = int32(3*1^2/(xRes*yRes)); 
numTriangles = 2*numGridSquares;
numPoints = int32(3/(xRes*yRes) + 2/xRes + 2/yRes + 1);

p = zeros(2,numPoints);
t = zeros(4,numTriangles);
e = [1,2,0,0,0,0,1]'; % fake just for synatax reasons


for i=0:xRes:2
   for j=0:yRes:2
      if ( i < 1 && j > 1)
          continue;
      end
      myPointIndex = getPointIndex(i,j,xRes,yRes);
      p(1,myPointIndex) = i;
      p(2,myPointIndex) = j;           
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
end


function pointIndex = getPointIndex(i,j,xRes,yRes)
if (i < 1 && i <= 1)
    pointIndex = (i/xRes)*((1/yRes) + 1) + ((j/yRes)+1);
elseif ( i >= 1)
   pointIndex = (1/xRes)*(1/yRes + 1) + (i/xRes - 1/xRes)*(2/yRes + 1) + (j/yRes + 1); 
end
pointIndex = int32(pointIndex);
end


