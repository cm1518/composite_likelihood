%creates cell with objects needed for estimation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set seed
rng(1)
%number of draws after burn-in 
setup.number_of_draws=100000;
%adaptive MH not implemented in this code
setup.proposal=1;

%number of draws for choosing the scaling matrix in case of standard RW
%proposal
setup.scaling_draws=50000;%10000
%scaling is recomputed after check_scaling draws
setup.check_scaling=500;%200
%initial scaling for standard RW proposal
setup.initial_scaling=[10000 5 5 5 5 5]';
%proposal=1 ->standard RW
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

%the next 4 values should be kept fixed 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setup.state_size=0;
setup.sample_size=0;
%should additional matrices be stored
setup.add_matrices=1;
%dimension of those variables
setup.dim_add_matrices=[5 1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%name of dataset - see main_example.m for construction - different models
%can have different datasets
setup.data=['data.mat'];



%names of files that map parameters into state space matrices (i.e. solve models)
setup.wrapper{1}='KN'; 
setup.wrapper{2}='KN'; 
setup.wrapper{3}='KN'; 
setup.wrapper{4}='KN'; 
setup.wrapper{5}='KN'; 
%=1 if initial values (means and covariance matrix) for Kalman filter are provided
setup.initial_provided=1;

%initial values




setup.state_initial{1}=[zeros(13,1);1]; 
setup.state_initial{2}=[zeros(13,1);1]; 

setup.state_initial{3}=[zeros(13,1);1];
setup.state_initial{4}=[zeros(13,1);1];
setup.state_initial{5}=[zeros(13,1);1];




for jj=1:5
    temp_cov=zeros(length(setup.state_initial{jj}),length(setup.state_initial{jj}));
temp_cov(1:length(setup.state_initial{jj})-1,1:length(setup.state_initial{jj})-1)=eye(length(setup.state_initial{jj})-1);
setup.cov_initial{jj}=temp_cov; 
end

%storage and display options

%display every disp iter draw
setup.disp_iter=500;
% keep every keep_draw th draw
setup.keep_draw=1;





%priors - I use normal priors in this example. Right now the code only
%allows for normal and gamma priors, but than can easily be modified




%using uniform priors throughout
setup.index_normal=[1:36];

temp=[1 .9  .9 .9 1 1 1];
temp=repmat(temp,1,5);
setup.normal_prior_means=[1;temp']; % index for parameters that have normal priors
                       
setup.normal_prior_std=1*setup.normal_prior_means;
setup.normal_prior_std(1)=.4;
setup.index_gamma=[];
%setup.initial_parameter=setup.normal_prior_means;
%setup.initial_parameter(1)=1.5;
%parameter transformations for proposal (we want proposal to be unrestricted)
setup.index_logit_general=[];
 setup.logit_general_lb=[];
 setup.logit_general_ub=[];
setup.length_logit_general=0;


setup.index_log=[1 2 6 7 8 13 14 15 16 20 21 22 23 27 28 29 30 34 35 36];
setup.length_log=length(setup.index_log);

setup.index_logit=[3 4 5 10 11 12 17 18 19 24 25 26 31 32 33]; 
setup.length_logit=length(setup.index_logit);









setup.number_blocks=7;
setup.index_block{1}=[1]';
setup.index_block{2}=[2:8]';
setup.index_block{3}=[9:15]';
setup.index_block{4}=[16:22]';
setup.index_block{5}=[23:29]';
setup.index_block{6}=[30:36]';
setup.index_block{7}=[37:41]';
%information on the models
setup.number_models=5; %number of models
setup.index_model{1}=[1]';
setup.index_model{2}=[2:8];
setup.index_model{3}=[9:15];
setup.index_model{4}=[16:22];
setup.index_model{5}=[23:29];
setup.index_model{6}=[30:36];
setup.index_model{7}=[37:41];
%setup.model_weights=[1/5 1/5 1/5 1/5 1/5]; %model weights

%load starting_value %max os posterior from previous run
   
setup.weight_index=[37;38;39;40;41];
setup.dirichlet_scaling=50;

temp_prior_weights=60*[1/5 1/5 1/5 1/5 1/5]';
setup.dirichlet_prior_parameters=temp_prior_weights;
%load starting_value max of posterior from previous run

load max_draw_fixed
setup.initial_parameter=max_draw_fixed;
setup.initial_parameter=[setup.initial_parameter;temp_prior_weights/sum(temp_prior_weights)];




setup.length_param_vector=length(setup.initial_parameter);
