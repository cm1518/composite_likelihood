
clear;
close all;
clc;



tic

%set up the estimation

setup_KN_CL_estimated_weights;

%and run the estimation

[ draws, acc_rate, log_posteriors, statedraws, individual_post_kernels] = sampling_MH( setup );



save results_KN_ew

toc