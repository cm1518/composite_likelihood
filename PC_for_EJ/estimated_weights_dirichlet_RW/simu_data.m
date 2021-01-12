load results_two_models_HS
number_draws=1000;

%order of variables: inflation, nominal rate, gdp growth (6,7,1)

for dd=1:number_draws
dd/number_draws
ind=randi(size(draws,2),1);
post_med_CL=draws(:,ind);
post_med_HS_CL=post_med_CL(1:13);
[A, B ,C_final, D_final ,add_matrices,inv_shock_std] = HS_for_irf( post_med_HS_CL,[],[] );
[obs_HS_CL, states]=simulate_state_space_2( A,B,C_final,D_final*D_final',1230 );
obs_HS_CL=obs_HS_CL(:,1001:end);
obs_HS_CL_array(:,:,dd)=obs_HS_CL;
post_med_JPT_CL=post_med_CL([1:2 14:46]);
[A, B ,C_final, D_final ,add_matrices,inv_shock_std] = modelJPT2_for_irf( post_med_JPT_CL,[],[] );
[obs_JPT_CL, states]=simulate_state_space_2( A,B,C_final,D_final*D_final',1230 );
obs_JPT_CL=obs_JPT_CL([6,7,1],1001:end);
obs_JPT_CL_array(:,:,dd)=obs_JPT_CL;
end



cd ../HS

load results


for dd=1:number_draws
dd/number_draws
    post_med_RRR=draws(:,randi(size(draws,2),1));


[A, B ,C_final, D_final ,add_matrices,inv_shock_std] = HS_for_irf( post_med_RRR,[],[] );

[obs_HS_ML, states]=simulate_state_space_2( A,B,C_final,D_final*D_final',1230 );
obs_HS_ML=obs_HS_ML(:,1001:end);
obs_HS_ML_array(:,:,dd)=obs_HS_ML;
end


cd ../JPT_single_model
load results

for dd=1:number_draws
    dd/number_draws
post_med_JPT=draws(:,randi(size(draws,2),1));


[A, B ,C_final, D_final ,add_matrices,inv_shock_std] = modelJPT_for_irf( post_med_JPT,[],[] );

[obs_JPT_ML, states]=simulate_state_space_2( A,B,C_final,D_final*D_final',1230 );
obs_JPT_ML=obs_JPT_ML([6,7,1],1001:end);
obs_JPT_ML_array(:,:,dd)=obs_JPT_ML;

end


