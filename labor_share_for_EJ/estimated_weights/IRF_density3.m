function [IRF_pdf] = IRF_density3( params,setup,mm,horizon,data, variables, shock,grid )
%returns a matrix of pdf values for the paths of variables after the shock.  

%solve model
wrapper_func=str2func([setup.wrapper{mm},'_for_irf']);
[A ,B ,C ,D ,add_matrices]=wrapper_func([params(setup.index_model{1});params(setup.index_model{mm+1})],setup,data{mm});

IRF_pdf=zeros(length(grid),horizon);
state_shock_size=size(D,2);
shock_vec=zeros(state_shock_size,1);
shock_vec(shock)=1;
Omega=eye(size(shock_vec,1));
Omega(shock,shock)=0;
for hh=1:horizon
mean_irf=A*C^(hh-1)*D*shock_vec;
var_irf=C^(hh-1)*(D*Omega*D')*(C^(hh-1))';
var_irf_2=zeros(size(var_irf));
for hh_index=1:hh
if hh_index>1
var_irf_2=C^(hh-hh_index)*(D*D')*(C^(hh-hh_index))'+var_irf_2;
end

end
var_irf=A*(var_irf+var_irf_2)*A';
IRF_pdf(:,hh)=normpdf(grid,mean_irf(variables),sqrt(var_irf(variables,variables)));

end


