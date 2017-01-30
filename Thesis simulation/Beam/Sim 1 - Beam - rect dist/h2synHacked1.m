function [k,g,GAM,INFO]=h2syn(plant,p2,m2)
%H2SYN  H2 controller synthesis.
%
% [K,CL,GAM,INFO]=H2SYN(P,NMEAS,NCON)  
% [K,CL,GAM,INFO]=H2SYN(MKTITO(P,NMEAS,NCON)))
%     Calculates the H2 optimal controller K and the closed loop
%     system CL=LFT(P,K).  NMEAS and NCON are the dimensions of 
%     the measurement outputs from P and the controller inputs to P.
%  
%     inputs:
%       P    -   LTI two-port plant 
%       NMEAS   -   measurement outputs from plant to controller
%       NCON    -   control inputs to plant from controller
% 
% 
%     outputs:
%       K    -  H2 optimal controller
%       CL   -  closed-loop system CL=LFT(P,K)
%       GAM  -  GAM = H2NORM(CL) 
%       INFO -  struct array with various information, such as
%               NORMS  -  norms of 4 different quantities, full 
%                         information control cost (FI), output estimation
%                         cost (OEF), direct feedback cost (DFL) and full
%                         control cost (FC).  NORMS = [FI OEF DFL FC]; 		                  
%               KFI    -  full information/state feedback control law
%               GFI    -  full information/state feedback closed-loop 
%               HAMX   -  X Hamiltonian matrix
%               HAMY   -  Y Hamiltonian matrix
%
%     Comment:  For discrete plants and for continuous plants
%               zero feedthrough term (D11 = 0), 
%               GAM =sqrt(FI^2 + OEF^2+ trace(D11*D11'));
%               otherwise, GAM is infinite
% 
%     See also: AUGW, HINFSYN, LTI/NORM, LTRSYN 

% Copyright 2003-2005 The MathWorks, Inc.

% Based on mutools h2syn.m 
% Modified by M. G. Safonov 11/02/2002 for LTI
% Discrete-time (Ts~=0) capability added by M. G. Safonov 11/15/02

nag1=nargin;
nag2=nargout;
k = [];
g = [];
GAM = [];
INFO = [];
%  for tito plant, extract nmeas and ncon...
switch nag1
    case 0
        help h2syn
    case 1
        [tito,U1,U2,Y1,Y2]=istitoHacked1(plant);
        if ~tito, 
            error('You must specify NMEAS and NCON'), 
        end
        m2=length(U2);
        p2=length(Y2);
        nag1 = 3;
    case 2
        error('You must specify both NMEAS and NCON'), 
end

%% initialize control cost matrxix RR and sensor noise matrix TH 
%% RR = eye(m2);
%% TH = eye(p2);

%%%%%%%%%%%%%%%%%% old h2syn with modifications
% function [k,g,norms,kfi,gfi,hamx,hamy] = h2syn(plant,p2,m2,ricmethod,quiet)

if nag1 < 3,
  disp('usage: [k,g,norms,kfi,gfi,hamx,hamy] = h2syn(plant,nmeas,ncon,ricmethod)')
  return
end

%    check the dimensions and assumptions of the problem.
%    D11 must be zero, and here we will assume that D22 is
%    also zero.  D12 and D21 must also be of appropriate rank.

% % [a,b,c,d] = unpck(plant);
[a,b,c,d,Ts] = ssdata(plant);
Ts=~isequal(Ts,0);  % % Ts=0 if continous, 1 if discrete
% % [anom,bnom,cnom,dnom] = ssdata(plant);
[anom,bnom,cnom,dnom,Tsnom] = ssdata(plant);
nx = max(size(a));
[i,m] = size(b);
[p,i] = size(c);
if m <= m2,
  disp('control input dimension incorrect')
  return
end
if p <= p2,
  disp('measurement output dimension incorrect')
  return
end
p1 = p - p2;
m1 = m - m2;

%    now introduce a unitary scaling (qin, qout) on the inputs and outputs,
%    and a change of basis (tin, tout) on the controller measurements
%    and controls.  This means that the d term meets the assumptions
%    of the formulae.

%    select out the d12 and d21 terms.

d12 = d(1:p1,m1+1:m);
d21 = d(p1+1:p,1:m1);

%    get qout and rin such that [qout*d12*rin] = [0;I]
%    This is done by rearranging the result of a qr decomposition.

[q,r] = qr(d12);
if rank(r) ~= m2,
 disp('d12 does not have full column rank')
 return
end
qout = [q(:,(m2+1):p1),q(:,1:m2)]';
rin = eye(m2)/(r(1:m2,:));

%    get qin and rout such that [rout*d21*qin] = [0,I]
%    Again this is done by rearranging the result of a qr decomposition.

[q,r] = qr(d21');
if rank(r) ~= p2,
    disp('d21 does not have full row rank')
    return
    end
qin = [q(:,(p2+1):m1),q(:,1:p2)];
rout = eye(p2)/(r(1:p2,:)');

%    now scale the inputs and outputs appropriately
%    Note that the controller scaling (rin, rout) must
%    be included in the calculation of k.  qin and qout
%    do not affect the assumptions of the problem.

c = blkdiag(qout,rout)*c;
b = b*blkdiag(qin,rin);
d = blkdiag(qout,rout)*d*blkdiag(qin,rin);

%    now decompose the new system into its appropriate parts

c1 = c(1:p1,:);
c2 = c(p1+1:p,:);
b1 = b(:,1:m1);
b2 = b(:,m1+1:m);

%  d12 and d21 are hardwired to the form obtained by the scaling and
%  unitary transformation above.  This will help eliminate rounding errors.

d11 = d(1:p1,1:m1);
d12 = [zeros(p1-m2,m2);eye(m2)];
d21 = [zeros(p2,m1-p2),eye(p2)];
d22 = d(p1+1:p,m1+1:m);

%    now form the hamiltonian for X2
Ah = a - b2*d12'*c1;
Eh = blkdiag(eye(p1-m2),zeros(m2,m2));
% hamx = [Ah, -b2*b2'; -c1'*Eh*c1, -Ah']; % continuous-time

%    now form the hamiltonian for Y2
Aj = a - b1*d21'*c2;
Ej = blkdiag(eye(m1-p2),zeros(p2,p2));
Ej = 1; % hacked
% hamy = [Aj', -c2'*c2; -b1*Ej*b1', -Aj]; % continuous-time

        
% Solve the X2 and Y2 Riccati equations
hw = ctrlMsgUtils.SuspendWarnings; %#ok<NASGU> % For Riccati warnings
if Ts,
   %    [X2a,LXa,f2a] = dare(a,b2,c1'*c1,d12'*d12,c1'*d12) ;  
   %    [Y2a,LYa,h2aprime] = dare(a',c2',b1*b1',d21*d21',b1*d21');    
   [X2,LX,f2c,reportx2] = dare(Ah,b2,c1'*Eh*c1) ;    
   [Y2,LY,h2c,reporty2] = dare(Aj',c2',b1*Ej*b1');    
   f2 = -d12'*c1 - f2c  ;  % f2 = -f2a
   h2 = -b1*d21' - h2c' ;  % h2 = -h2aprime'
else
   % [X2a,LXa,f2a] = care(a,b2,c1'*c1,d12'*d12,c1'*d12);
   % [Y2a,LYa,h2aprime] = care(a,c2',b1*b1',Td21*d21',b1*d21'); 

   % XXXX: This causes a numerical warning: 
   %   "Warning: Solution may be inaccurate due to poor scaling 
   %    or eigenvalues near the stability boundary."
   [X2,LX,f2c,reportx2] = care(Ah,b2,c1'*Eh*c1); 
   if reportx2 > sqrt(eps)
      [X2,LX,f2c,reportx2] = care(Ah,b2,c1'*Eh*c1,'nobalance');
   end
   [Y2,LY,h2c,reporty2] = care(Aj',c2',b1*Ej*b1');
   if reporty2 > sqrt(eps)
      [Y2,LY,h2c,reporty2] = care(Aj',c2',b1*Ej*b1','nobalance');
   end
   %    f2 = -d12'*c1 - b2'*X2;
   %    h2 = -b1*d21' - Y2*c2';
   f2 = -d12'*c1 - f2c ; % f2 = -f2a
   h2 = -b1*d21' - h2c'; % h2 = -h2aprime'
end

% include the scaling matrices into d22 feedback problem

ak = a + h2*c2 + b2*f2 + h2*d22*f2;

% This section of the code can be used to generate all controllers
%
% ak = a + h2*c2 + b2*f2 + h2*d22*f2;
% bk = [-h2, (h2*d22 + b2)];
% ck = [f2; (-d22*f2 - c2)];
% dk = [zeros(m2,p2), eye(m2,m2); eye(p2,p2), -d22];

% %  kgen = pck(ak,-h2,f2,zeros(m2,p2));
kgen = ss(ak,-h2,f2,zeros(m2,p2),Tsnom);

% % k = mmult(rin,mmult(kgen,rout));
k = rin*kgen*rout;
% g = starp(plant,k,p2,m2);
g = lft(plant,k,m2,p2);
%
% compute the h2norm GAM

if nag2 >= 3
    % GAM=sqrt(FI^2 + OEF^2+norm(d11,'fro')^2) ; % if discrete 
    % or if continuous and D11=0, else GAM=Inf
    GAM=normh2(g);
end
%
%
%  compute the INFO data
%

%       INFO -  struct array with various information, such as
%               NORMS  -  norms of 4 different quantities, full 
%                         information control cost (FI), output estimation
%                         cost (OEF), direct feedback cost (DFL) and full
%                         control cost (FC).  NORMS = [FI OEF DFL FC]; 		                  
%               KFI    -  full information/state feedback control law
%               GFI    -  full information/state feedback closed-loop 
%               HAMX   -  X Hamiltonian matrix
%               HAMY   -  Y Hamiltonian matrix
if nag2 >= 4
    FI  = sqrt(trace((b1)'*X2*(b1)));
    FC  = sqrt(trace((c1)*Y2*(c1)'));
    if Ts,  % discrete-time
        % hamx
        Sh=b2*b2';
        Qh=c1'*Eh*c1;
        hamx=[Ah+Sh/Ah'*Qh, -Sh/Ah'; -Ah'\Qh, inv(Ah')];
        
        % hamy
        Sj=c2'*c2;
        Qj=b1*Ej*b1';
        hamy=[Aj'+Sj/Aj*Qj, -Sj/Aj; -Aj\Qj, inv(Aj)];
                
        % OEF = sqrt(trace(RRwiggle*(f2)*Y2*(f2)'));
        OEF = sqrt(trace((d12'*c1 +  b2'*X2*a)*Y2*(-f2)'));
        
        % DFL = sqrt(trace(THwiggle*(h2)'*X2*(h2)));
        DFL = sqrt(trace((-h2)'*X2*(b1*d21' + a*Y2*c2')));
    else  % continuous-time
        hamx = [Ah, -b2*b2'; -c1'*Eh*c1, -Ah']; % hamiltonian for X2
        hamy = [Aj', -c2'*c2; -b1*Ej*b1', -Aj]; % hamiltonian for Y2
        OEF = sqrt(trace((f2)*Y2*(f2)'));
        DFL = sqrt(trace((h2)'*X2*(h2)));
    end
    norms = [ FI OEF DFL FC];
    afi = anom;
    bfi = bnom;
    cfi = [cnom(1:p1,1:nx); eye(nx)];
    dfi = [zeros(p1,m1) dnom(1:p1,m1+1:m); zeros(nx,m)];
    % % pfi = pck(afi,bfi,cfi,dfi);
    pfi=ss(afi,bfi,cfi,dfi,Tsnom);
    kfi = rin*f2;
    % % gfi = starp(pfi,kfi,nx,m2);
    gfi=lft(pfi,kfi,m2,nx);
    INFO=struct('NORMS',norms,'KFI',kfi,'GFI',gfi,'HAMX',hamx,'HAMY',hamy,...
       'ReportX2',reportx2,'ReportY2',reporty2);
end


%%%%%%%%  End of toolbox\robust\robust\@lti\h2syn %%%%%%%%
