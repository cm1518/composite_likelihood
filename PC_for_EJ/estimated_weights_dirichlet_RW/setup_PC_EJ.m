

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%General Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%number of draws 
setup.number_of_draws=5000;

setup.proposal=1;

%number of draws for choosing the scaling matrix in case of standard RW
%proposal
setup.scaling_draws=8000;
%scaling is recomputed after check_scaling draws
setup.check_scaling=250;%200
%initial scaling for standard RW proposal
setup.initial_scaling=[7 .0001 .01 .001 0.008 .001]'; %note that right now there is no scaling parameter for the dirichlet params
%proposal=1 ->standard RW
%log likelihood computation
%likelihood=1 -> SS KF (only uses the SS covariance matrix, initial mean
%still has to be provided)
%likelihood=2 ->  KF

setup.likelihood=2;
%name of function that evaluates log prior
setup.prior_function='prior'; %right now prior function has to be called prior.m!
%initial value for the state and covariance of the state

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


setup.TVKF=0; %does the state space model feature time-varying matrices?

%the next 5 values should be kept fixed 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setup.state_size=0;
setup.sample_size=0;
%should additional matrices be stored
setup.add_matrices=1;
%dimension of those variables
setup.dim_add_matrices=[5 1];
setup.skip_opt=1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%name of dataset - see main_example.m for construction - different models
%can have different datasets
setup.data=['data.mat'];



%names of files that map parameters into state space matrices (i.e. solve models)
setup.wrapper{1}='RRR'; %NK model with wages
setup.wrapper{2}='RRR_small'; %NK model without wages
setup.wrapper{3}='modelJPT'; %large NK model
setup.wrapper{4}='CK3'; %search & matching model
setup.wrapper{5}='BGG'; 
%=1 if initial values (means and covariance matrix) for Kalman filter are provided
setup.initial_provided=1;

%initial values
for jj=1:2
setup.state_initial{jj}=[zeros(16,1);1]; 
end

setup.state_initial{3}=[zeros(56,1);1]; 
setup.state_initial{4}=[zeros(31,1);1];
setup.state_initial{5}=[zeros(19,1);1];
temp_cov=zeros(17,17);
temp_cov(1:16,1:16)=eye(16);
for jj=1:2
setup.cov_initial{jj}=temp_cov; 
end
temp_cov=zeros(57,57);
temp_cov(1:56,1:56)=eye(56);
setup.cov_initial{3}=temp_cov; 

temp_cov=zeros(32,32);
temp_cov(1:31,1:31)=eye(31);

setup.cov_initial{4}=temp_cov;

temp_cov=zeros(20,20);
temp_cov(1:19,1:19)=eye(19);
setup.cov_initial{5}=temp_cov;

%storage and display options

%display every disp iter draw
setup.disp_iter=500;
% keep every keep_draw th draw
setup.keep_draw=1;



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











setup.number_blocks=7;
setup.index_block{1}=[1]';
setup.index_block{2}=[2:14]';
setup.index_block{3}=[15:26]';
setup.index_block{4}=[27:60]';
setup.index_block{5}=[61:79]';
setup.index_block{6}=[80:92]';
setup.index_block{7}=[93:97]';
%information on the models
setup.number_models=5; %number of models
setup.index_model{1}=[1]';
setup.index_model{2}=[2:14];
setup.index_model{3}=[15:26];
setup.index_model{4}=[27:60];
setup.index_model{5}=[61:79];
setup.index_model{6}=[80:92];
setup.index_model{7}=[93:97];

setup.weight_index=[93;94;95;96;97];
load dirichlet_prior_setting

setup.dirichlet_scaling=dirichlet_scaling;

setup.dirichlet_prior_parameters=dirichlet_prior_parameters;





setup.length_param_vector=length(setup.initial_parameter);
