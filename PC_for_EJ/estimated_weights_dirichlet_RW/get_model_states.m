
cd ../DNS_inflation_1

load results
mm=1;
get_model_states2;
cd ../RRR_small_single_model

load results
mm=2;
get_model_states2;

cd ../JPT_single_model
load results
mm=3;
get_model_states2;

cd ../CK
load results 
mm=4;
get_model_states2;

cd ../BGG_corrected
load results_BGG_lagged3

mm=5;
get_model_states2;


cd ../estimated_weights_dirichlet_RW