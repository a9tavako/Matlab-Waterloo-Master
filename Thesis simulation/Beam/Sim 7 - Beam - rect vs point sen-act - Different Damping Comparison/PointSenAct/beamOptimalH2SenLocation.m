clear all;clf;
Length          = 1          ;%length
NumNode         = 10         ;%number of modes
ActLoc          = 0.3*Length ;
%SenLoc         = varies on the beam, in a search for optimal place
StateWeight     = 1000       ;%state weight in the cost function
ControlWeight   = 1          ;%control weight in the cost function
DisturbanceMean = Length*0.8 ;%disturbance is a gaussian function 
DisturbanceVar  = Length*0.05; 
NumSenLoc       = 20         ; % num of positions available for sensor, evenly spaced, excluding the end points
NumDamp         = 10         ; % Different Dampings set to 5 for plot legend
baseDamping     = 0.0001     ;
dDamp           = 0.0005     ;


h2scores = zeros(NumDamp,NumSenLoc);

for dampCounter = 1:NumDamp
    damping = baseDamping+ (dampCounter-1)*dDamp;
    for i=1:NumSenLoc
        SenLoc = Length*i/(NumSenLoc+1);
        [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,damping,ActLoc,SenLoc,...
            StateWeight,ControlWeight,DisturbanceMean,DisturbanceVar);
        h2scores(dampCounter,i)         = calculateH2OptimalCost(A,B1,B2,C1,C2,D11,D12,D21,D22);
    end
end


n = NumSenLoc;
plot((1:n)/(n+1),h2scores(1,:),'r', ...
     (1:n)/(n+1),h2scores(2,:),'b', ...
     (1:n)/(n+1),h2scores(3,:),'k', ...
     (1:n)/(n+1),h2scores(4,:),'g', ...
     (1:n)/(n+1),h2scores(5,:),'r--o', ...
     (1:n)/(n+1),h2scores(6,:),'b--o', ...
     (1:n)/(n+1),h2scores(7,:),'k--o', ... 
     (1:n)/(n+1),h2scores(8,:),'g--o', ...
     (1:n)/(n+1),h2scores(9,:),'r*', ...
     (1:n)/(n+1),h2scores(10,:),'b*' ... 
     );

legend('0.0001','0.0006','0.0011','0.0016','0.0021','0.0026','0.0031','0.0036',...
       '0.0041','0.0046','Location','NorthEastOutside');
xlabel('Sensor Position on Beam');
ylabel('H_2 Cost');
title('Effect of Damping - Point Actuator');
set(findall(gcf,'type','text'),'fontSize',16);
