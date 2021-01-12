clear;

load results_equal_weights_5_models;
load data;
number_of_draws=1000;
horizon=10;
simulations=500;

%set variable and shock indices (irf to technology shock)
shocks=[3 3 1 3 1];
shock_name={'technology'};
variable_names={'inflation','nominal rate'};
variables=[1 1 6 1 1;2 2 7 2 2];
indices=randi(size(draws,2),number_of_draws,1);


IRFS=zeros(size(variables,1),horizon,setup.number_models,simulations*number_of_draws );


for nn=1:number_of_draws
disp(nn/number_of_draws)
for mm=1:setup.number_models
[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = IRF_simul( draws(:,indices(nn)),setup,mm,horizon,data, variables(:,mm), shocks(mm) ,simulations);
end

end


for vv=1:size(variables,1)
figure;
for mm=1:setup.number_models
subplot(setup.number_models,1,mm)
plot(1:horizon,squeeze(prctile(IRFS(vv,:,mm,:),50,4)),1:horizon,squeeze(prctile(IRFS(vv,:,mm,:),5,4)),1:horizon,squeeze(prctile(IRFS(vv,:,mm,:),95,4)),'LineWidth',2)
title(['response to',shock_name,', model: ',setup.wrapper{mm},', variable ',variable_names{vv}])

end

end