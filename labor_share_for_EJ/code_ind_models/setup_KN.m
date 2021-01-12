%creates cell with objects needed for estimation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%number of draws after burn-in 
setup.number_of_draws=60000;

%number of draws for choosing the scaling matrix in case of standard RW
%proposal
setup.scaling_draws=30000;%10000
%scaling is recomputed after check_scaling draws
setup.check_scaling=500;%200
%initial scaling for standard RW proposal
setup.initial_scaling=[10000 5]';
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
setup.skip_opt=0; %skip optimization and go directly to MCMC (previously saved values are used then)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


setup.TVKF=0; %does the state space model feature time-varying matrices?


setup.state_size=14;
setup.sample_size=size(data,2);
%should additional matrices be stored
setup.add_matrices=0;
%dimension of those variables
setup.dim_add_matrices=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%name of dataset - see main_example.m for construction - different models
%can have different datasets
setup.data=['data.mat'];



%names of files that map parameters into state space matrices (i.e. solve models)
setup.wrapper='KN'; 



%=1 if initial values (means and covariance matrix) for Kalman filter are provided
setup.initial_provided=1;

%initial values

setup.state_initial=[zeros(13,1);1]; 


temp_cov=zeros(14,14);
temp_cov(1:13,1:13)=eye(13);

setup.cov_initial=temp_cov; %nk1



%storage and display options

%display every disp iter draw
setup.disp_iter=500;
% keep every keep_draw th draw
setup.keep_draw=1;





%priors - I use normal priors in this example. Right now the code only
%allows for normal and gamma priors, but than can easily be modified

setup.index_normal=[1:8]; % index for parameters that have normal priors

setup.normal_prior_means=[1 1 .9  .9 .9 1 1 1]';
setup.normal_prior_std=1*setup.normal_prior_means;
setup.normal_prior_std(1)=.4;
setup.index_gamma=[];


%parameter transformations for proposal (we want proposal to be unrestricted)



setup.index_logit_general=[];
 setup.logit_general_lb=[];

 
setup.logit_general_ub=[];
setup.length_logit_general=0;


setup.index_log=[1 2 6 7 8];
setup.length_log=5;


setup.index_logit=[3 4 5];
setup.length_logit=length(setup.index_logit);


 setup.number_blocks=2;
 setup.index_block{1}=[1]';
setup.index_block{2}=[2:8]';


% setup.number_blocks=2;
% setup.index_block{1}=[1 2 6 7]';
% setup.index_block{2}=[3 4 5]';


setup.initial_parameter=setup.normal_prior_means;
setup.initial_parameter(1)=1.15;
setup.length_param_vector=length(setup.initial_parameter);
