med=median(draws,2);
fifth=prctile(draws,5,2);
ninetyfifth=prctile(draws,95,2);
 
rowLabels = {'$\kappa_p$', '$\gamma_b$','$\epsilon$','$h$','$\sigma$','$\phi$','$\gamma$','$wage_index$','$\theta$','$\gamma_R$','$\gamma_{\pi}$','$\gamma_y$',...
    '$\rho_{eb}$','$\rho_{money}$','$\rho_{g}$','$\rho_{z}$','$\sigma_{eb}$','$\sigma_{money}$','$\sigma_{g}$','$\sigma_{z}$'};
   columnLabels = {'5th percentile', 'median','95th percentile'};
  matrix2latex([fifth med ninetyfifth], 'out.tex', 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.2f');
  
