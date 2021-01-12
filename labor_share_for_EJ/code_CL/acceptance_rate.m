function [ acc_rate ,last_param_draw,new_posterior] = acceptance_rate( posterior_draw,cov_matrix,scaling,number_of_draws,old_posterior,setup, data,block )
%calculates the acceptance rate of running the standard MH algorithm for
%number_of_draws
acceptances=0;

if block ~=1
[log_post, ~, ~]=posteriorwithstates_single_model(posterior_draw,setup,data,block-1);

end   
  

for nn=1:number_of_draws
  
param_prop=proposal_draw(posterior_draw(setup.index_block{block}),cov_matrix, scaling,setup);
param_prop=param_prop';
posterior_draw_prop=posterior_draw;
posterior_draw_prop(setup.index_block{block})=param_prop;
if block==1;

[post_prop, ~, ~,~]=posteriorwithstates(posterior_draw_prop,setup,data);

else
[post_prop_mm, x_prop, add_matrix_prop]=posteriorwithstates_single_model(posterior_draw_prop,setup,data,block-1);
%post_prop=posterior(param_prop,setup,data);
post_prop=old_posterior-log_post+post_prop_mm;
% if block==2
%    post_prop-posterior(posterior_draw_prop,setup,data) 
% end
end
alpha=min(1,exp(post_prop-old_posterior+adjustment( posterior_draw,posterior_draw_prop,setup )));
if rand<alpha
   posterior_draw=posterior_draw_prop;
   old_posterior=post_prop;
%    if block==2
%       posterior(posterior_draw,setup,data)-old_posterior 
%        
%    end
   acceptances=acceptances+1;
   if block~=1
   log_post=post_prop_mm;
   end
end
%  if block==1
%    alpha
%       posterior_draw_prop
%   end


acc_rate=acceptances/number_of_draws;
last_param_draw=posterior_draw;
new_posterior=old_posterior;
end

