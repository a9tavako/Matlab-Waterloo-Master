
load('roomSimulation-AllTheVariables-Res0.2-C2Normalized.mat');
scores1 = h2scores;

load('roomSimulation-AllTheVariables-Res0.1-C2Normalized.mat');
scores2 = h2scores;

% load('roomSimulation-AllTheVariables-0.05.mat');
% scores3 = h2scores;
% 
% ratios1 = zeros(size(scores1));
% ratios2 = zeros(size(scores1));
% ratios3 = zeros(size(scores1));
% 
% for i=1:size(ratios1,1)
%     for j=1:size(ratios1,2)
%         ratios1(i,j) = scores2(2*i,2*j)/scores1(i,j);
%         ratios2(i,j) = scores3(4*i,4*j)/scores2(2*i,2*j);
%         ratios3(i,j) = scores3(4*i,4*j)/scores1(i,j);
%     end
% end

min(min(scores1))
min(min(scores2))