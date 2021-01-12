clear;
close all;

load results_estimated_weights_JASA_prior_squared_BGG_corrected;
load data;


mode_ind=find(log_posteriors==max(log_posteriors), 1 );
mode=draws(:,mode_ind);
setup.model_weights=mode(end-4:end);

slope_vec=0.01:0.01:1;

for ss=1:length(slope_vec)
   CL_value(ss)=posterior_for_Hess( [slope_vec(ss);mode(2:end-5)],setup,data ) ;
    
    
    
end

figure;
plot(slope_vec,CL_value,'LineWidth',3)
grid on
title('CL values as a function of PC slope')

begin_smaller=find(slope_vec==0.2);
end_smaller=find(slope_vec==0.8);

figure;
plot(slope_vec(begin_smaller:end_smaller),CL_value(begin_smaller:end_smaller),'LineWidth',3)
grid on
title('CL values as a function of PC slope')