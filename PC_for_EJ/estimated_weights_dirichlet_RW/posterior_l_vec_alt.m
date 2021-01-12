function [ l_vec] = posterior_l_vec_alt( params,setup,data )





if setup.likelihood==1
      % ll_function=SSKF_wrap( params,setup,data );
      %[lnpost x add_matrices]=SSKF_wrap_withstates( params,setup,data );
       disp('not implemented - check posterior_l_vec.m')
       
   elseif setup.likelihood==2
       %ll_function=KF_wrap;
       [lnpost, x, add_matrices,l_vec]=KF_wrap_withstates_l_vec( params,setup,data );
       
   
  
   end

  % prior_sum=sum(prior_values(setup.index_model{1}));



l_vec=l_vec*setup.model_weights;

% prior_values
%    lnpost

end

