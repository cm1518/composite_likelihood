

clear all;
close all;
clc;





%set up the estimation

setup_EJ;

%and run the estimation

[ draws, acc_rate, log_posteriors, statedraws, individual_post_kernels] = sampling_MH( setup );




save results
