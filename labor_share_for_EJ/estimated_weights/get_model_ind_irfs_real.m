
cd ../DNS_inflation_1

load results
mm=1;
get_model_irfs_real;
cd ../RRR_small_single_model

load results
mm=2;
get_model_irfs_real;

cd ../JPT_single_model
load results
mm=3;
get_model_irfs_real;

cd ../CK
load results 
mm=4;
get_model_irfs_real;

cd ../BGG_corrected
load results_BGG

mm=5;
get_model_irfs_real;


cd ../estimated_weights_dirichlet_RW