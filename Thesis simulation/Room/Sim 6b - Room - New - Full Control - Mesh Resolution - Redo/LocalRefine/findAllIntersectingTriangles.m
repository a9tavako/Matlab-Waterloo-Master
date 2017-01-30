function [SenTriangles,HeatTriangles,WinTriangles] = findAllIntersectingTriangles(p,e,t,heatX,heatY,heatdx,heatdy,...
    winX ,winY ,windx ,windy ,...
    senX ,senY ,sendx ,sendy)

winXCord = [winX-windx,winX-windx,winX+windx,winX+windx,winX-windx];
winYCord = [winY-windy,winY+windy,winY+windy,winY-windy,winY-windy];

heatXCord = [heatX-heatdx,heatX-heatdx,heatX+heatdx,heatX+heatdx,heatX-heatdx];
heatYCord = [heatY-heatdy,heatY+heatdy,heatY+heatdy,heatY-heatdy,heatY-heatdy];

senXCord = [senX-sendx,senX-sendx,senX+sendx,senX+sendx,senX-sendx];
senYCord = [senY-sendy,senY+sendy,senY+sendy,senY-sendy,senY-sendy];


SenTriangles = zeros(length(t),1);
HeatTriangles = zeros(length(t),1);
WinTriangles = zeros(length(t),1);

SenCounter = 1;
HeatCounter = 1;
WinCounter = 1;


myTriX = zeros(1,4);
myTriY = zeros(1,4);

%hold on
for i=1:length(t)
    myTriX(1) = p(1,t(1,i));
    myTriX(2) = p(1,t(2,i));
    myTriX(3) = p(1,t(3,i));
    myTriX(4) = p(1,t(1,i));
    
    myTriY(1) = p(2,t(1,i));
    myTriY(2) = p(2,t(2,i));
    myTriY(3) = p(2,t(3,i));
    myTriY(4) = p(2,t(1,i));
    
    check1 = polyxpoly(myTriX,myTriY,winXCord,winYCord);
    check2 = polyxpoly(myTriX,myTriY,heatXCord,heatYCord);
    check3 = polyxpoly(myTriX,myTriY,senXCord,senYCord);
    
    
    check1 = size(check1,1)*size(check1,2);
    check2 = size(check2,1)*size(check2,2);
    check3 = size(check3,1)*size(check3,2);

    

    if(check1 ~= 0)
       WinTriangles(WinCounter) = i;
       WinCounter = WinCounter + 1;
%        triDraw = fill(myTriX,myTriY,'w');
%        set(triDraw,'EdgeColor',[1,0,0]);
    end
    
    if(check2 ~= 0)
       HeatTriangles(HeatCounter) = i;
       HeatCounter = HeatCounter + 1;
    end 
    
    if(check3 ~= 0)
       SenTriangles(SenCounter) = i;
       SenCounter = SenCounter + 1;
    end   
end
WinTriangles(WinTriangles==0) = [];
HeatTriangles(HeatTriangles==0) = [];
SenTriangles(SenTriangles==0) = [];

end