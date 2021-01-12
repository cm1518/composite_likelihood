function [ l_vec] = posterior_l_vec( params,setup,data )
%function that returns log posterior vector
%doesn't take into account prior - not clear how to adjust Qu's approach to
%take into account prior. Asymptotically this will not matter
%[ params ] = inv_transform( params,setup.index_log, setup.index_logit,setup.index_logit_general, setup.length_log,setup.length_logit,setup.length_logit_general,setup.logit_general_lb,setup.logit_general_ub );





if setup.likelihood==1
      % ll_function=SSKF_wrap( params,setup,data );
      %[lnpost x add_matrices]=SSKF_wrap_withstates( params,setup,data );
       disp('not implemented - check posterior_l_vec.m')
       
   elseif setup.likelihood==2
       %ll_function=KF_wrap;
       [lnpost, x, add_matrices,l_vec]=KF_wrap_withstates_l_vec( params,setup,data );
       

  
   end

  % prior_sum=sum(prior_values(setup.index_model{1}));



l_vec=l_vec*params(end-setup.number_models+1:end);

% prior_values
%    lnpost

end

