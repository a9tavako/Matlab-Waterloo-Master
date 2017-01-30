numnode = 100; % number of modes

damping = 0.02; % damping constant

numsen = 100; % num of positions available for sensor, evenly spaced

senWidth = 0.01;
actWidth = 0.01;


%single rectangle disturbance
        B1 = zeros(2*numnode,1);  
        L =1;
        dx = 0.001;
        x = 0:dx:1;

        dist_x      = floor(0.3*L/dx);         
        dist_xwidth = floor(actWidth/dx);
        I           = dist_x - dist_xwidth : dist_x + dist_xwidth;
        f           = zeros(1,length(x));
        f(I)        = 1;
        
        f = f/(norm(f)*sqrt(dx));
        
        fourierCoef = zeros(numnode,1);  %from position to fourier basis
        for i=1:numnode
            y = sin(i*pi*x);
            y = y/(norm(y)*sqrt(dx));%normalizing L2 norm to one
            fourierCoef(i) = f*y'*dx;
        end
        
        B1(numnode+1:2*numnode,1) = fourierCoef; %disturbance in fourier basis