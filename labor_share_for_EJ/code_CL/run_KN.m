
clear;
close all;
clc;

tic



%set up the estimation

setup_KN_CL;

%and run the estimation

[ draws, acc_rate, log_posteriors, statedraws, individual_post_kernels] = sampling_MH( setup );



save results_KN

ind_max=min(find(log_posteriors==max(log_posteriors)));

max_draw_fixed=draws(:,ind_max);

save('../estimated_weights/max_draw_fixed.mat','max_draw_fixed');

toc