clear;
close all;

load results;
load data;

step_size=1e-6;
mode_ind=find(log_posteriors==max(log_posteriors), 1 );
mode=draws(:,mode_ind);
T=size(data,2)-1;
%setup.model_weights=mode(end-4:end);
for pp=1:length(setup.initial_parameter)
   
    %first increase the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)+step_size*param_for_loop(pp);
    
    [ l_vec_higher] = posterior_l_vec( param_for_loop,setup,data );
     %now decrease the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)-step_size*param_for_loop(pp);
    
    [ l_vec_lower] = posterior_l_vec( param_for_loop,setup,data );
    deriv(:,pp)=(l_vec_higher-l_vec_lower)/(2*step_size*mode(pp));
    
    
    
    
end



prod_gradients=zeros(setup.length_param_vector,setup.length_param_vector);

for tt=1:T
   prod_gradients=prod_gradients+1/T*(deriv(tt,:)'*deriv(tt,:)); 
    
end
%fun =@(params) posterior_for_Hess( params,setup,data );
%hessian_approxim=hessian_test(fun,mode(1:end));

 func='posterior_for_Hess';
 
 
Hess_temp = hessian4(func,mode,setup,data);

Hess_temp=reshape(-Hess_temp,length(setup.initial_parameter),length(setup.initial_parameter));
  %Hess_temp=eye(size(Hess_temp,1))/Hess_temp; 


 Sum_H_J=Hess_temp+prod_gradients;
 max_eig=max(eig(Sum_H_J));
 det=det(Sum_H_J);
 
 
 