%simulates models using prior and computes the prior distribution of
%various cross correlations between variables


setup_estimated_weights_5_models;


number_of_draws_prior=1000;


sample_size_for_simul=200;
burn_in_for_simul=200;
%number of parmaters (minus estimated weights)
number_of_params=max(setup.index_block{setup.number_blocks-1});

param_draws=zeros(number_of_params,number_of_draws_prior);

for nn=1:number_of_draws_prior
    
    %get a valid draw from prior (so far I've only implemented normal priors)
    
    if length(setup.index_normal)~=number_of_params
       disp('not all parmaters have normal priors - the current program will not work as intended') 
        
    end
    non_neg=0;
    general_bounds=0;
    logit=0;
    
    while ~non_neg && ~general_bounds && ~logit
       param_draws(:,nn)=mvnrnd(setup.normal_prior_means,diag(setup.normal_prior_std.^2)); 
        if all(param_draws(setup.index_log,nn)>0)
        non_neg=1;
        end
        
        if all(param_draws(setup.index_logit,nn)>0) && all(param_draws(setup.index_logit,nn)<1)
        logit=1;
        end
        
        if all(param_draws(setup.index_logit_general,nn)>setup.logit_general_lb) && all(param_draws(setup.index_logit_general,nn)<setup.logit_general_ub)
        general_bounds=1;
        end
    end
    
for mm=1:setup.number_models
wrapper_func=str2func(setup.wrapper{mm});
[A, B, C, D, add_matrices]=wrapper_func([param_draws(setup.index_model{1},nn);param_draws(setup.index_model{mm+1},nn)],setup,data{mm});
[obs, states] = simul_state_space( A,B,C,D,sample_size_for_simul+burn_in_for_simul );
 if any(mm==[1 2 4 5])
corr_matrix(:,:,nn,mm)=corr(obs([1 2 3],burn_in_for_simul+1:end)');
 elseif mm==3
     corr_matrix(:,:,nn,mm)=corr(obs([6 7 1],burn_in_for_simul+1:end)');
end

end

end


figure;
for mm=1:setup.number_models
subplot(1,setup.number_models,mm)
hist(squeeze(corr_matrix(1,2,:,mm)))
end

figure;
for mm=1:setup.number_models
subplot(1,setup.number_models,mm)
hist(squeeze(corr_matrix(1,3,:,mm)))
end

figure;
for mm=1:setup.number_models
subplot(1,setup.number_models,mm)
hist(squeeze(corr_matrix(3,2,:,mm)))
end