

clear;
close all;
clc;


tic
%set seed
rng(1)

%set up the estimation

setup_PC_EJ;

%and run the estimation

[ draws, acc_rate, log_posteriors, statedraws, individual_post_kernels] = sampling_MH( setup );



save results_PC_EJ

toc