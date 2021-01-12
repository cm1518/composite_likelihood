function [IRF_pdf] = state_density( params,setup,mm,horizon,data, variables, grid ,select)
%returns a matrix of pdf values for the states at the values in vector grid.  

%solve model
wrapper_func=str2func(setup.wrapper{mm});
[A ,B ,C ,D ,add_matrices]=wrapper_func([params(setup.index_model{1});params(setup.index_model{mm+1})],setup,data{mm});

[xest, var_state] = KF_states(A,B,C,D,setup.state_initial{mm},setup.cov_initial{mm},data{mm});

if mm==3
    xest=xest/100;
    var_state=var_state/(100^2);
end


IRF_pdf=zeros(length(grid),horizon);

for hh=1:horizon
mean_irf=select*(xest(:,end-horizon+hh));

var_irf=select*var_state(:,:,end-horizon+hh)*select';
IRF_pdf(:,hh)=normpdf(grid,mean_irf,sqrt(var_irf));

end


