clear;
close all;

load results;
load data;


mode_ind=find(log_posteriors==max(log_posteriors), 1 );
mode=draws(:,mode_ind);
T=size(data,2)-1;


%fun =@(params) posterior_for_Hess( params,setup,data );
%hessian_approxim=hessian_test(fun,mode(1:end));

 func='posterior_for_Hess';
 
 
[Hess_temp, deriv2] = hessian5(func,mode,setup,data);

Hess_temp=reshape(-Hess_temp,length(setup.initial_parameter),length(setup.initial_parameter));
  %Hess_temp=eye(size(Hess_temp,1))/Hess_temp; 

load h1

%setup.model_weights=mode(end-4:end);
for pp=1:length(setup.initial_parameter)
   
    %first increase the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)+h1(pp);
    
    [ l_vec_higher] = posterior_for_Hess( param_for_loop,setup,data );
     %now decrease the parameter
    param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)-h1(pp);
    
    [ l_vec_lower] = posterior_for_Hess( param_for_loop,setup,data );
    deriv(:,pp)=(l_vec_higher-l_vec_lower)/(2*h1(pp));
    
    
    
    
end



prod_gradients=deriv'*deriv;

 Sum_H_J=Hess_temp+prod_gradients;
 max_eig=max(eig(Sum_H_J));
 det=det(Sum_H_J);
 
 pp=1;
 param_vec=-200*h1(pp):2*h1(pp):200*h1(pp);
 for mm=1:length(param_vec)
     param_for_loop=mode;
    param_for_loop(pp)=param_for_loop(pp)+param_vec(mm);
    [ plot_vec(mm)] = posterior_for_Hess( param_for_loop,setup,data );
    
 end
 
 
 
 
 figure;
 plot(param_vec+param_for_loop(pp),plot_vec)
 hold on
 x=[param_for_loop(pp) param_for_loop(pp)];
 y=[min(plot_vec) max(plot_vec)];
 line(x,y,'Color','red')
 hold off
 
 (plot_vec(end)-plot_vec(1))/(param_vec(end)-param_vec(1))
 