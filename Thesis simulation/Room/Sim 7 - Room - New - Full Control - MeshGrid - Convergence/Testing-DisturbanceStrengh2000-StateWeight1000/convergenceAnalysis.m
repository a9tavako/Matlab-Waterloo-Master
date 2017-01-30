clc;
clear;

normalized = 100000;
load('roomSimulation-AllTheVariables-Res0.2.mat');
h1 = h2scores/normalized;
figure(1);
contourf(senXPos,senYPos,h1');
contourcbar;  

load('roomSimulation-AllTheVariables-Res0.1.mat');
h2 = h2scores/normalized;
figure(2);
contourf(senXPos,senYPos,h2');
contourcbar;  

load('roomSimulation-AllTheVariables-Res0.05.mat');
h3 = h2scores/normalized;
figure(3);
contourf(senXPos,senYPos,h3');
contourcbar;  