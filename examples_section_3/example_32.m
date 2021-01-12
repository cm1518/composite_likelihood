% likelihood and composite countours for a NK / weighted average of NK+exogenous pc.
% want  to check if composite  likelihood  makes countours  better  behaved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% example for section 3.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc;
rng('default')

sigr=1.0; sigpi=1.0; sigy=1.0;
sigu1=1.0; sigu2=1.0;

bet=0.99;
rho=0.8;
gam=0.4; %slope  of  pc

om=0.90;

%1) case 1: sig=0.5
sig=0.5; %1/RRA coeff


T1=2000;
d=100;
steps=50;

ra=zeros(T1,1); ya=ra; pia=ra; res=ra; yb=ra; pib=ra;
yb(1)=0.0;  pib(1)=0.0; res(1)=0.0;
for j=2:T1
 % model 1
     ra(j)=sigr*randn(1);
     ya(j)=sig*sigr*randn(1)+sigy*randn(1);
     pia(j)=sig*gam*sigr*randn(1)+ sig*sigy*randn(1)+sigpi*randn(1);
% model 2 
     res(j)=sigu2*randn(1);
     yb(j)=rho*yb(j-1)+sigu1*randn(1);
     pib(j)=rho*pib(j-1)+(gam/(1-bet*rho))*sigu1*randn(1)+res(j)-rho*res(j-1);
end

  
 x=ya(T1-d:T1); w=pia(T1-d:T1); z=yb(T1-d:T1); q=pib(T1-d:T1);
 
 T=length(w)-1;

 l1=zeros(steps,1); l2=l1; gamp=l1; a4=l1; b4=l1;
 ll1=l1; ll2=l1; ll=l1;
 for  i=1:steps
     l1(i,1)=0.0;     l2(i,1)=0.0;
         gamp(i)=(gam-0.25)+0.01*i;
          a4(i)=sig*gamp(i)* sigr+ sig*sigy+sigpi;
          b4(i)=sqrt(((gamp(i)/(1-bet*rho))* sigu1)^2+(1-rho^2));
     
       for t=2:T
     % use  only  L(pi ) since  L(y)  is  independent  of  gamp(i).
           l1(i,t)=l1(i,t-1)-log(a4(i))-((w(t))^2)/(2*a4(i)^2) ;
           l2(i,t)=l2(i,t-1)-log(b4(i))-((q(t)-rho*q(t-1))^2)/(2*b4(i)^2) ;         
       end
     ll1(i)=l1(i,T);      ll2(i)=l2(i,T);
     ll(i)=om*ll1(i)+(1-om)*ll2(i);
 end
 
 
 subplot(1,2,1)
 % dum(1:40)=0;
 % dum(28)=40;

  plot(gamp,ll1,'b-',gamp,ll,'r:', 'linewidth',2);  axis tight;
  title('\sigma=0.5')
  xlabel('true \gamma=0.4')
  ylabel('likelihood/composite')
  legend('likelihood', 'composite  likelihood')

% case 2: sig=0.1  
sig=0.1;
 
yb(1)=0.0; pib(1)=0.0; res(1)=0.0;

for j=2:T1
 % model 1
     ra(j)=sigr*randn(1);
     ya(j)=sig*sigr*randn(1)+sigy*randn(1);
     pia(j)=sig*gam* sigr*randn(1)+ sig*sigy*randn(1)+sigpi*randn(1);
% model 2 
     res(j)=sigu2*randn(1);
     yb(j)=rho*yb(j-1)+sigu1*randn(1);
     pib(j)=rho*pib(j-1)+ (gam/(1-bet*rho))* sigu1*randn(1)+res(j)-rho*res(j-1);
end

 
 
  
% x=ya(T1-d:T1);  w=pia(T1-d:T1);  z=yb(T1-d:T1);  q=pib(T1-d:T1);
 
 T=length(w)-1;

 for  i=1:steps
     l1(i,1)=0.0;
     l2(i,1)=0.0;
         gamp(i)=(gam-0.25)+0.01*i;
         a4(i)=sig*gamp(i)* sigr+ sig*sigy+sigpi;
         b4(i)=sqrt(((gamp(i)/(1-bet*rho))* sigu1)^2+(1-rho^2));
     for t=2:T
         % use  only  L(pi) since  L(y) is  independent  of  gamp.
         l1(i,t)=l1(i,t-1)-log(a4(i))-((w(t))^2)/(2*a4(i)^2) ;
         l2(i,t)=l2(i,t-1)-log(b4(i))-((q(t)-rho*q(t-1))^2)/(2*b4(i)^2) ;         
     end
     ll1(i)=l1(i,T);     ll2(i)=l2(i,T);
     ll(i)=om*ll1(i)+(1-om)*ll2(i);
 end
 
 subplot(1,2,2)
 % dum(1:40)=0;
 % dum(28)=40;
  plot(gamp,ll1,'b-',gamp,ll,'r:', 'linewidth',2); axis tight;
  title('\sigma=0.1')
  xlabel('true \gamma=0.4')
  ylabel('likelihood/composite')
  legend('likelihood', 'composite  likelihood')


  
  
  
  
 