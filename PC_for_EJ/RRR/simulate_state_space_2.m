function [obs states] = simulate_state_space_2( A,B,C,D,periods )
%simulates data from a state space model. For now the initial values of the state are hardcoded at 0.

states=zeros(size(C,1),periods+1);
states(end,1)=1; %intercept
obs=zeros(size(A,1),periods);
for tt=1:periods
states(:,tt+1)=C*states(:,tt)+mvnrnd(zeros(size(C,1),1),D)';
obs(:,tt)=A*states(:,tt+1)+mvnrnd(zeros(size(A,1),1),B)';

end