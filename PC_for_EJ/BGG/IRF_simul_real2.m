function [IRFS] = IRF_simul_real( params,setup,horizon,data, variables, shock ,simuls,mm)
%simulates irfs from model mm. Doing this by simulation makes sure we also take into account shock uncertainty in the error bands

%solve model
wrapper_func=str2func([setup.wrapper,'_for_irf']);
[A, B, C, D, add_matrices,inv_shock_std]=wrapper_func(params,setup,data);

if mm==3
    D=D/100;
    inv_shock_std=inv_shock_std*100;
end

state_size=size(C,1);
obs_size=size(A,1);
state_shock_size=size(D,2);
obs_shock_size=size(B,2);
%state shocks

state_shocks=zeros(state_shock_size,horizon,simuls);
obs_shocks=randn(obs_shock_size,horizon,simuls);

states=zeros(state_size,horizon+1,simuls);

obs=zeros(obs_size,horizon,simuls);
states2=zeros(state_size,horizon+1,simuls);

obs2=zeros(obs_size,horizon,simuls);


for ss=1:simuls

state_shocks(shock,1,ss)=normrnd(.25/400*inv_shock_std,0.5*.25/400*inv_shock_std);
states2(:,1,ss)=setup.state_initial;

for tt=1:horizon
states2(:,tt+1,ss)=C*states2(:,tt,ss)+D*state_shocks(:,tt,ss);
obs2(:,tt,ss)=A*states2(:,tt+1,ss)+B*obs_shocks(:,tt,ss);

end
end
IRFS=states2(variables,2:end,:)-states(variables,2:end,:);