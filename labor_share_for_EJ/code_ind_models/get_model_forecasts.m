%clear;

%load results;
load data;
%number_of_draws=1000;
%horizon=10;
%simulations=500;

%set variable and shock indices (irf to technology shock)

variables_=variables(mm);
indices_temp=randi(size(draws,2),number_of_draws,1);


%IRFS=zeros(size(variables,1),horizon,simulations*number_of_draws );


for nn=1:number_of_draws
disp(nn/number_of_draws)
try
[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = forecast_simul( draws(:,indices_temp(nn)),setup,horizon,data, variables_,simulations);
catch ME
    indices_temp(nn)=indices_temp(nn)+1;
    [IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = forecast_simul( draws(:,indices_temp(nn)),setup,horizon,data, variables_,simulations);
end

end
% if mm~=3
%     IRFS=IRFS+0.8533; %adding sample mean back in (already included in JPT model)
% end
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