clear
clc
close all
 
cd ../data
nd_ind=0;
data_work;
cd ../code_ind_models

 main_EZ_total
 
clear
clc
close all
 
cd ../data
nd_ind=1;
data_work;
cd ../code_ind_models


 main_EZ_nd
 
 
mode_ind=find(log_posteriors==max(log_posteriors));
 mode_nd=draws(:,mode_ind(1));
 
 load results_EZ_total
 
 mode_ind=find(log_posteriors==max(log_posteriors));
 mode_total=draws(:,mode_ind(1));

 max_draw_fixed=[(mode_nd(1)+mode_total(1))/2 ;mode_total(2:end);mode_nd(2:end)];
 
 cd ../estimated_weights_dirichlet_RW
 save max_draw_fixed max_draw_fixed