clear;
close all;

load results_equal_weights_5_models_org_prior
load data;

step_size=1e-6;
mode_ind=find(log_posteriors==max(log_posteriors), 1 );
mode=draws(:,mode_ind);
T=size(data{1},2)-1;
setup.model_weights=mode(end-4:end);
for pp=1:1
   
    %first increase the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)+step_size*param_for_loop(pp);
    
    [ l_vec_higher] = posterior_for_Hess( param_for_loop,setup,data );
     %now decrease the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)-step_size*param_for_loop(pp);
    
    [ l_vec_lower] = posterior_for_Hess( param_for_loop,setup,data );
    deriv(:,pp)=(l_vec_higher-l_vec_lower)/(2*step_size*param_for_loop(pp));
    
    
    
    
end

prod_gradients=deriv*deriv;


% fun =@(params) posterior_for_Hess( params,setup,data );
% hessian_approxim=hessian_test(fun,mode(1:end-5));

 func='posterior_for_Hess2';
 
 
[Hess_temp,deriv2] = hessian6(func,mode(1),setup,data,mode(2:end));

Hess_temp=-Hess_temp;

 Sum_H_J=Hess_temp+prod_gradients;
 max_eig=max(eig(Sum_H_J));
 det_stat=det(Sum_H_J);
 
 
 