clear;

load results_equal_weights_5_models;
load data;
number_of_draws=1000;
number_of_draws_irf=100000; %for simulating the CL IRF pdfs later
horizon=10;


%set variable and shock indices (irf to technology shock)
shocks=[3 3 1 3 1];
shock_name={'technology'};
variable_names={'inflation','nominal rate'};
variables=[1 1 6 1 1;2 2 7 2 2];
indices=randi(size(draws,2),number_of_draws,1);

grid_{1}=-0.1:.00005:.1;
grid_{2}=-.1:.00005:.1; 

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
IRF_percentiles(vv,hh,:)= ksdensity(draws_temp,[.05 .5 .95],'function','icdf');
end
end

figure;
plot(1:horizon,IRF_percentiles(1,:,1),1:horizon,IRF_percentiles(1,:,2),1:horizon,IRF_percentiles(1,:,3),'LineWidth',2);

title('CL-based IRFs for inflation')
grid on
figure;
plot(1:horizon,IRF_percentiles(2,:,1),1:horizon,IRF_percentiles(2,:,2),1:horizon,IRF_percentiles(2,:,3),'LineWidth',2);

title('CL-based IRFs for the nominal interest rate')
grid on