clf;
xRes = 0.1;
x = 0:xRes:2;
halfX = 1:xRes:2;
y = ones(1,length(x));
halfY = ones(1,length(halfX));

hold on;
for i=0:xRes:1
   plot(x,i*y,'LineWidth',3); 
end
for i=1:xRes:2
   plot(halfX,i*halfY,'LineWidth',3);
end

yRes = 0.1;
halfY = 0:yRes:1;
y = 0:yRes:2;
x = ones(1,length(y));
halfX = ones(1,length(halfY));
for i=0:yRes:1
   plot(i*halfX,halfY,'LineWidth',3); 
end

for i=1:yRes:2
   plot(i*x,y,'LineWidth',3); 
end

axis square;
hold off;

senX   = 0.15; %coord for center of sensor
senY   = 0.55;  %it varies in search of the optimal
sendx  = 0.05;  %half width of sensor
sendy  = 0.05;

hold on;
fill([senX-sendx,senX-sendx,senX+sendx,senX+sendx],[senY-sendy,senY+sendy,senY+sendy,senY-sendy],'k');
text(senX-0.03, senY, 'S', 'Color', [1,1,1],'FontSize', 18);

x1 = 0.25;
y1 = 0.525;
d1 = 0.2;
d2 = 0.1;
d3 = 0.05;
h1 = 0.05;
h2 = 0.05;

starXCord = [x1,x1,x1+d1,x1+d1-d3,x1+d1,x1+d1+d2,x1+d1,x1+d1-d3,x1+d1];
starYCord = [y1,y1+h1,y1+h1,y1+h1+h2,y1+h1+h2,y1+h1/2,y1-h2,y1-h2,y1];
fill(starXCord,starYCord,'r');
hold off;




