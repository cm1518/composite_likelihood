function [IRFS] = IRF_simul2( params,setup,mm,horizon,data, variables, shock ,simuls)
%simulates irfs from model mm. Doing this by simulation makes sure we also take into account shock uncertainty in the error bands

%solve model
wrapper_func=str2func([setup.wrapper{mm},'_for_irf']);
[A B C D add_matrices]=wrapper_func([params(setup.index_model{1});params(setup.index_model{mm+1})],setup,data{mm});



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
    states(:,1,ss)=setup.state_initial{mm};
for tt=1:horizon
states(:,tt+1,ss)=C*states(:,tt,ss)+D*state_shocks(:,tt,ss);
obs(:,tt,ss)=A*states(:,tt+1,ss)+B*obs_shocks(:,tt,ss);

end
end

for ss=1:simuls
%now with the fixed shock
state_shocks(shock,1,ss)=1;
states2(:,1,ss)=setup.state_initial{mm};

for tt=1:horizon
states2(:,tt+1,ss)=C*states2(:,tt,ss)+D*state_shocks(:,tt,ss);
obs2(:,tt,ss)=A*states2(:,tt+1,ss)+B*obs_shocks(:,tt,ss);

end
end
IRFS=obs2(variables,:,:)-obs(variables,:,:);