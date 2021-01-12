

cd ../RRR_small_single_model

load results
mm=1;
get_model_irfs_tech;

cd ../JPT_single_model
load results
mm=2;
get_model_irfs_tech;



cd ../estimated_weights_dirichlet_RW