clear
clc
close all
load results_EZ_total_short_sample;
 
mode_ind=find(log_posteriors==max(log_posteriors));
 mode_nd=draws(:,mode_ind(1));
 
 load results_EZ_total
 
 mode_ind=find(log_posteriors==max(log_posteriors));
 mode_total=draws(:,mode_ind(1));

 max_draw_fixed=[(mode_nd(1)+mode_total(1))/2 ;mode_total(2:end);mode_nd(2:end)];
 
 cd ../estimated_weights_dirichlet_RW
 save max_draw_fixed max_draw_fixed