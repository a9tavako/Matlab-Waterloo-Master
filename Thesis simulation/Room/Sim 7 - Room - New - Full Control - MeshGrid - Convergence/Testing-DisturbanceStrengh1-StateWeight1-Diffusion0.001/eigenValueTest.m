% load('A-0.2.mat');
% [V,D1] = eigs(A);
% 
% load('A-0.1.mat');
% [V,D2] = eigs(A);
% 
% load('A-0.05.mat');
% [V,D3] = eigs(A);
% 
% load('A-0.025.mat');
% [V,D4] = eigs(A);
% 
% save('EigenValues','D1','D2','D3','D4');
D2(1,1)/D1(1,1)
D3(1,1)/D2(1,1)
D4(1,1)/D3(1,1)



