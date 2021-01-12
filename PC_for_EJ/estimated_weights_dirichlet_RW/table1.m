clear;
clc;
close all;

tic

load results_PC_EJ;
%simulate prior
%prior is a truncated normal
rng(1)
number_draws=5000;

nn=0;
while nn<number_draws
temp=setup.normal_prior_means(1)+setup.normal_prior_std(1)*randn;

if temp>0
nn=nn+1;
prior_draws(nn)=temp;
end
 
end
prior_prctiles=prctile(prior_draws,[5 50 95]);




%get ind. model posteriors
cd ../RRR_small
load results

RRR_small_prctiles=prctile(squeeze(draws(end,:)),[5 50 95]);


cd ../RRR
load results
RRR_prctiles=prctile(squeeze(draws(end,:)),[5 50 95]);


cd ../JPT
load results
JPT_prctiles=prctile(squeeze(draws(12,:)),[5 50 95]);

cd ../CK
load results 
CK_prctiles=prctile(squeeze(draws(1,:)),[5 50 95]);

cd ../BGG
load results
BGG_prctiles=prctile(squeeze(draws(1,:)),[5 50 95]);

%get CL posterior
cd ../estimated_weights_dirichlet_RW
load results_PC_EJ
CL_prctiles=prctile(squeeze(draws(1,:)),[5 50 95]);

%adjusted CL posterior

Qu_adjustment;
CL_adj_prctiles=prctile(squeeze(draws_adjusted(1,:)),[5 50 95]);
model_names={'prior','small NK','small NK with wages','medium scale NK','search and matching','BGG','CL','CL (corrected)'};



posterior_prob_table = array2table(round([prior_prctiles;RRR_small_prctiles;RRR_prctiles;JPT_prctiles;CK_prctiles;BGG_prctiles;CL_prctiles;CL_adj_prctiles],2),'RowNames',model_names,'VariableNames',{'5th percentile','Median','95th percentile'})


toc