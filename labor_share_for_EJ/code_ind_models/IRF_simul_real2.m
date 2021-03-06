function [IRFS] = IRF_simul_real2( params,setup,horizon,data, variables, shock ,simuls,mm)
%simulates irfs from model mm. Doing this by simulation makes sure we also take into account shock uncertainty in the error bands

%solve model
wrapper_func=str2func([setup.wrapper,'_for_irf']);
[A, B, C, D, add_matrices,inv_shock_std]=wrapper_func(params,setup,data);



state_size=size(C,1);
obs_size=size(A,1);
state_shock_size=size(D,2);
obs_shock_size=size(B,2);
%state shocks

state_shocks=zeros(state_shock_size,horizon,simuls);
%state_shocks(logical(shock),1)=1;
obs_shocks=randn(obs_shock_size,horizon,simuls);

states=zeros(state_size,horizon+1,simuls);

obs=zeros(obs_size,horizon,simuls);
states2=zeros(state_size,horizon+1,simuls);

obs2=zeros(obs_size,horizon,simuls);


for ss=1:simuls
%now with the fixed shock
state_shocks(shock,1,ss)=normrnd(.5*0.023*inv_shock_std,.5*0.023*0.5*inv_shock_std);


for tt=1:horizon
states2(:,tt+1,ss)=C*states2(:,tt,ss)+D*state_shocks(:,tt,ss);
obs2(:,tt,ss)=A*states2(:,tt+1,ss)+B*obs_shocks(:,tt,ss);

end
end
IRFS=states2(variables,2:end,:)-states(variables,2:end,:);