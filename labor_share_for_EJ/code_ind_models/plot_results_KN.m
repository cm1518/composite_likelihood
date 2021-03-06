clear all
clc
close all

temp_name='results_KN';
country_names={'US','UK','CAN','GER','FRA'};

figure;
load(strcat(temp_name,num2str(1))) 
for nn=1:length(log_posteriors)
        ind_=0;
         while ind_==0
             temp=normrnd(setup.normal_prior_means(1),setup.normal_prior_std(1));
             ind_=temp>0;
        
         end
        draws_prior(nn)=temp;
    end
    subplot(3,1,1)
    histogram(draws_prior,'Normalization','pdf')
    hold on
    
    legend('prior')
    grid on
subplot(3,1,2)
    for jj=1:5
   
    load(strcat(temp_name,num2str(jj))) 
    
    
    histogram(draws(1,:),'Normalization','pdf')
    hold on
    
end
grid on
legend(country_names)
title('individual countries')
xl = xlim;
subplot(3,1,3)
load('../code_CL/results_KN.mat')
histogram(draws(1,:),'Normalization','pdf')
hold on
load('../estimated_weights/results_KN_ew.mat')
histogram(draws(1,:),'Normalization','pdf')
legend('fixed equal weights','estimated weights')
grid on
title('composite likelihood')

savefig('posterior')
print -depsc

%now redo figure with same x axis

figure;
 subplot(3,1,1)
    histogram(draws_prior,50,'Normalization','pdf')
    hold on
    
    legend('prior')
    grid on
    xlim([0 2])
    subplot(3,1,2)
for jj=1:5
   
    load(strcat(temp_name,num2str(jj))) 
    
    
    histogram(draws(1,:),50,'Normalization','pdf')
    hold on
   % xlim([0.75 1.25])
end
grid on
legend(country_names)
title('individual countries')
subplot(3,1,3)
load('../code_CL/results_KN.mat')
histogram(draws(1,:),50,'Normalization','pdf')
hold on
load('../estimated_weights/results_KN_ew.mat')
histogram(draws(1,:),50,'Normalization','pdf')
xlim([0.75 1.25])
legend('fixed equal weights','estimated weights')
grid on
title('composite likelihood')

savefig('posterior_equal_x_axis')
print -depsc