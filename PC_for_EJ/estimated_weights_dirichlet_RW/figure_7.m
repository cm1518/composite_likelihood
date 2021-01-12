%computes  the paths of a variable after the shock

clear;
close all;
clc
tic
load results_PC_EJ
load data;
%set seed
rng(1)

first_run=1;
number_of_draws=500;
number_of_draws_irf=100000; %for simulating the CL IRF pdfs later
horizon=10;
simulations=500;

%set variable and shock indices 
shocks=[3 3 1 3 1];


variables=[2 2 10 13 15;14 14 24 25 16];


IRFS=zeros(size(variables,1),horizon,setup.number_models,simulations*number_of_draws );

if first_run==1
get_model_ind_irfs_real2
save model_irfs
else
    load model_irfs
    
end
load results_PC_EJ
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



weighted_irfs;



figure;
for mm=2:2
plot(1:horizon,400*model_irfs(:,mm,1),'b-p','LineWidth',2)
hold on
end
plot(1:horizon,400*IRFs_equal_weights,'r-d','LineWidth',2)
hold on
plot(1:horizon,400*IRFs_estimated_weights,'-o','Color',[0.9290 0.6940 0.1250],'LineWidth',2)
hold on

plot(1:horizon,400*IRF_percentiles(:,1),'k--',1:horizon,400*IRF_percentiles(:,2),'k-',1:horizon,400*IRF_percentiles(:,3),'k--','LineWidth',2);
grid on
title('responses of ex-ante real rate (annualized)')
hold off

legend('small NK','equal weights','estimated weights','CL 16th percentile', 'CL','CL 84th percentile','Location','northeast')
print -depsc
savefig('irfs')


toc
