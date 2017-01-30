clear all;
Length            = 5; %0.4573        ;%length
NumNode           = 30  ;%number of modes
Stiffness         = 0.491; %0.491      ;
MassDensity       = 0.093; %  0.093
DampingVis        = 0.0013;%0.0013     ;
DampingKV         = 0.0000649;%0.00000000000649  ;%0.0000649 
ActLoc            = Length*0.4 ; 
SenLoc            = Length*0.7 ; 
ActWidth          = Length*0.01; % 0.01
SenWidth          = Length*0.01;
StateWeight       = 1          ;%state weight in the cost function
ControlStrengh    = 1         ;%ControlStrengh is the norm of B2
DisturbanceEnergy = 10        ;
DisturbanceMean   = Length*0.25;%disturbance is a gaussian function
DisturbanceVar    = Length*0.05;
DistWeightOnMeasurement = 1    ; % must be one for unitary assumption of zhou page 376
NumLoc            = 100;    


h2scores = zeros(1,NumLoc);

for i=1:NumLoc
    SenLoc = Length*i/(NumLoc+1);

    [A,B1,B2,C1,C2,D11,D12,D21,D22] = beamGeneralizedPlant(Length,NumNode,Stiffness,MassDensity,DampingVis,DampingKV,...
        ActLoc,SenLoc,ActWidth,SenWidth,...
        StateWeight,ControlStrengh, DisturbanceEnergy, DisturbanceMean,DisturbanceVar,DistWeightOnMeasurement);

    h2scores(i)                     = calculateOutputFeedbackCost(A,B1,B2,C1,C2,D11,D12,D21,D22);
end


figure(1);
clf;
hold on;
n = NumLoc;
plot((1:n)*Length/(n+1),h2scores,'LineWidth',3);
xlabel('Sensor Position on Beam');
ylabel('H_2 Output Feedback Cost');
title(strcat('B1 scaled by',{' '} ,num2str(DisturbanceEnergy)));
set(findall(gcf,'type','text'),'fontSize',24);
yCross = min(h2scores);
CrossIndex = find(h2scores==yCross);
xCross = Length*CrossIndex/(NumLoc+1);
text(xCross, yCross, 'X', 'Color', [1,0,0],'FontSize', 24);
text(Length-xCross-0.08, yCross, 'X', 'Color', [1,0,0],'FontSize', 24);
hold off;




