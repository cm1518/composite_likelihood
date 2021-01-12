%clear;

%load results;

if mm==1
load data_1;
elseif mm==2
    load data_2
    
end
%number_of_draws=1000;
%horizon=10;
%simulations=500;

%set variable and shock indices (irf to technology shock)
%shocks_=shocks(mm);
variables_=variables(:,mm);
indices_temp=randi(size(draws,2),number_of_draws,1);


%IRFS=zeros(size(variables,1),horizon,simulations*number_of_draws );

if mm==1
    horizon=horizon_1;
elseif mm==2
    horizon=horizon_2;
end
for nn=1:number_of_draws
disp(nn/number_of_draws)

temp=states_simul_real( draws(:,indices_temp(nn)),setup,horizon,data, variables_,simulations,mm);

if mm==1
[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)]=temp(:,end-horizon_2+1:end);
elseif mm==2
[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)]=temp;
end

%[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = states_simul_real( draws(:,indices_temp(nn)),setup,horizon,data, variables_,simulations,mm);


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