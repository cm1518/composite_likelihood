function [IRFS] = forecast_simul( params,setup,horizon,data, variables, simuls)
%simulates irfs from model mm. Doing this by simulation makes sure we also take into account shock uncertainty in the error bands

%solve model
wrapper_func=str2func([setup.wrapper,'_for_irf']);
[A, B, C, D,~]=wrapper_func(params,setup,data);


[IRFS,~, ~] = KF_forecasting(A,B*B',C,D*D',setup.state_initial,setup.cov_initial,data, horizon,simuls);
IRFS=IRFS(variables,:,:);