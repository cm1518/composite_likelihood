clear;
close all;
clc;

load results_PC_EJ

[f_CL6]=ksdensity(draws(1,:),[0:.001:.8]);



setup.model_weights=mean(draws(end-4:end,:),2);

figure;
plot([0:.001:.8],f_CL6,'--','LineWidth',2)
legend('composite posterior')
title('\kappa_p')
grid on
print -depsc
 
savefig('posterior_kappa')

