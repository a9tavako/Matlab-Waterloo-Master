clear all;cla;clc;clg
numnode = 5;  % number of modes

numSen  = 5;  % num of positions available for sensor, evenly spaced
numAct  = 10;  % can't just make one actuator, need to make alot

senWidth = 0.05;
actWidth = 0.05;
DistWidth = 0.05;

%beam length assumed to be one. 
Lenght = 1;
actLoc  = 0.2*Lenght;
DistLoc = 0.3*Lenght;


numDamp = 5; % Different Dampings set to 5 for plot legend
baseDamping = 0.01;
dDamp   = 0.01;

h2scores = zeros(numDamp,numSen);

for dampCounter = 1:numDamp
    
    damping = baseDamping+ (dampCounter-1)*dDamp;
    [A,B_actuators,C_sensors,C_stateCost] = beameg(numnode,numAct, numSen,damping,actWidth,senWidth);
    
    for counter=1:numSen
        
        %the actLoc/L gives the ratio that is needed :)
        actInd = floor(numAct*actLoc/Lenght);
        B2 = B_actuators(:,actInd);
        
        senInd  = counter;
        C2 = C_sensors(senInd,:);
        
        %Creating the generalized plant
        %_____________________________________________________
        %single rectangle disturbance
        B1 = zeros(2*numnode,1);
        dx = 0.001;
        x = 0:dx:1;
        
        mean  = DistLoc;
        sig   = Lenght/8;
        f = (1/sqrt(2*pi*sig))*exp((-1/2)*((x-mean)/sig).^2);
        f = f/(norm(f)*sqrt(dx));
        
        
        fourierCoef = zeros(numnode,1);  %from position to fourier basis
        for i=1:numnode
            y = sin(i*pi*x);
            y = y/(norm(y)*sqrt(dx));%normalizing L2 norm to one
            fourierCoef(i) = f*y'*dx;
        end
        
        B1(numnode+1:2*numnode,1) = fourierCoef; %disturbance in fourier basis
        % ____________________________________________________________
        
        C1  = zeros(numnode+1,2*numnode);          % state cost for the generalized plant, L2 norm of deflection
        C1(1:numnode,1:2*numnode) = C_stateCost*10000;   % leaves empty space for D21 to account for the control effort
        
        D11 = zeros(numnode+1,1); %can be set to zero for H2 control
        D12 = zeros(numnode+1,1); %control effort cost, separated from C1 by the first numnode zeros, must have full column rank
        D12(numnode+1,1) = 1;
        
        D21 = eye(1,1);  %must have full row rank
        D22 = zeros(1,1);%can be set to zero for H2 control
        
        %packing the generalized plant
        B  = [B1,B2];
        C  = [C1;C2];
        D   = [D11, D12 ; D21 , D22];
        
        
        
        %Solve Riccati eqn based on page 377 and 385 of zhou
        %The Control Riccati
        [X,something,something2,report1] = care(A,B2,C1'*C1);
        if (report1 == -1 || report1 == -2)
            disp('Error in solving the Riccati');
            exit();
        end
        
        F = -B2'*X;
        A_F = A+ B2*F;
        C_F = C1 + D12*F;
        G_c = ss(A_F,B1,C_F,0);
        
        %Observer Riccati
        [Y,something,something2,report2] = care(A'-C2'*D21*B1',C2',B1*B1');
        if (report2 == -1 || report2 == -2)
            disp('Error in solving the Riccati');
            exit();
        end
        L = -(Y*C2'+B1*D21');
        A_L = A+ L*C2;
        B_L = B1 + L*D21;
        G_f = ss(A_L,B_L,F,0);
        
        h2scores(dampCounter,counter) = sqrt(norm(G_c,2)^2 + norm(G_f,2)^2);
        
    end
end

hold on;
n = numSen;
plot((1:n)/(n+1),h2scores(1,:),'r',   ...
     (1:n)/(n+1),h2scores(2,:),'-ro', ...
     (1:n)/(n+1),h2scores(3,:),'b',   ...
     (1:n)/(n+1),h2scores(4,:),'-bo', ...
     (1:n)/(n+1),h2scores(5,:),'k');


legend('0.01','0.02','0.03','0.04','0.05');
xlabel('Sensor Position Along the Beam (M)');
ylabel('H_2 Cost (Non-Dimenstional)');
title('Effect of Damping');
set(findall(gcf,'type','text'),'fontSize',16);
