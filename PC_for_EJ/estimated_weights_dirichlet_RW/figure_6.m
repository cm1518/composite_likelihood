clear
clc
close all

tic

cd ../RRR_small
load results


%prior density (same for all estimation runs)
cutoff_prob=1-normcdf(0,setup.normal_prior_means(13),setup.normal_prior_std(13));
x=0:.01:1.5;
prior_dens=normpdf(x,setup.normal_prior_means(13),setup.normal_prior_std(13))/cutoff_prob;


[f_RRR_small, xi_RRR_small]=ksdensity(draws(end,:));

[f_RRR_small2]=ksdensity(draws(end,:),[0:.001:.8]);


cd ../RRR

load results

 [f_RRR, xi_RRR]=ksdensity(draws(end,:));
[f_RRR2]=ksdensity(draws(end,:),[0:.001:.8]);



cd ../JPT
load results
 [f_JPT, xi_JPT]=ksdensity(draws(12,:));
[f_JPT2]=ksdensity(draws(12,:),[0:.001:.8]);





cd ../CK
load results 
[f_CK, xi_CK]=ksdensity(draws(1,:));
[f_CK2]=ksdensity(draws(1,:),[0:.001:.8]);



cd ../BGG
load results
[f_BGG, xi_BGG]=ksdensity(draws(1,:));
[f_BGG2]=ksdensity(draws(1,:),[0:.001:.8]);


cd ../estimated_weights_dirichlet_RW

load results_PC_EJ
[f_CL5, xi_CL5]=ksdensity(draws(1,:));
[f_CL6]=ksdensity(draws(1,:),[0:.001:.8]);



setup.model_weights=mean(draws(end-4:end,:),2);

figure;
plot([0:.001:.8],setup.model_weights(1)*f_RRR_small2+setup.model_weights(2)*f_RRR2+setup.model_weights(3)*f_JPT2+setup.model_weights(4)*f_CK2+setup.model_weights(5)*f_BGG2,[0:.001:.8],f_CL6,'r--',[0:.001:.8],1/5*f_RRR_small2+1/5*f_RRR2+1/5*f_JPT2+1/5*f_CK2+1/5*f_BGG2,'k-.','LineWidth',2)
legend('weighted average of posteriors (at posterior mean of weights)','composite posterior','equally weighted average of posteriors')
title('\kappa_p')
grid on
print -depsc
 
savefig('various_posteriors')

toc
