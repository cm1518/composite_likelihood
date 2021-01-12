clear;
close all;

load results_estimated_weights_JASA_prior_squared_BGG_corrected;
load data;


mode_ind=find(log_posteriors==max(log_posteriors), 1 );
mode=draws(:,mode_ind);
setup.model_weights=mode(end-4:end);
index=92;

slope_vec=.002:.0005:.01;
for ss=1:length(slope_vec)
    temp_vec=mode;
    temp_vec(index)=slope_vec(ss);
   CL_value(ss)=posterior_for_Hess( temp_vec(1:end-5),setup,data ) ;
    
    
    
end

figure;
plot(slope_vec,CL_value,'LineWidth',3)
grid on


