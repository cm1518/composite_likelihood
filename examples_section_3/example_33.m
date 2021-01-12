% plot  of  likelihood for  singularity  problems
% example with  dividend and  stock  prices  driven  by  just  one  shock
% solution
% d(t) = e(t)-alpha e(t-1);
% p(t) = (1-beta* alpha)e(t)-alpha e(t-1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% example section 3.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all; clc;
rng('default')

sige=1.0;
bet=0.99;

om=0.5;

T1=2000;
tau=100;
steps=50;

% case  1: alph=0.7
alph=0.7;


% simulating  data
res=zeros(T1,1); d=res;p=res;
d(1)=0.0; p(1)=0.0; res(1)=0.0;

for j=2:T1
   res(j)=sige*randn(1);
   d(j)=res(j)-alph*res(j-1);
   p(j)=(1.0/(1-bet*alph))*((1-bet*alph)*res(j) -alph* res(j-1));
end
 
%b1=mean(d); %b2=std(d);
%b3=mean(p); %b4=std(p);

x=d(T1-tau:T1);  y=p(T1-tau:T1);
T=length(x)-1;   T2=length(y)-1;

% computing  likelihood / complosite  likelihood
ld=zeros(steps,T);lp=ld; 
alp=zeros(steps,1); gam=alp;
frac1=zeros(steps,T); frac2=frac1; frac3=frac1; 
frac4=frac1; frac5=frac1; frac6=frac1;
dt=zeros(steps,1); pt=dt;
ratio2=zeros(steps, T); ratio4=ratio2;
ll1=zeros(steps,1); ll2=ll1; ll=ll1;
for  i=1:steps
     ld(i,1)=0.0;
     lp(i,1)=0.0;
     
         alp(i)=(alph-0.3)+0.01*i;
         gam(i)= alp(i)/((1-bet*alp(i)));
                  
         frac1(i,1)=0.0;         frac2(i,1)=0.0;
         frac3(i,1)=0.0;         frac4(i,1)=0.0;
         frac5(i,1)=0.0;         frac6(i,1)=0.0;

         frac1(i,2)=1.0;
         frac2(i,2)=1+alp(i)^2;
         frac3(i,2)=1+alp(i)^2+alp(i)^4;
         frac4(i,2)=1.0;
         frac5(i,2)=1+gam(i)^2;
         frac6(i,2)=1+gam(i)^2+gam(i)^4;
         
         dt(i,1)=d(1);         pt(i,1)=p(1);
         
          for t=3:T
              frac1(i,t)= frac1(i,t-1)+alp(i)^(2*(t-2));
              frac2(i,t)= frac2(i,t-1)+alp(i)^(2*(t-1));
              frac3(i,t)= frac3(i,t-1)+alp(i)^(2*t);
              frac4(i,t)= frac4(i,t-1)+gam(i)^(2*(t-2));
              frac5(i,t)= frac5(i,t-1)+gam(i)^(2*(t-1));
              frac6(i,t)= frac6(i,t-1)+gam(i)^(2*t);
          end
       
           ratio2(i,1)=0.0;           ratio4(i,1)=0.0;
           
          for t=2:T
               ratio2(i,t)=sige^2*(frac3(i,t)/frac2(i,t));
               ratio4(i,t)=sige^2*(frac6(i,t)/frac5(i,t));
               pt(i,t)=p(t)-gam(i)*(frac3(i,t)/frac4(i,t))*pt(i,t-1);
               dt(i,t)=d(t)-alp(i)*(frac1(i,t)/frac2(i,t))*dt(i,t-1);     
          end
          
          for  t=2:T
          ld(i,t)=ld(i,t-1)-log(ratio2(i,t))-0.5*((dt(i,t))^2)/(ratio2(i,t));
          lp(i,t)=lp(i,t-1)-log(ratio4(i,t))-0.5*((pt(i,t))^2)/(ratio4(i,t));
          end
 
     ll1(i)=ld(i,T);     ll2(i)=lp(i,T);
     ll(i)=om*ll1(i)+(1-om)*ll2(i);
 end
 
 
 subplot(1,2,1)
  plot(alp,ll1, 'b-',alp,ll2,'r-',alp, ll,'k:', 'linewidth',2);  axis tight;
%  title('\sigma_e=1.0')
  xlabel(' true \alpha=0.7')
  ylabel('likelihood/composite')
  legend('likelihood d(t)', 'likelihood p(t)', 'composite  likelihood')


  
% case 2: alph=0.1
alph=0.1;

% simulating  data
d(1)=0.0; p(1)=0.0; res(1)=0.0;

for j=2:T1
  res(j)=sige*randn(1);
   d(j)=res(j)-alph*res(j-1);
   p(j)=(1.0/(1-bet*alph))*((1-bet*alph)*res(j) -alph* res(j-1));
end
 
%b1=mean(d); %b2=std(d);
%b3=mean(p); %b4=std(p);

% constructing  likelihood
x=d(T1-tau:T1);
y=p(T1-tau:T1);
T=length(x)-1;
 
 for  i=1:steps
     ld(i,1)=0.0;
     lp(i,1)=0.0;
     
         alp(i)=(alph-0.35)+0.01*i;
         gam(i)= alp(i)/((1-bet*alp(i)));
                  
         frac1(i,1)=0.0;         frac2(i,1)=0.0;
         frac3(i,1)=0.0;         frac4(i,1)=0.0;
         frac5(i,1)=0.0;         frac6(i,1)=0.0;

         frac1(i,2)=1.0;
         frac2(i,2)=1+alp(i)^2;
         frac3(i,2)=1+alp(i)^2+alp(i)^4;
         frac4(i,2)=1.0;
         frac5(i,2)=1+gam(i)^2;
         frac6(i,2)=1+gam(i)^2+gam(i)^4;
         
         
         dt(i,1)=d(1);         pt(i,1)=p(1);
         
          for t=3:T
              frac1(i,t)= frac1(i,t-1)+alp(i)^(2*(t-2));
              frac2(i,t)= frac2(i,t-1)+alp(i)^(2*(t-1));
              frac3(i,t)= frac3(i,t-1)+alp(i)^(2*t);
              frac4(i,t)= frac4(i,t-1)+gam(i)^(2*(t-2));
              frac5(i,t)= frac5(i,t-1)+gam(i)^(2*(t-1));
              frac6(i,t)= frac6(i,t-1)+gam(i)^(2*t);
          end
       
           ratio2(i,1)=0.0;           ratio4(i,1)=0.0;
           
          for t=2:T
               ratio2(i,t)=sige^2*(frac3(i,t)/frac2(i,t));
               ratio4(i,t)=sige^2*(frac6(i,t)/frac5(i,t));
               pt(i,t)=p(t)-gam(i)*(frac3(i,t)/frac4(i,t))*pt(i,t-1);
               dt(i,t)=d(t)-alp(i)*(frac1(i,t)/frac2(i,t))*dt(i,t-1);     
          end
          
          for  t=2:T
           ld(i,t)=ld(i,t-1)-log(ratio2(i,t))-0.5*((dt(i,t))^2)/(ratio2(i,t));
           lp(i,t)=lp(i,t-1)-log(ratio4(i,t))-0.5*((pt(i,t))^2)/(ratio4(i,t)) ;
          end
   
     ll1(i)=ld(i,T);     ll2(i)=lp(i,T);
     ll(i)=om*ll1(i)+(1-om)*ll2(i);
 end
 
 
 subplot(1,2,2)
  plot(alp,ll1,'b-',alp,ll2,'r-',alp, ll,'k:', 'linewidth',2);  axis tight;
 %title('\sigma_e=0.1')
  xlabel('true \alpha=0.1')
  ylabel('likelihood/composite')
  legend('likelihood d(t)', 'likelihood p(t)', 'composite  likelihood')
