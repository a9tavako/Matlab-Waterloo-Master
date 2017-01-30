function [A,Bact,Cinterval,Cpos]=beameg(N,numact,numsen,damping,actWidth,senWidth)
% PROBLEM CONSIDERED ....
% simply supported beam -  length one
% structural damping- chged to KV dampin
% damping, N is number of modes
% state variable is [wxx,wt] with size 2N
% numact num of acuators, evenly spaced, not on boundaries na < 10
% numsen num of sensors,  evenly spaced sensors  ns < 10;
% actWidth = 0.01;   %width of actuator and sensor 
% senWidth = 0.01;   

modebeam=pi*(1:N);

% different realization than Geromel- energy realization for better
% numerics
Omega1=diag(modebeam(1:N).^2);
Omega =diag(modebeam(1:N).^4);  % this is Kelvin-Voigt damping

A = zeros(2*N,2*N);
%A(1:N,1:N)=zeros(N,N);
A(1:N,N+1:2*N)=Omega1;
A(N+1:2*N,1:N)=-Omega1;
%A(N+1:2*N,N+1:2*N)=zeros(N,N);
%A(N+1:N,N+1:N)=-xi*eye(N);
A(N+1:2*N,N+1:2*N)=-damping*Omega;




actpozs=(1:numact)/(numact+1); % actuator positions
Bact=zeros(2*N,numact);
for i=1:N;
    for j=1:numact;
      %Bact(N+i,j)=sqrt(2)*sin(i*pi*r(j));  point actuator
      Bact(N+i,j)=(1/sqrt(2))*( cos(i*pi*(actpozs(j)-actWidth/2))-cos(i*pi*(actpozs(j) +actWidth/2)) )/(actWidth*i*pi);
   end;
end;


Qen(1:N,1:N)=eye(N);
%Qen(1:N,1:N)=inv(Omega1);
Qen(1:N,N+1:2*N)=zeros(N,N);
Qen(N+1:2*N,1:N)=zeros(N,N);
Qen(N+1:2*N,N+1:2*N)=zeros(N,N);
%Qen(N+1:N,N+1:N)=eye(N);

Cpos=[inv(Omega1) zeros(N,N)];
Qen=Cpos'*Cpos;


senpozs = (1:numsen)/(numsen+1); %sensor positions
Cinterval=zeros(length(senpozs),2*N);   %rewriting interval sensors from position basis to fourier basis
for k=1:numsen
    for i=1:N
       %Cpoint(1,i)=sqrt(2)*sin(i*pi*rp)/(i*pi)^2;
        Cinterval(k,i) = (1/sqrt(2))*( cos(i*pi*(senpozs(k)-senWidth)) - cos(i*pi*(senpozs(k)+senWidth)) )/(senWidth*i*pi);
    end
end




% %Froming the generalized plant
% B1 = [zeros(N,1);ones(N,1)];
% B2 = Bact; 
% B = [B1,B2];
% C1 = Cpos*1000; % to magnify effect of C1
% C2 = Cinterval*10000000; % to magnify effect of C2
% C  = [C1;C2];
% D11 = zeros(N,1);
% D12 = eye(N,na);
% %D21 = zeros(1,1); D21 must have full row rank
% D21 = eye(1,1);
% D22 = zeros(1,na);
% D   = [D11, D12 ; D21 , D22];
% %State space form
% [A,B;C,D];
% syst = ss(A, B, C,D);
% %make two input two output system
% syst = mktito(syst, 1,na); 


