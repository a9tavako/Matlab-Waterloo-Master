clear;
dx = 0.2;
x = 0:dx:10;
y = zeros(1,length(x));

u_0 = ones(1,length(x));
v_0 = ones(1,length(x));
period = 50;

for i=1:1000
    u = sin(i/period*x).*u_0;
    v = cos(i/period*x).*v_0;
  
    clf;
    hold on;
    quiver(x,y,u,v,0.3,'LineWidth',2,'Color','b');
    plot(x,y,'Color','k','LineWidth',2);
    hold off;
    axis([-3,13,-2,2]);
    
    drawnow;
end
























