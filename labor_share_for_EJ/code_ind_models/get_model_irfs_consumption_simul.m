%clear;

%load results;
load data;
%number_of_draws=1000;
%horizon=10;
%simulations=500;

%set variable and shock indices (irf to technology shock)
shocks_=shocks(mm);
variables_=variables(:,mm);
indices_temp=randi(size(draws,2),number_of_draws,1);


%IRFS=zeros(size(variables,1),horizon,simulations*number_of_draws );


for nn=1:number_of_draws


[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = IRF_simul_real2( draws(:,indices_temp(nn)),setup,horizon,data, variables_, shocks_,simulations,mm);


end

% 
% for vv=1:size(variables,1)
% figure;
% 
% 
% plot(1:horizon,squeeze(prctile(IRFS(vv,:,:),50,3)),1:horizon,squeeze(prctile(IRFS(vv,:,:),5,3)),1:horizon,squeeze(prctile(IRFS(vv,:,:),95,3)),'LineWidth',2)
% title(['model: ',setup.wrapper,', variable ',variable_names{vv}])
% 
% 
% 
% end