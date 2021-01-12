%creates cell with objects needed for estimation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%number of draws after burn-in 
setup.number_of_draws=100000;

%number of draws for choosing the scaling matrix in case of standard RW
%proposal
setup.scaling_draws=20000;%10000
%scaling is recomputed after check_scaling draws
setup.check_scaling=500;%200

%scaling is recomputed after check_scaling draws
setup.check_scaling=500;%200
%initial scaling for standard RW proposal
setup.initial_scaling=[.0007]';
%proposal=1 ->standard RW
%adaptive MH not implemented in this code
setup.proposal=1;
%log likelihood computation
%likelihood=1 -> SS KF (only uses the SS covariance matrix, initial mean
%still has to be provided)
%likelihood=2 ->  KF

setup.likelihood=2;
%name of function that evaluates log prior
setup.prior_function='prior'; %right now prior function has to be called prior.m!
%initial value for the state and covariance of the state
setup.skip_opt=1; %skip optimization and go directly to MCMC (previously saved values are used then)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


setup.TVKF=0; %does the state space model feature time-varying matrices?


setup.state_size=32;
setup.sample_size=231;
%should additional matrices be stored
setup.add_matrices=0;
%dimension of those variables
setup.dim_add_matrices=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%name of dataset - see main_example.m for construction - different models
%can have different datasets
setup.data=['data.mat'];



%names of files that map parameters into state space matrices (i.e. solve models)
setup.wrapper='CK3'; 



%=1 if initial values (means and covariance matrix) for Kalman filter are provided
setup.initial_provided=1;

%initial values

setup.state_initial=[zeros(31,1);1]; %nk1 - 1 is for the intercept


temp_cov=zeros(32,32);
temp_cov(1:31,1:31)=eye(31);

setup.cov_initial=temp_cov; %nk1



%storage and display options

%display every disp iter draw
setup.disp_iter=1e7;
% keep every keep_draw th draw
setup.keep_draw=1;







%priors 
load prior_and_initial;
setup.initial_parameter=initial_parameter;
setup.index_normal=index_normal;
setup.normal_prior_means=normal_prior_means;
setup.normal_prior_std=normal_prior_std;
setup.index_gamma=[];


%parameter transformations for proposal (we want proposal to be unrestricted)


load restrictions

setup.index_logit_general=index_logit_general;
 setup.logit_general_lb=logit_general_lb;
setup.logit_general_ub=logit_general_ub;
setup.length_logit_general=length(setup.index_logit_general);


setup.index_log=index_log;
setup.length_log=length(setup.index_log);

setup.index_logit=index_logit;
setup.length_logit=length(setup.index_logit);



setup.length_param_vector=length(setup.initial_parameter);


setup.number_blocks=1;
setup.index_block{1}=[1:setup.length_param_vector]';

