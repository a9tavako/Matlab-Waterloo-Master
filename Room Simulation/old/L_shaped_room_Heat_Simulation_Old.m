clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rectangle is code 3, 4 sides
% followed by x-coordinates and then y-coordinates
actX = 1.5; %coord for center of square
actY = 1;
d = 0.1; %act half width
Act = [3,4,actX-d,actX-d,actX+d,actX+d,actY-d,actY+d,actY+d,actY-d]';
% L shaped Polygon, polygon code is 2, 6 sides
P = [2,6,0,0,1,1,2,2,0,1,1,2,2,0]';
%Disturbance region, a thin rectange as a window
winX   = 1.15;
winY   = 1.5;
dx     = 0.05;
dy     = 0.45;
window = [3,4,winX-dx,winX-dx,winX+dx,winX+dx,winY-dy,winY+dy,winY+dy,winY-dy]';
%sensor, small square
senX   = 1.7;
senY   = 0.3;
sdx    = 0.05;
sdy    = 0.05;
sensor = [3,4,senX-sdx,senX-sdx,senX+sdx,senX+sdx,senY-sdy,senY+sdy,senY+sdy,senY-sdy]';

% Pad with zeros to enable concatenation, P is the longest
Act    = [Act;zeros(length(P)-length(Act),1)];
window = [window;zeros(length(P)-length(window),1)];
sensor = [sensor;zeros(length(P)-length(sensor),1)];
objects = [Act,P,window,sensor];
% Names for the two geometric objects
ns = (char('Act','P','window','sensor'))';
% Set formula
sf = 'Act+P+window+sensor';
% Create geometry
[geom,bt,dl1,bt1,msb] = decsg(objects,sf,ns);
[p,e,t]=initmesh(geom);
%[p,e,t]=refinemesh(geom,p,e,t,[1,3]);
% pdemesh(p,e,t);
% return;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = 1;
c = 1;
f = 0; % dummy f , later defined properly
[K,M,F]=assema(p,t,c,a,f);

%Finding boundary points indexes
counter = 1;
indexes = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 0 || e(7,i) == 0   % 0 is for the exterior region
        indexes(counter) = e(1,i);
        indexes(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
indexes = unique(indexes);  %removing repetitions
indexes(indexes==0) = [];   %removing zeros;
indexes = sort(indexes);


%Finding actuatur points and making the forcing vector on the RHS of the
%pde
counter = 1;
actPoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 1 || e(7,i) == 1   % 1 is for the actuator region
        actPoints(counter) = e(1,i);
        actPoints(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
actPoints = unique(actPoints);  %removing repetitions
actPoints(actPoints==0) = [];     %removing zeros;
actPoints = sort(actPoints);


actStength = 200;
B2 = zeros(length(p),1);
for i=1:length(actPoints)
    B2(actPoints(i)) = actStength;
end
B2(indexes,:)=[]; %removing boundary points form B2


%Finding windows pints and making the window forcing vector
counter = 1;
windPoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 3 || e(7,i) == 3   % 3 is for the window region
        windPoints(counter) = e(1,i);
        windPoints(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
windPoints = unique(windPoints);  %removing repetitions
windPoints(windPoints==0) = [];     %removing zeros;
windPoints = sort(windPoints);


windCold = -100;
B1 = zeros(length(p),1);
for i=1:length(windPoints)
    B1(windPoints(i)) = windCold;
end
B1(indexes,:)=[]; %removing boundary points form B1


%Finding Sensor points
counter = 1;
senPoints = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
for i=1:size(e,2)
    if e(6,i) == 3 || e(7,i) == 3   % 4 is for the sensor region
        senPoints(counter) = e(1,i);
        senPoints(counter+1) = e(2,i);
        counter = counter + 2;
    end
end
senPoints = unique(senPoints);  %removing repetitions
senPoints(senPoints==0) = [];     %removing zeros;
senPoints = sort(senPoints);

senStength = 1;
C2 = zeros(length(p),1);
for i=1:length(senPoints)
    C2(senPoints(i)) = senStength;
end
C2(indexes,:)=[]; %removing boundary points form B1
C2 = C2'/sum(C2); % averaging sensor over the nodes


% K,M are global stifness and mass matrices, but they are by default
% for Neumann boundary condtions , need to remove the boundary points
% from rows and columns  to get only the interior points for zero
% dirichlet boundary values.

%Removing boundary points from K,M, both columns and rows
K(:,indexes)=[];
K(indexes,:)=[];
M(:,indexes)=[];
M(indexes,:)=[];

%Constructing the rest of the generalized plant matrices
% statesNum = length(p)-length(indexes);
% C1  = eye(statesNum+1,statesNum);
% C1(statesNum+1,statesNum)  = 0;
% D11 = zeros(statesNum+1,1);
% D12 = zeros(statesNum+1,1);
% D12(statesNum+1,1) = 1;
% D21 = 1;
% D22 = 0;
% 
% % A = (-1)*M\K;
% % 
% % syst = ss(A,[B1,B2],[C1;C2],[D11,D12;D21,D22]);
% % genPlant = mktito(syst, 1,1);
% % [K,CL,GAM,INFO]  = h2syn(genPlant);

% 
% Simulation
U0 = ones(length(p)-length(indexes),1)*20;
time = [0,20];

RHS =  @(t,x)  (-1)*M\K*x + B2*sin(t) + B1;
[T,U] = ode15s(RHS,time,U0);


%padding zeros to U for boundary points
U_Full = zeros(size(U,1),length(p));
SolIndexes = setdiff(1:length(p),indexes); % set difference
for i=1:length(SolIndexes)
    U_Full(:,SolIndexes(i)) = U(:,i);
end
U  = U_Full;


for i=1:size(U,1)
    pdeplot(p,e,t,'zdata',U(i,:));
    set(gca,'ZLIM',[-10,20]);
    set(gca,'CLIM',[-10,15]);
    drawnow;
end

