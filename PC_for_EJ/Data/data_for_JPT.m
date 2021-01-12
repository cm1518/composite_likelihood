
tic
% we use the data that accompanies the SW AER paper to estimate the JPT model. 
test = xlsread('sw_data.xlsx');
data=test';

cd ../JPT
save data data

toc