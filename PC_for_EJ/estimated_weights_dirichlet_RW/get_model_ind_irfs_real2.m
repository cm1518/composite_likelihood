
cd ../RRR

load results
mm=1;
get_model_irfs_real2;
cd ../RRR_small

load results
mm=2;
get_model_irfs_real2;

cd ../JPT
load results
mm=3;
get_model_irfs_real2;

cd ../CK
load results 
mm=4;
get_model_irfs_real2;

cd ../BGG
load results

mm=5;
get_model_irfs_real2;


cd ../estimated_weights_dirichlet_RW