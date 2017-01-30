function triangles = FinaAllTrianglesThatNeedRefining(p,e,t)
%The syntax of polyxpoly needs the first number to repeated at the end again. 
RegionS_XCornersCoord = [0.05,0.05,0.15,0.15,0.05]; 
RegionS_YCornersCoord = [0.45,0.55,0.55,0.45,0.45];

triangles = zeros(length(t),1);
counter = 1;
for i=1:length(t)
    Triangle_XCoord(1,1:4) = [p(1,t(1,i)),p(1,t(2,i)),p(1,t(3,i)),p(1,t(1,i))];
    Triangle_YCoord(1,1:4) = [p(2,t(1,i)),p(2,t(2,i)),p(2,t(3,i)),p(2,t(1,i))];
    
    %find the intersection between the triangle and the region
    IntersectWithS = polyxpoly(Triangle_XCoord,Triangle_YCoord,...
                               RegionS_XCornersCoord,RegionS_YCornersCoord);
    
    if(~isempty(IntersectWithS))
       triangles(counter) = i;
       counter = counter + 1;
    end
end
triangles(triangles==0) = []; % remove zeros;
end