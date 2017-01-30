roomCornersCoord = [0,0,1,1,2,2,0,1,1,2,2,0]; 
room = [2,6,roomCornersCoord]';

[geom,~,~,~,~] = decsg(room);
[p,e,t] = initmesh(geom);  

triangles = FinaAllTrianglesThatNeedRefining(p,e,t);
[p,e,t]=refinemesh(geom,p,e,t,triangles,'regular');

pdemesh(p,e,t);
