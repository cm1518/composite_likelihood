function [IRFS] = states_simul_real( params,setup,horizon,data, variables, simuls,mm)
%simulates irfs from model mm. Doing this by simulation makes sure we also take into account shock uncertainty in the error bands

%solve model
wrapper_func=str2func([setup.wrapper]);
[A, B, C, D, ~]=wrapper_func(params,setup,data);
[xest, var_state] = KF_states(A,B,C,D,setup.state_initial,setup.cov_initial,data);




IRFS=zeros(size(variables,1),horizon,simuls);

for hh=1:horizon
mean_irf=xest(:,end-horizon+hh);

var_irf=var_state(:,:,end-horizon+hh);
temp=(mvnrnd(mean_irf',(var_irf),simuls))';


IRFS(:,hh,:)=temp(variables,:);
end

