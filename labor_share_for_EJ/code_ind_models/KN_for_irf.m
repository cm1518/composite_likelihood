function [A, B, C_final, D_final, add_matrices,inv_shock_std] = KN_for_irf( params,setup,data )

sigma=params(1);
gamma=params(2);
rho_1=params(3);
rho_2=params(4);
rho_3=params(5);    
omega_1=params(6);
omega_2=params(7);
omega_3=params(8);



%calibrated parameters

delta=0.1;
beta_1=0.96;
r_bar=1/beta_1-1;
R_bar=1+r_bar-(1-delta);
cy=0.7; %C/Y in the US according to Hornstein
ky=4; %K/Y in the US according to Hornstein
alpha=0.33;
s_k_ss=R_bar*ky;
s_pi_ss=0.1; %ten percent profit share
s_l_ss=1-s_k_ss-s_pi_ss;
mu_ss=1/(1-s_pi_ss);
k_ss=(((1/ky)^((sigma-1)/sigma)-alpha)/(1-alpha))^(sigma/(1-sigma));
y_ss=1/ky*k_ss;

%variables
y=1;
c=2;
k=3;
r=4;
mu=5;
s_k=6;
s_l=7;
z=8;
a_n=9;
a_k=10;
R=11;
Ec=12;
Er=13;


g0=zeros(13,13);
g1=zeros(13,13);
C=zeros(13,1);
pi_matrix=zeros(13,2);
PSI=zeros(13,3);


%eq 12
 
g0(1,y)=1; 
g0(1,k)=-(alpha*k_ss*y_ss^(sigma/(sigma-1)));
g0(1,a_k)=-(alpha*k_ss*y_ss^(sigma/(sigma-1)));
g0(1,a_n)=-(1-alpha)*y_ss^(sigma/(sigma-1));

%eq 13


g0(2,s_l)=mu_ss*s_l_ss/(1-mu_ss*s_l_ss);
g0(2,mu)=1/(1-mu_ss*s_l_ss)+(sigma-1);
g0(2,a_k)=-(sigma-1);
g0(2,R)=(sigma-1);

% eq 14
g0(3,R)=1;
g1(3,z)=(1/R_bar)*(1+r_bar);
g0(3,r)=-(1/R_bar)*(1+r_bar);
g0(3,z)=(1/R_bar)*(1-delta);



%eq 15
 
g0(4,Er)=r_bar/(1+r_bar);
g0(4,c)=gamma;
g0(4,Ec)=-gamma;


% eq 16
g0(5,mu)=1;
g0(5,s_l)=s_l_ss/(s_l_ss+s_k_ss);
g0(5,s_k)=1-s_l_ss/(s_l_ss+s_k_ss);



%   eq 17
g0(6,s_k)=1;
g0(6,R)=-1;
g0(6,k)=-1;
g0(6,y)=1;




%eq 18

g0(7,y)=1;
g0(7,c)=-cy;
g0(7,z)=-delta*ky;
g0(7,k)=-ky;
g1(7,k)=ky*(1-delta);

%exog. processes


g0(8,z)=1;
g1(8,z)=rho_1;
PSI(8,1)=omega_1;



g0(9,a_k)=1;
g1(9,a_k)=rho_2;
PSI(9,2)=omega_2;


g0(10,a_n)=1;
g1(10,a_n)=rho_3;
PSI(10,3)=omega_3;

%expectations




g0(11,c)=1;
g1(11,Ec)=1;
pi_matrix(11,1)=1;

g0(12,r)=1;
g1(12,Er)=1;
pi_matrix(12,2)=1;


g0(13,R)=1;
g0(13,mu)=1;
g0(13,a_k)=-(sigma-1)/sigma;
g0(13,y)=-1;
g0(13,k)=1;

%call gensys
 try
 [C,Constant,D_sqr,fmat,fwt,ywt,gev,eu,loose]=gensys(g0,g1,C,PSI,pi_matrix);
 D=D_sqr;

 inv_shock_std=1/D(z,1);
if eu(1)==-2
 Constant=zeros(size(g0,1),1);
    C=zeros(size(g0));
  D=eps+zeros(size(C)); 
  
end
 if eu(1)~=1 || eu(2)~=1 
    C=zeros(size(C)); 
    D=eps+zeros(size(C)); 
 end
 
 catch ME
    Constant=zeros(size(g0,1),1);
    C=zeros(size(g0));
  D=eps+zeros(size(C));  
 end
  %now add intercept term
 C_final=zeros(14,14);
 C_final(1:13,1:13)=C;
 C_final(14,1:13)=Constant;
 C_final(14,14)=1;
 D_final=zeros(size(D,1)+1,size(D,2)+1);
 D_final(1:size(D,1),1:size(D,2))=D;
 
 
 
 
 A=zeros(3,14); 
 A(1,s_l)=1;  
 A(2,y)=1;
 A(3,z)=1;


 
 B=zeros(3,1);





add_matrices=[];