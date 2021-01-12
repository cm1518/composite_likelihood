% likelihood  and composite countours  for a ar(1)/ weighted average  of ar(1))
% check if composite  likelihood  makes  the countours  better  behaved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% example for  section 3.1 of  the  paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clc;
rng('default')

% basic  parameters
rhoa=0.7; % persistence
sig=1.0;  % standard  deviation

% parameters of  model B

% if  delta=1.0; gam=1.0  CL>L same curvature
% if  delta>1.0 increased  curvature around  the  true  value
% if delta<1.0 not  much  difference
% if gamma<1.0 more  curvature
% if gamma>1.0  less  curvature/ not  much  difference
% if  delta>1, gamma<1  setting om<0.5  makes  Cl  more  peaked

del=1.2; %0.7, 1.3
gam=0.8; %0.8, 1.2

% composite weight
om=0.7; %0.3, 0.7

T1=200;
d=20;    % sample size
ssize=1; % relative  size  of  data  of  model  2
steps=40;

y=zeros(T1,1); z=y;
 y(1)=0.0;
 z(1)=0.0;
 for j=2:T1
     y(j)=rhoa*y(j-1)+sig*randn(1);
     z(j)=rhoa*del*z(j-1)+sig*gam*randn(1);
 end
 
 % calculation of  likelihood  and  compositie  likelihood
 % AR1 parameter
 x=y(T1-d:T1);    w=z(T1-ssize*d:T1);
 TT1=length(x)-1; TT2=length(w)-1;
 l1=zeros(TT1,1); l2=zeros(TT2,1);
 rhop=zeros(steps,1); ll1=rhop; ll2=ll1; ll=ll1; llx=l1;
 for  i=1:steps
     l1(i,1)=0.0;
     l2(i,1)=0.0;
     for t=2:TT1
         rhop(i)=0.10+0.02*i;
         l1(i,t)=l1(i,t-1)-log(sig)-((x(t)-rhop(i)*x(t-1))^2)/(2*sig^2) ;
     end
     for t=2:TT2
         l2(i,t)=l2(i,t-1)-log(sig*gam)-((w(t)-rhop(i)*del*w(t-1))^2)/(2*(sig*gam)^2) ;         
     end
     ll1(i)=l1(i,TT1);      ll2(i)=l2(i,TT2);
     ll(i)=om*ll1(i)+(1-om)*ll2(i);
 end

 % tripling  the sample size of  second model
 x=y(T1-d:T1);  w=z(T1-3*d:T1);
 TT1=length(x)-1;  TT2=length(w)-1;
 for  i=1:steps
     l1(i,1)=0.0;
     l2(i,1)=0.0;
     for t=2:TT1
         rhop(i)=0.10+0.02*i;
         l1(i,t)=l1(i,t-1)-log(sig)-((x(t)-rhop(i)*x(t-1))^2)/(2*sig^2) ;
     end
     for t=2:TT2
         l2(i,t)=l2(i,t-1)-log(sig*gam)-((w(t)-rhop(i)*del*w(t-1))^2)/(2*(sig*gam)^2) ;         
     end
     ll1(i)=l1(i,TT1);      ll2(i)=l2(i,TT2);
     llx(i)=om*ll1(i)+(1-om)*ll2(i);
 end

 subplot(1,2,1)
 % dum(1:40)=0;  % dum(28)=40;
  plot(rhop,ll1, rhop,ll, rhop,llx, 'linewidth',2);   hold off;   axis tight;
  xlabel('\rho_A')
  ylabel('likelihood/composite')
 % legend('likelihood', 'composite  likelihood T_B=T_A', 'composite likelihood T_B=3*T_A')
  
 % standard deviation parameter
 x=y(T1-d:T1); w=z(T1-ssize*d:T1);
 TT2=TT1;
 sigp=zeros(steps,1);
   for  i=1:steps
     l1(i,1)=0.0;
     l2(i,1)=0.0;
     for t=2:TT1
         sigp(i)=0.5+0.025*i;
         l1(i,t)=l1(i,t-1)-log(sigp(i))-((x(t)-rhoa*x(t-1))^2)/(2*sigp(i)^2) ;
     end
     for t=2:TT2
         l2(i,t)=l2(i,t-1)-log(sigp(i)*gam)-((w(t)-rhoa*del*w(t-1))^2)/(2*(sigp(i)*gam)^2) ;         
     end
     ll1(i)=l1(i,TT1);     ll2(i)=l2(i,TT2);
     ll(i)=om*ll1(i)+(1-om)*ll2(i);
   end
 
 % tripling sample size  
 x=y(T1-d:T1); w=z(T1-3*d:T1);
 TT1=length(x)-1; TT2=length(w)-1;
   for  i=1:steps
     l1(i,1)=0.0;
     l2(i,1)=0.0;
     for t=2:TT1
         sigp(i)=0.5+0.025*i;
         l1(i,t)=l1(i,t-1)-log(sigp(i))-((x(t)-rhoa*x(t-1))^2)/(2*sigp(i)^2) ;
     end
     for t=2:TT2
         l2(i,t)=l2(i,t-1)-log(sigp(i)*gam)-((w(t)-rhoa*del*w(t-1))^2)/(2*(sigp(i)*gam)^2) ;         
     end
     ll1(i)=l1(i,TT1);
     ll2(i)=l2(i,TT2);
     llx(i)=om*ll1(i)+(1-om)*ll2(i);
   end
 subplot(1,2,2)
 % dum(1:40)=0; % dum(28)=40;
  plot(sigp,ll1, sigp,ll,sigp,llx, 'linewidth', 2);   hold off;   axis tight;
  xlabel('\sigma_A')
  ylabel('likelihood/composite')
  legend('likelihood', 'composite  likelihood T_B=T_A', 'composite likelihood T_B=3*T_A')
  
