%computes  the paths of a variable after the shock

clear;
close all;
load results_PC_EJ
load data;
number_of_draws=500;
number_of_draws_irf=100000; %for simulating the CL IRF pdfs later
horizon=10;


%set variable and shock indices 
shocks=[3 3 1 3 1];


variables=[2 2 10 13 15;14 14 24 25 16];


IRFS=zeros(size(variables,1),horizon,setup.number_models,simulations*number_of_draws );


setup.model_weights=mean(draws(end-4:end,:),2);
indices=randi(size(draws,2),number_of_draws,1);





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







figure;


plot(1:horizon,400*IRF_percentiles(:,1),'--r',1:horizon,400*IRF_percentiles(:,2),'-r',1:horizon,400*IRF_percentiles(:,3),'--r','LineWidth',2);
grid on
title('responses of ex-ante real rate (annualized)')
hold off

legend('CL 16th percentile', 'CL','CL 84th percentile','Location','northeast')
print -depsc
savefig('irfs')



