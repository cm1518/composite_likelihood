

clear all;
close all;
%set seed
rng(1)

tic
clc;
country_names={'US','UK','CAN','GER','FRA'};
figure;
load('../data.mat')
number_of_countries=length(data);
for nn=1:number_of_countries
    
    load('../data.mat')
data=data{nn};
save data data;
setup_KN;

%and run the estimation

[ draws, acc_rate, log_posteriors, statedraws, individual_post_kernels] = sampling_MH( setup );



save(['results_KN' num2str(nn)])
subplot(3,2,nn)
histogram(draws(1,:))
title(country_names{nn})
end
toc
