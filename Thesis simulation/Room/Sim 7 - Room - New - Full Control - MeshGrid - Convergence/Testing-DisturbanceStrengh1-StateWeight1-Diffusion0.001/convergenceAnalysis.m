clc;
clear;

%dividing by 1.77 for each time refinment of the mesh, makes it look good
load('roomSimulation-AllTheVariables-Res0.2.mat');
h1 = h2scores;

figure(1);
contourf(senXPos,senYPos,h1');
contourcbar;  

load('roomSimulation-AllTheVariables-Res0.1.mat');
h2 = h2scores;
figure(2);
contourf(senXPos,senYPos,h2');
contourcbar;  

load('roomSimulation-AllTheVariables-Res0.05.mat');
h3 = h2scores;
figure(3);
contourf(senXPos,senYPos,h3');
contourcbar;  




% sum = 0;
% for i = 1:size(h2scores,1)
%     for j = 1:size(h2scores,2)
%          if (~isnan(h2scores(i,j)))
%             sum = sum +  h2scores(i,j)^2;
%          end
%     end
% end
% h1= h1/sqrt(sum);