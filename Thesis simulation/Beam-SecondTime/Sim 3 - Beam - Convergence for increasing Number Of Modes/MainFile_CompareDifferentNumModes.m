clear all;
Length            = 5; %0.4573        ;%length
NumNode           = 30  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.3 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1          ;%state weight in the cost function
ControlWeight     = 1          ;%control weight in the cost function, must be one for unitary assumpt of zhou for Riccaties page 376
DisturbanceEnergy = 300       ;
DisturbanceMean   = Length*0.25;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;    

MaxMode = 14;
MinMode = 1;
RangeOfModes = MaxMode - MinMode;
h2scores = zeros(RangeOfModes,NumLoc);
for NumNode=MinMode:MaxMode;
    for i=1:NumLoc
        SenLoc = Length*i/(NumLoc+1);
        
        [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,Stiffness,MassDensity,DampingVis,DampingKV,...
            ActLoc,SenLoc,ActWidth,SenWidth,...
            StateWeight,ControlWeight, DisturbanceEnergy, DisturbanceMean,DisturbanceVar,DistWeightOnMeasurement);
        
        h2scores(NumNode,i)                     = calculateFullControlCost(A,B1,B2,C1,C2,D11,D12,D21,D22);
    end
end

figure(1);
clf;
n = NumLoc;
% plot((1:n)/(n+1),h2scores(1,:),'k-o', ...
%      (1:n)/(n+1),h2scores(2,:),'b--', ...
%      (1:n)/(n+1),h2scores(3,:),'k--', ...
%      (1:n)/(n+1),h2scores(4,:),'r--', ...
%      (1:n)/(n+1),h2scores(5,:),'b', ...
%      (1:n)/(n+1),h2scores(6,:),'k', ...
%      (1:n)/(n+1),h2scores(7,:),'r' ... 
%      );

plot((1:n)*Length/(n+1),h2scores(1,:),'k', ...
     (1:n)*Length/(n+1),h2scores(2,:),'k--', ...
     (1:n)*Length/(n+1),h2scores(3,:),'ko', ...
     (1:n)*Length/(n+1),h2scores(4,:),'r-.', ...
     (1:n)*Length/(n+1),h2scores(5,:),'r+', ...
     (1:n)*Length/(n+1),h2scores(6,:),'b-', ...
     (1:n)*Length/(n+1),h2scores(7,:),'b-', ...
     (1:n)*Length/(n+1),h2scores(8,:),'b-', ...
     (1:n)*Length/(n+1),h2scores(9,:),'b-', ...
     (1:n)*Length/(n+1),h2scores(10,:),'b-' ...
     );



xlabel('Sensor Position on Beam');
%ylabel('H_2 Full Control Cost');
title('H_2 Full Control Cost for N = 1 to 10');
set(findall(gcf,'type','text'),'fontSize',24);
h_legend = legend('N=1','N=2','N=3','N=4','N=5','N=6','N=7','N=8','N=9','N=10','Location','EastOutside');
set(h_legend,'FontSize',18);

%calculate cauchy norm
%cauchyNorm = zeros(1,MaxMode-MinMode-1);
for i=4:MaxMode
    cauchyNorm(i) = (h2scores(i,:) - h2scores(i-1,:))*(h2scores(i,:) - h2scores(i-1,:))';
end
cauchyNorm
% figure(2)
% clf;
% hold on;
% plot(h2scores(3,:));
% plot(h2scores(4,:));
% hold off



