clear;
close all
clc

load results_KN_ew

country_names={'US','UK','CAN','GER','FRA'};

for jj=1:length(log_posteriors)
   prior_draw(jj,:)= drchrnd(setup.dirichlet_prior_parameters,1); 
    
    
    
end


figure;
for jj=1:5
subplot(5,1,jj)
histogram(draws(end-5+jj,:),'BinLimits',[0,1])

hold on
histogram(prior_draw(:,jj),'BinLimits',[0,1])
hold off
grid on
title(country_names{jj})
if jj==2
    
   legend('posterior','prior') 
end
end

print -depsc
savefig('weights')

