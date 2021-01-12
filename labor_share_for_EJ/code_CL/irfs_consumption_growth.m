%computes  the paths of a variable after the shock

clear;
load results_consumption_3_models_growth;
load data;

number_of_draws=1000;
number_of_draws_irf=100000; %for simulating the CL IRF pdfs later
horizon=20;
simulations=500;
first_run=1;
%set variable and shock indices 
shocks=[1 1 1];

variable_names={'consumption'};
variables=[2 5 9];
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
if first_run==1
get_model_irfs_consumption_growth
save model_irfs
else
    load model_irfs
end
load results_consumption_3_models_growth;
load data;
for mm=1:setup.number_models
%for vv=1:size(variables,1)
model_irfs(:,mm)=squeeze(prctile(IRFS(1,:,mm,:),50,4));
model_irfs5(:,mm)=squeeze(prctile(IRFS(1,:,mm,:),16,4));
model_irfs95(:,mm)=squeeze(prctile(IRFS(1,:,mm,:),84,4));
mean_model_irfs(:,mm)=squeeze(mean(IRFS(1,:,mm,:),4));
%end
end

grid_=-.75/4:.00005/2:2/4;
  



IRFS_pdf=nan(setup.number_models,length(grid_),horizon,number_of_draws);

state_sizes_levels=[5;8;11];

for nn=1:number_of_draws
disp(nn/number_of_draws)
for mm=1:setup.number_models
    select=zeros(state_sizes_levels(mm),1);
    select(variables(1,mm))=1;
[IRFS_pdf(mm,:,:,nn)] = IRF_density2_real2( draws(:,indices(nn)),setup,mm,horizon,data,variables(:,mm), shocks(mm),grid_,select');
end

end


%now get CL density



    CL_pdf=IRFS_pdf(1,:,:,:).*(setup.model_weights(1));
    for mm=2:setup.number_models
    CL_pdf=CL_pdf+IRFS_pdf(mm,:,:,:).*(setup.model_weights(mm));
    
    end
   CL_pdf=squeeze(mean(exp(CL_pdf),4));


%now generate percentiles of CL pdf



for hh=1:horizon
probs=CL_pdf(:,hh)/sum(CL_pdf(:,hh));
cum_probs=cumsum(probs);
draws_temp=zeros(number_of_draws_irf,1);
for nn=1:number_of_draws_irf
    draws_temp(nn)=grid_(sum(cum_probs<rand)+1);
end
IRF_percentiles(hh,:)= prctile(draws_temp,[16 50 84]);
IRF_means(hh)=mean(draws_temp);
end


markers={'--','-.','-o','-+','-^'};
figure;
for mm=1:setup.number_models
plot(1:horizon,400*model_irfs(:,mm,1),markers{mm},'LineWidth',2)
hold on
end

plot(1:horizon,IRF_percentiles(:,1),'--r',1:horizon,IRF_percentiles(:,2),'-r',1:horizon,IRF_percentiles(:,3),'--r','LineWidth',2);
grid on
title('responses of consumption (percentage deviation from trend)')
hold off

legend('model 1', 'model 2','model 5', 'CL','CL 84th percentile','Location','northeast')
print -depsc

colors={'g','y','c'};
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

plot(1:horizon,IRF_percentiles(:,2),'-r','LineWidth',2);
grid on
title('median responses of consumption (percentage deviation from trend)')
hold off

legend('model 1', 'model 2','model 5', 'CL','Location','northeast')
print -depsc

BMA_irf_growth;

IRFs_BMA_med=prctile(IRFs_BMA,50,2);
load results_consumption_3_models_growth;
figure;
for mm=1:setup.number_models
plot(1:horizon,model_irfs(:,mm,1),markers{mm},'LineWidth',2)
hold on
end

plot(1:horizon,IRF_percentiles(:,2),'-r','LineWidth',2);
grid on
title('median responses of consumption (percentage deviation from trend)')

plot(1:horizon,IRFs_BMA_med,'LineWidth',2);

hold off

legend('model 1', 'model 2','model 5', 'CL','BMA','Location','northeast')
print -depsc