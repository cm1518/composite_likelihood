%compoutes  the paths of a variable after the shock

clear;

load results_estimated_weights_JASA_prior_squared_BGG_corrected;
load data;



number_of_draws=1000;
number_of_draws_irf=100000; %for simulating the CL IRF pdfs later
horizon=10;
simulations=500;

%set variable and shock indices (irf to technology shock)
shocks=[3 3 1 3 1];

variable_names={'inflation'};
variables=[1 1 6 1 1];
indices=randi(size(draws,2),number_of_draws,1);


IRFS=zeros(size(variables,1),horizon,setup.number_models,simulations*number_of_draws );

% 
% for nn=1:number_of_draws
% disp(nn/number_of_draws)
% for mm=1:setup.number_models
% [IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = IRF_simul2( draws(:,indices(nn)),setup,mm,horizon,data, variables(:,mm), shocks(mm) ,simulations);
% end
% 
% end

get_model_ind_irfs
load results_estimated_weights_JASA_prior_squared_BGG_corrected;
load data;
setup.model_weights=mean(draws(end-4:end,:),2);
for mm=1:setup.number_models
for vv=1:size(variables,1)
model_irfs(:,mm,vv)=squeeze(prctile(IRFS(vv,:,mm,:),50,4));
model_irfs5(:,mm,vv)=squeeze(prctile(IRFS(vv,:,mm,:),16,4));
model_irfs95(:,mm,vv)=squeeze(prctile(IRFS(vv,:,mm,:),84,4));
mean_model_irfs(:,mm,vv)=squeeze(mean(IRFS(vv,:,mm,:),4));
end
end



grid_{1}=-2:.0001:2;
grid_{2}=-2:.0001:2; 

for vv=1:size(variables,1)
IRFS_pdf{vv}=zeros(setup.number_models,length(grid_{vv}),horizon,number_of_draws);
end

for vv=1:size(variables,1)
for nn=1:number_of_draws
disp(nn/number_of_draws)
for mm=1:setup.number_models
[IRFS_pdf{vv}(mm,:,:,nn)] = IRF_density2( draws(:,indices(nn)),setup,mm,horizon,data, variables(vv,mm), shocks(mm),grid_{vv});
end

end
end

%now get CL density


for vv=1:size(variables,1)
    CL_pdf{vv}=IRFS_pdf{vv}(1,:,:,:).^(setup.model_weights(1));
    for mm=2:setup.number_models
    CL_pdf{vv}=CL_pdf{vv}.*IRFS_pdf{vv}(mm,:,:,:).^(setup.model_weights(mm));
    
    end
   CL_pdf{vv}=squeeze(mean(CL_pdf{vv},4));
end

%now generate percentiles of CL pdf


for vv=1:size(variables,1)
for hh=1:horizon
probs=CL_pdf{vv}(:,hh)/sum(CL_pdf{vv}(:,hh));
cum_probs=cumsum(probs);
draws_temp=zeros(number_of_draws_irf,1);
for nn=1:number_of_draws_irf
    draws_temp(nn)=grid_{vv}(sum(cum_probs<rand)+1);
end
IRF_percentiles(vv,hh,:)= prctile(draws_temp,[16 50 84]);
IRF_means(vv,hh)=mean(draws_temp);
end
end
markers={'--','-.','-o','-+','-^'};
figure;
for mm=1:setup.number_models
plot(1:horizon,model_irfs(:,mm,1),markers{mm},'LineWidth',2)
hold on
end

plot(1:horizon,IRF_percentiles(1,:,1),'--r',1:horizon,IRF_percentiles(1,:,2),'-r',1:horizon,IRF_percentiles(1,:,3),'--r','LineWidth',2);
grid on
title('responses of inflation')
hold off

legend('small NK with wages', 'small NK','large NK','search','BGG','CL 16th percentile', 'CL','CL 84th percentile','Location','southeast')
print -depsc

colors={'g','y','c','m','k'};
% figure;
% for mm=1:setup.number_models
% plot(1:horizon,model_irfs5(:,mm,1),colors{mm},'LineWidth',2)
% hold on
% plot(1:horizon,model_irfs95(:,mm,1),colors{mm},'LineWidth',2)
% 
% end
% 
% plot(1:horizon,IRF_percentiles(1,:,1),'--r',1:horizon,IRF_percentiles(1,:,3),'--r','LineWidth',2);
% grid on
% title('error bands for responses of inflation')
% hold off
% print -depsc

%mean plots

% figure;
% for mm=1:setup.number_models
% plot(1:horizon,mean_model_irfs(:,mm,1),'LineWidth',2)
% hold on
% end
% 
% plot(1:horizon,IRF_means(1,:),'-r','LineWidth',2);
% grid on
% title('responses of inflation')
% hold off
% 

%median without error bands

figure;
for mm=1:setup.number_models
plot(1:horizon,model_irfs(:,mm,1),markers{mm},'LineWidth',2)
hold on
end

plot(1:horizon,IRF_percentiles(1,:,2),'-r','LineWidth',2);
grid on
title('median responses of inflation')
hold off

legend('small NK with wages', 'small NK','large NK','search','BGG', 'CL','Location','southeast')
print -depsc

