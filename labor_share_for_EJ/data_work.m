clear
close all
clc

tic
country_names={'US','UK','CAN','GER','FRA'};
var_names={'labor share','log real GDP','rel. price of inv.'};
for kk=1:length(country_names)
    
    temp=xlsread('KN_data.xlsx',country_names{kk});
    temp=temp(1:end-sum(isnan(temp(:))),:);
    temp(:,:)=log(temp(:,:)); %observables are in logs (even labor share)
    data{kk}=temp(:,2:end)'-mean(temp(:,2:end)',2); %data are demeaned
end


save('data.mat', 'data')
save('code_ind_models/data.mat', 'data')
save('code_CL/data.mat', 'data')
save('estimated_weights/data.mat', 'data')
toc

    