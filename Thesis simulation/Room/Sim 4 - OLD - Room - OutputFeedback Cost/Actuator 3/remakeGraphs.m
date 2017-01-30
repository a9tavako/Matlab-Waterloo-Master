clear; clc;
load('roomSimulation-AllTheVariables');

contourf(senXPos,senYPos,h2scores')                  ; % plotting the results, 2D color map
contourcbar                                          ;
title('H_2 Output Feedback Cost') ;
xlabel('X coordinate of sensor')                     ;
ylabel('Y coordinate of sensor')                     ;
set(findall(gcf,'type','text'),'fontSize',16)        ;