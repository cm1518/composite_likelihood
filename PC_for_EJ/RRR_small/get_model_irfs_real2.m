
load data;


%set variable and shock indices (irf to technology shock)
shocks_=shocks(mm);
variables_=variables(:,mm);
indices_temp=randi(size(draws,2),number_of_draws,1);




for nn=1:number_of_draws


[IRFS(:,:,mm,1+simulations*(nn-1):simulations*nn)] = IRF_simul_real2( draws(:,indices_temp(nn)),setup,horizon,data, variables_, shocks_,simulations,mm);


end
