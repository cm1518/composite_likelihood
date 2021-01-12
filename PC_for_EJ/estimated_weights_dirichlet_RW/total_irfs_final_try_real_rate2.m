%computes  the paths of a variable after the shock

clear;
close all;
load results_estimated_weights_tighter_prior
load data;
first_run=0;
number_of_draws=500;
number_of_draws_irf=100000; %for simulating the CL IRF pdfs later
horizon=10;
simulations=500;

%set variable and shock indices (irf to technology shock)
shocks=[3 3 1 3 1];

variable_names={'inflation'};
variables=[2 2 10 13 15;14 14 24 25 16];


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
get_model_ind_irfs_real2
save model_irfs
else
    load model_irfs
    
end
load results_estimated_weights_org_prior
load data;
setup.model_weights=mean(draws(end-4:end,:),2);
indices=randi(size(draws,2),number_of_draws,1);


for mm=1:setup.number_models
%for vv=1:size(variables,1)
model_irfs(:,mm)=squeeze(prctile(IRFS(1,:,mm,:)-IRFS(2,:,mm,:),50,4));
model_irfs5(:,mm)=squeeze(prctile(IRFS(1,:,mm,:)-IRFS(2,:,mm,:),16,4));
model_irfs95(:,mm)=squeeze(prctile(IRFS(1,:,mm,:)-IRFS(2,:,mm,:),84,4));
mean_model_irfs(:,mm)=squeeze(mean(IRFS(1,:,mm,:)-IRFS(2,:,mm,:),4));
%end
end



grid_=-.75/4:.00005/2:2/4;
 


IRFS_pdf=zeros(setup.number_models,length(grid_),horizon,number_of_draws);



for nn=1:number_of_draws
disp(nn/number_of_draws)
for mm=1:setup.number_models
    select=zeros(size(setup.state_initial{mm}));
    select(variables(1,mm))=1;
    select(variables(2,mm))=-1;
[IRFS_pdf(mm,:,:,nn)] = IRF_density2_real2( draws(:,indices(nn)),setup,mm,horizon,data,[], shocks(mm),grid_,select');
end

end


%now get CL density



    CL_pdf=IRFS_pdf(1,:,:,:).^(setup.model_weights(1));
    for mm=2:setup.number_models
    CL_pdf=CL_pdf.*IRFS_pdf(mm,:,:,:).^(setup.model_weights(mm));
    
    end
   CL_pdf=squeeze(mean(CL_pdf,4));


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

plot(1:horizon,400*IRF_percentiles(:,1),'--r',1:horizon,400*IRF_percentiles(:,2),'-r',1:horizon,400*IRF_percentiles(:,3),'--r','LineWidth',2);
grid on
title('responses of ex-ante real rate (annualized)')
hold off

legend('small NK with wages', 'small NK','large NK','search','BGG','CL 16th percentile', 'CL','CL 84th percentile','Location','northeast')
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
plot(1:horizon,400*model_irfs(:,mm,1),markers{mm},'LineWidth',2)
hold on
end

plot(1:horizon,400*IRF_percentiles(:,2),'-r','LineWidth',2);
grid on
title('median responses of of ex-ante real rate (annualized)')
hold off

legend('small NK with wages', 'small NK','large NK','search','BGG', 'CL','Location','northeast')
print -depsc

load draws_adjusted


IRFS_pdf2=zeros(setup.number_models,length(grid_),horizon,number_of_draws);



for nn=1:number_of_draws
disp(nn/number_of_draws)
for mm=1:setup.number_models
    select=zeros(size(setup.state_initial{mm}));
    select(variables(1,mm))=1;
    select(variables(2,mm))=-1;
[IRFS_pdf2(mm,:,:,nn)] = IRF_density2_real2( draws_adjusted(:,indices(nn)),setup,mm,horizon,data,[], shocks(mm),grid_,select');
end

end


%now get CL density



    CL_pdf2=IRFS_pdf2(1,:,:,:).^(setup.model_weights(1));
    for mm=2:setup.number_models
    CL_pdf2=CL_pdf2.*IRFS_pdf2(mm,:,:,:).^(setup.model_weights(mm));
    
    end
   CL_pdf2=squeeze(mean(CL_pdf2,4));


%now generate percentiles of CL pdf



for hh=1:horizon
probs2=CL_pdf2(:,hh)/sum(CL_pdf2(:,hh));
cum_probs2=cumsum(probs2);
draws_temp2=zeros(number_of_draws_irf,1);
for nn=1:number_of_draws_irf
    draws_temp2(nn)=grid_(sum(cum_probs2<rand)+1);
end
IRF_percentiles2(hh,:)= prctile(draws_temp2,[16 50 84]);
IRF_means2(hh)=mean(draws_temp2);
end


figure;


plot(1:horizon,400*IRF_percentiles(:,1),'--r',1:horizon,400*IRF_percentiles(:,2),'-r',1:horizon,400*IRF_percentiles(:,3),'--r','LineWidth',2);
hold on
plot(1:horizon,400*IRF_percentiles2(:,1),'--b',1:horizon,400*IRF_percentiles2(:,2),'-b',1:horizon,400*IRF_percentiles2(:,3),'--b','LineWidth',2);

grid on
title('median responses of of ex-ante real rate (annualized)')
hold off

legend('CL 16th percentile', 'CL','CL 84th percentile','CL adjusted 16th percentile', 'CL adjusted','CL adjusted 84th percentile','Location','northeast')
print -depsc


