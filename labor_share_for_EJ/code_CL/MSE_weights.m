% code that computes the (equally weighted across variables) MSE for
% inflation and the nominal rate for all three models at the posterior mode
%(one could compute the posterior average of the MSE - I don't do this here
%to save time). I then use the MSEs to compute model weights along the
%lines of what was suggested by Timmermann's slides.

clear all 
clc


cd ../RRR_small_single_model

load results

ind_mode=find(log_posteriors==max(log_posteriors));

draw_max=draws(:,ind_mode);

[A B C_final D_final add_matrices] = RRR_small( draw_max,[],[] );

setup_DSGE_data;
load('data')

MSE_RRR_small=KF_MSE(A,B,C_final,D_final,setup.state_initial,setup.cov_initial,data,[1;2]);

cd ../DNS_inflation_1

load results


ind_mode=find(log_posteriors==max(log_posteriors));

draw_max=draws(:,ind_mode);

[A B C_final D_final add_matrices] = RRR( draw_max,[],[] );

setup_DSGE_data;
load('data')

MSE_RRR=KF_MSE(A,B,C_final,D_final,setup.state_initial,setup.cov_initial,data,[1;2]);

%model weights for two models

MSE_RRR_small_mean=mean(MSE_RRR_small);
MSE_RRR_mean=mean(MSE_RRR);

weight_RRR_small=MSE_RRR_small_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1));
weight_RRR=1-weight_RRR_small;




%model weights for three models

cd ../JPT_single_model
load results


ind_mode=find(log_posteriors==max(log_posteriors));

draw_max=draws(:,ind_mode);

[A B C_final D_final add_matrices] = modelJPT( draw_max,[],[] );

setup_DSGE_data;
load('data')

MSE_JPT=KF_MSE(A,B,C_final,D_final,setup.state_initial,setup.cov_initial,data,[6;7]);
MSE_JPT_mean=mean(MSE_JPT);


weight_RRR_small2=MSE_RRR_small_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1));
weight_RRR2=MSE_RRR_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1));
weight_JPT2=1-weight_RRR_small2-weight_RRR2;

cd ../3_models_PC_slope

save weights weight_RRR_small2 weight_RRR2 weight_JPT2

%model weights for 4 models


cd ../CK
load results


ind_mode=find(log_posteriors==max(log_posteriors));

draw_max=draws(:,ind_mode);

[A B C_final D_final add_matrices] = CK3( draw_max,[],[] );

setup_DSGE_data;
load('data')

MSE_CK=KF_MSE(A,B,C_final,D_final,setup.state_initial,setup.cov_initial,data,[1;2]);
MSE_CK_mean=mean(MSE_CK);


weight_RRR_small3=MSE_RRR_small_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1));
weight_RRR3=MSE_RRR_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1));
weight_JPT3=MSE_JPT_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1));
weight_CK3=MSE_CK_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1));
cd ../4_models_PC_slope

save weights2 weight_RRR_small3 weight_RRR3 weight_JPT3 weight_CK3


%model weights for 5 models


cd ../BGG_corrected
load results_BGG_lagged3


ind_mode=find(log_posteriors==max(log_posteriors));

draw_max=draws(:,ind_mode);

[A B C_final D_final add_matrices] = BGG( draw_max,[],[] );

setup_DSGE_data;
load('data')

MSE_BGG=KF_MSE(A,B,C_final,D_final,setup.state_initial,setup.cov_initial,data,[1;2]);
MSE_BGG_mean=mean(MSE_BGG);


weight_RRR_small4=MSE_RRR_small_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1)+MSE_BGG_mean^(-1));
weight_RRR4=MSE_RRR_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1)+MSE_BGG_mean^(-1));
weight_JPT4=MSE_JPT_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1)+MSE_BGG_mean^(-1));
weight_CK4=MSE_CK_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1)+MSE_BGG_mean^(-1));
weight_BGG4=MSE_BGG_mean^(-1)/(MSE_RRR_small_mean^(-1)+MSE_RRR_mean^(-1)+MSE_JPT_mean^(-1)+MSE_CK_mean^(-1)+MSE_BGG_mean^(-1));
cd ../5_models_PC_slope_equal_weights_BGG_corrected

save weights3 weight_RRR_small4 weight_RRR4 weight_JPT4 weight_CK4 weight_BGG4
