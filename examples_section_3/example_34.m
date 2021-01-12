% composite  likelihood  for  multicountry scale model
% multicountry  consumption smoothing  model  where  income comes  from
% every  country  but  saving is done  domestically.
% composite  likelihood  uses  the  likelihood  of  the domestic  model  
% (neglects  that income comes  from  different countries)
% use only consumption data to construct  the  likelihood/composite

% likelihood  is  not quadratic  in  rho since rho=-1 makes  the
% coefficient in front  of  income  = r/(2+r), rho=0 makes  it  =  r/(1+r)
% and rho=1 makes  equal  to  1. so likelihood will fall as rho  increases
% from  -1  to  1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% example  section 3.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc;
rng('default')

n=3; % number of countries
sige1=.1;  sige2=.2;  sige3=.3;
bet=0.99;  r=1/bet-1; rho=0.45;


const=0.01; % constant  in  income  process
opt=1;      % regulates if consumption or income is used in the likelihood

wom1=[0.5 0.25  0.25];
wom2=[0.25 0.5  0.25];
wom3=[0.25 0.25 0.5];

T1=20000;
tau=10000;
steps=50;

% simulating data 
z1=zeros(T1,1); z2=z1;z3=z1; y1=z1;y2=z1; y3=z1;
w1=z1; w2=z1; w3=z1; c1=z1; c2=z1; c3=z1; a1=z1; a2=z1; a3=z1;

c1(1)=0.0; c2(1)=0.0; c3(1)=0.0;
y1(1)=0.0; y2(1)=0.0; y3(1)=0.0;
w1(1)=0.0; w2(1)=0.0; w3(1)=0.0;
a1(1)=1.0; a2(1)=1.0; a3(1)=1.0;
for j=2:T1  
    z1(j)=sige1*randn(1);
    z2(j)=sige2*randn(1);
    z3(j)=sige3*randn(1);
    y1(j)=const+rho*y1(j-1)+z1(j);
    y2(j)=const+rho*y2(j-1)+z2(j);
    y3(j)=const+rho*y3(j-1)+z3(j);
    w1(j)=wom1(1)*y1(j)+wom1(2)*y2(j)+wom1(3)*y3(j);
    w2(j)=wom2(1)*y1(j)+wom2(2)*y2(j)+wom2(3)*y3(j);
    w3(j)=wom3(1)*y1(j)+wom3(2)*y2(j)+wom3(3)*y3(j);
    c1(j)=r/(1+r)*a1(j-1)+r/(1-rho+r)*w1(j);
    c2(j)=r/(1+r)*a2(j-1)+r/(1-rho+r)*w2(j);
    c3(j)=r/(1+r)*a3(j-1)+r/(1-rho+r)*w3(j);
    a1(j)=(1+r)*(a1(j-1))+w1(j)-c1(j);
    a2(j)=(1+r)*(a2(j-1))+w2(j)-c2(j);
    a3(j)=(1+r)*(a3(j-1))+w3(j)-c3(j);
end
    
% computing  likelihoods/ composite  likelihood
cc1=c1(T1-tau:T1); cc2=c2(T1-tau:T1); cc3=c3(T1-tau:T1);
aa1=a1(T1-tau:T1); aa2=a2(T1-tau:T1); aa3=a3(T1-tau:T1);
yy1=y1(T1-tau:T1); yy2=y2(T1-tau:T1); yy3=y3(T1-tau:T1);
zz1=z1(T1-tau:T1); zz2=z2(T1-tau:T1); zz3=z3(T1-tau:T1);
T=length(cc1)-1;

ld1=zeros(steps,1); ld2=ld1; ld3=ld1; lt=ld1;rhop=ld1; 
yd1=zeros(steps,T); yd2=yd1; yd3=yd1;
b1=ld1; b2=ld1; b3=ld1; b4=ld1; b5=ld1; b6=ld1;
tb1=ld1; tb2=ld1; tb3=ld1; tb4=ld1; tb5=ld1; tb6=ld1;
cd1=yd1; cd2=yd1; cd3=yd1; ad1=yd1; ad2=yd1; ad3=yd1;
tcd1=yd1; tcd2=yd1; tcd3=yd1; tad1=yd1; tad2=yd1; tad3=yd1;
wd1=yd1; wd2=yd1; wd3=yd1; 
ll1=ld1; ll2=ld1; ll3=ld1; llcl=ld1; ll=ld1;
for  i=1:steps
     ld1(i,1)=0.0;      ld2(i,1)=0.0;      ld3(i,1)=0.0;     lt(i,1)=0.0;
     
         rhop(i)=(rho-1.49)+0.04*i;
         yd1(i,1)=y1(T1-tau-1);         yd2(i,1)=y2(T1-tau-1);
         yd3(i,1)=y3(T1-tau-1);
        
         cd1(i,1)=c1(T1-tau-1);   cd2(i,1)=c2(T1-tau-1); 
         cd3(i,1)=c3(T1-tau-1);  
         ad1(i,1)=a1(T1-tau-1);   ad2(i,1)=a2(T1-tau-1);
         ad3(i,1)=a3(T1-tau-1);
         
         tcd1(i,1)=c1(T1-tau-1);  tcd2(i,1)=c2(T1-tau-1);
         tcd3(i,1)=c3(T1-tau-1); 
         tad1(i,1)=a1(T1-tau-1);  tad2(i,1)=a2(T1-tau-1);
         tad3(i,1)=a3(T1-tau-1);
         
         for  t=2:T
         yd1(i,t)=const+rhop(i)*yd1(i,t-1)+zz1(t);
         yd2(i,t)=const+rhop(i)*yd2(i,t-1)+zz2(t);
         yd3(i,t)=const+rhop(i)*yd3(i,t-1)+zz3(t);
         
         wd1(i,t)=wom1(1)*yd1(i,t)+wom1(2)*yd2(i,t)+wom1(3)*yd3(i,t);
         wd2(i,t)=wom2(1)*yd1(i,t)+wom2(2)*yd2(i,t)+wom2(3)*yd3(i,t);
         wd3(i,t)=wom3(1)*yd1(i,t)+wom3(2)*yd2(i,t)+wom3(3)*yd3(i,t);

         cd1(i,t)=r/(1+r)*ad1(i,t-1)+r/(1-rho+r)*yd1(i,t);
         cd2(i,t)=r/(1+r)*ad2(i,t-1)+r/(1-rho+r)*yd2(i,t);
         cd3(i,t)=r/(1+r)*ad3(i,t-1)+r/(1-rho+r)*yd3(i,t);
         
%         pcd1(i,t)=r/(1+r)*ad1(i,t-1);  % predictable  at  t-1
%         pcd2(i,t)=r/(1+r)*ad2(i,t-1);
%         pcd3(i,t)=r/(1+r)*ad3(i,t-1);
         
%         ucd1(i,t)=(r/(1-rho+r)*yd1(i,t))^2;  % unpredictable at  t-1
%         ucd2(i,t)=(r/(1-rho+r)*yd2(i,t))^2;
%         ucd3(i,t)=(r/(1-rho+r)*yd3(i,t))^2;
         
         ad1(i,t)=(1+r)*(ad1(i,t-1))+yd1(i,t)-cd1(i,t);
         ad2(i,t)=(1+r)*(ad2(i,t-1))+yd2(i,t)-cd2(i,t);
         ad3(i,t)=(1+r)*(ad3(i,t-1))+yd3(i,t)-cd3(i,t);
         
         tcd1(i,t)=r/(1+r)*tad1(i,t-1)+r/(1-rho+r)*wd1(i,t);
         tcd2(i,t)=r/(1+r)*tad2(i,t-1)+r/(1-rho+r)*wd2(i,t);
         tcd3(i,t)=r/(1+r)*tad3(i,t-1)+r/(1-rho+r)*wd3(i,t);

%         ptcd1(i,t)=r/(1+r)*tad1(i,t-1);  % predictable
%         ptcd2(i,t)=r/(1+r)*tad2(i,t-1);
%         ptcd3(i,t)=r/(1+r)*tad3(i,t-1);

%         utcd1(i,t)=(r/(1-rho+r)*wd1(i,t))^2;  % unpredictable
%         utcd2(i,t)=(r/(1-rho+r)*wd2(i,t))^2;
%         utcd3(i,t)=(r/(1-rho+r)*wd3(i,t))^2;

         
         tad1(i,t)=(1+r)*(tad1(i,t-1))+wd1(i,t)-tcd1(i,t);
         tad2(i,t)=(1+r)*(tad2(i,t-1))+wd2(i,t)-tcd2(i,t);
         tad3(i,t)=(1+r)*(tad3(i,t-1))+wd3(i,t)-tcd3(i,t);
        
         end
         
         
         
         if  opt==1
        b1(i)=mean(cd1(i,:),2);        b2(i)=std(cd1(i,:));
        b3(i)=mean(cd2(i,:),2);        b4(i)=std(cd2(i,:));
        b5(i)=mean(cd3(i,:),2);        b6(i)=std(cd3(i,:));
        
       tb1(i)=mean(tcd1(i,:),2);       tb2(i)=std(tcd1(i,:));
       tb3(i)=mean(tcd2(i,:),2);       tb4(i)=std(tcd2(i,:));
       tb5(i)=mean(tcd3(i,:),2);       tb6(i)=std(tcd3(i,:));
         
       for  t=2:T
         ld1(i,t)=ld1(i,t-1)-log(b2(i))-0.5*((cd1(i,t)-b1(i))^2)/(b2(i)^2);
         ld2(i,t)=ld2(i,t-1)-log(b4(i))-0.5*((cd2(i,t)-b3(i))^2)/(b4(i)^2);
         ld3(i,t)=ld3(i,t-1)-log(b6(i))-0.5*((cd3(i,t)-b5(i))^2)/(b6(i)^2);

         lt(i,t)=lt(i,t-1)-log(tb2(i))-0.5*((tcd1(i,t)-tb1(i))^2)/(tb2(i)^2)...
           -log(tb4(i))-0.5*((tcd2(i,t)-tb3(i))^2)/(tb4(i)^2)-log(tb6(i))-0.5*((tcd3(i,t)-tb5(i))^2)/(tb6(i)^2);
        end

         else
        b1(i)=mean(yd1(i,:),2);     b2(i)=std(yd1(i,:));
        b3(i)=mean(yd2(i,:),2);     b4(i)=std(yd2(i,:));
        b5(i)=mean(yd3(i,:),2);     b6(i)=std(yd3(i,:));
        
       tb1(i)=mean(wd1(i,:),2);       tb2(i)=std(wd1(i,:));
       tb3(i)=mean(wd2(i,:),2);       tb4(i)=std(wd2(i,:));
       tb5(i)=mean(wd3(i,:),2);       tb6(i)=std(wd3(i,:));
       
       for  t=2:T
         ld1(i,t)=ld1(i,t-1)-log(b2(i))-0.5*((yd1(i,t)-b1(i))^2)/(b2(i)^2);
         ld2(i,t)=ld2(i,t-1)-log(b4(i))-0.5*((yd2(i,t)-b3(i))^2)/(b4(i)^2);
         ld3(i,t)=ld3(i,t-1)-log(b6(i))-0.5*((yd3(i,t)-b5(i))^2)/(b6(i)^2);

          lt(i,t)=lt(i,t-1)-log(tb2(i))-0.5*((wd1(i,t)-tb1(i))^2)/(tb2(i)^2)...
          -log(tb4(i))-0.5*((wd2(i,t)-tb3(i))^2)/(tb4(i)^2)-log(tb6(i))-0.5*((wd3(i,t)-tb5(i))^2)/(tb6(i)^2);
        end

         end
   
     ll1(i)=ld1(i,T);     ll2(i)=ld2(i,T);     ll3(i)=ld3(i,T);
     llcl(i)=0.33*ll1(i)+0.33*ll2(i)+0.33*ll3(i);
     ll(i)=lt(i,T);
end

  
%  subplot(1,2,1)
   [hAx,hLine1,hLine2]=plotyy(rhop, llcl, rhop,ll);  axis tight;
    %plot(rhop,ll1,rhop,ll2,rhop, ll3,rhop, llcl, rhop,ll, 'linewidth',2);  axis tight;
  xlabel('\rho')
  %ylabel('likelihood/composite')
  ylabel(hAx(1),'Composite') % left y-axis
  ylabel(hAx(2),'likelihood') % right y-axis
  %legend('likelihood country 1', 'likelihood country 2', ' likelihood country 3','composite  likelihood', 'true likelihood')
