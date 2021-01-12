%computes adjustment of
%posterior CL intervals.


load results_PC_EJ

load data;





mean_=mean(draws,2);


step_size=1e-6;% (same as Qu)

setup.model_weights=mean(draws(end-4:end,:),2);
%loop to compute derivative parameter by parameter using central finite
%difference scheme

for pp=1:length(setup.initial_parameter)-setup.number_models
   
    %first increase the parameter
    param_for_loop=mean_;
    param_for_loop(pp)=param_for_loop(pp)+step_size*param_for_loop(pp);
    
    [ l_vec_higher] = posterior_l_vec_alt( param_for_loop,setup,data );
     %now decrease the parameter
    param_for_loop=mean_;
    param_for_loop(pp)=param_for_loop(pp)-step_size*param_for_loop(pp);
    
    [ l_vec_lower] = posterior_l_vec_alt( param_for_loop,setup,data );
    deriv(:,pp)=(l_vec_higher-l_vec_lower)/(2*step_size*param_for_loop(pp));
end

score=cov(deriv);


%next, get covariance of draws
T=size(data{1},2);

for dd=1:size(draws,2)
   rescaled_draws(:,dd)=sqrt(T)*(draws(1:end-setup.number_models,dd)-mean_(1:end-setup.number_models)); 
    
    
end
invhess=cov(rescaled_draws');

%straight from Qu's code

[v,d] = svd(invhess);
d=inv(d);
H12 = v*sqrt(d)*v';
[v,d] = svd(score);
S12 = v*sqrt(d)*v';

%%%%%%%%%%%%%%%%%%%%%%%

draws_for_percentiles=invhess*S12*H12*rescaled_draws/sqrt(T);

lower_MCMC=prctile(draws(1:end-setup.number_models,:),5,2);
upper_MCMC=prctile(draws(1:end-setup.number_models,:),95,2);

lower_adjust=prctile(draws_for_percentiles,5,2)+mean_(1:end-setup.number_models);
upper_adjust=prctile(draws_for_percentiles,95,2)+mean_(1:end-setup.number_models);


%compute adjustments
adjustment_lower=abs(lower_adjust-lower_MCMC)./mean_(1:end-setup.number_models);
adjustment_upper=abs(upper_adjust-upper_MCMC)./mean_(1:end-setup.number_models);


intervals_MCMC=upper_MCMC-lower_MCMC;
intervals_adjust=upper_adjust-lower_adjust;

ratio_intervals=intervals_adjust./intervals_MCMC;






draws_adjusted=draws_for_percentiles+mean_(1:end-setup.number_models);




