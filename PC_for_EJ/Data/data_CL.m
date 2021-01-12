clear;
clc;
close all;
tic
data_for_RRR_CK;

data__CL{1}=data;
data__CL{4}=data;

cd ../Data
data_for_RRRsmall_BGG;

data__CL{2}=data;
data__CL{5}=data;
cd ../Data
data_for_JPT;

data__CL{3}=data;

data=data__CL;

cd ../estimated_weights_dirichlet_RW

save data data
toc


