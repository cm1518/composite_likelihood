function [IRF_pdf] = IRF_density2_real2( params,setup,mm,horizon,data, variables, shock,grid ,select)
%returns a matrix of pdf values for the irfs at the values of irfs in vector grid.  

%solve model
wrapper_func=str2func([setup.wrapper{mm},'_for_irf']);
[A ,B ,C ,D ,add_matrices,inv_shock_std]=wrapper_func([params(setup.index_model{1});params(setup.index_model{mm+1})],setup,data{mm});




IRF_pdf=zeros(length(grid),horizon);
state_shock_size=size(D,2);
shock_vec=zeros(state_shock_size,1);
if mm~=3
shock_vec(shock)=.5*0.023*inv_shock_std;
elseif mm==3
    shock_vec(shock)=.5*0.023*inv_shock_std;
end
Omega=zeros(state_shock_size,state_shock_size);
Omega(shock,shock)=(.5*0.023*inv_shock_std*0.5)^2;
for hh=1:horizon
mean_irf=select*C^(hh-1)*D*shock_vec;

var_irf=select*C^(hh-1)*D*Omega*D'*(C^(hh-1))'*select';
IRF_pdf(:,hh)=normpdf(grid,mean_irf,sqrt(var_irf));

end


