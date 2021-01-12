clear;

load results_equal_weights_5_models;
load data;
number_of_draws=1;
horizon=50;
simulations=1;
setup.state_initial{5}=zeros(20,1);
%set variable and shock indices (irf to technology shock)
shocks=[1];
shock_name={'mp'};
variable_names={'inflation','nominal rate'};
variables=[1;2];
indices=randi(size(draws,2),number_of_draws,1);
params=[.1;0.5;3;.35;.025;.95;.95;.25;1 - 0.0272;0.8;1.5;.001;.001;.001];

IRFS=zeros(size(variables,1),horizon,1,simulations*number_of_draws );


for nn=1:number_of_draws
disp(nn/number_of_draws)
for mm=1:setup.number_models
IRFS(:,:,1,1+simulations*(nn-1):simulations*nn) = IRF_BGG( params,setup,5,horizon,data, variables, shocks ,simulations);
end

end


for vv=1:size(variables,1)
figure;

plot(1:horizon,squeeze(prctile(IRFS(vv,:,1,:),50,4)),1:horizon,squeeze(prctile(IRFS(vv,:,1,:),5,4)),1:horizon,squeeze(prctile(IRFS(vv,:,1,:),95,4)),'LineWidth',2)
title(['response to',shock_name,', model: ',setup.wrapper{5},', variable ',variable_names{vv}])



end