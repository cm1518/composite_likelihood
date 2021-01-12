%computes sample covariance of first derivative needed for adjustment of
%posterior CL intervals.



load results_equal_weights_5_models;
load data;


%find posterior mode
mode_ind=min(find(log_posteriors==max(log_posteriors)));

mode=draws(:,mode_ind);


step_size=1e-6;% (same as Qu)


%loop to compute derivative parameter by parameter using central finite
%difference scheme

for pp=1:length(setup.initial_parameter)
    pp/length(setup.initial_parameter)
    %first increase the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)+step_size*param_for_loop(pp);
    
    [ l_vec_higher] = posterior_l_vec( param_for_loop,setup,data );
     %now decrease the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)-step_size*param_for_loop(pp);
    
    [ l_vec_lower] = posterior_l_vec( param_for_loop,setup,data );
    deriv(:,pp)=(l_vec_higher-l_vec_lower)/(2*step_size*param_for_loop(pp));
end

score=cov(deriv);