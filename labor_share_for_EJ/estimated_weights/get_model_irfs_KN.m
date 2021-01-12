
cd ../code_ind_models
temp_name='results_KN';

for mm=1:5
load(strcat(temp_name,num2str(mm))) 

get_model_irfs_consumption_simul;
end
cd ../estimated_weights



