function [ MSE] = KF_MSE(A,B,C,D,x10,S10,Y,ind)
%Kalman Filter, returns MSE for observables indicated by ind
%follows Hamilton, pages 380-381 (in particular, equations
%(13.2.19),(13.2.20),(13.2.22) and(13.4.1)).
%state space system is given by:
%y_t=Ax_t+u^y_t
%x_t+1=Cx_t+u^x_t
%u^y_t N(0,B)
%u^x_t N(0,D)
%We assume that the observables Y are of dimension N by T
%initial state is x10 (x(t|t-1)). Same notation for the covariance matrix
%of the state
[N T]=size(Y);
[~, sizex]=size(A);
xest=zeros(sizex,T+1);

xest(:,1)=x10;
llk=0;
MSE=zeros(size(ind,1),1);
if any(isnan(A(:))) || any(isnan(B(:))) || any(isnan(C(:))) || any(isnan(D(:))) ||  any(isinf(A(:))) || any(isinf(B(:))) || any(isinf(C(:))) || any(isinf(D(:)))
llk=-inf;
else
    
for i=1:T
    temp=(A*S10*A'+B);
    if any(isnan(temp(:))) || any(isinf(temp(:)))
        llk=-inf;
        break
    end
    [temp,k]=nearestSPD(temp);
    if k>=100
        llk=-inf;
        break;
    end
    temp2=Y(:,i)-A*xest(:,i);
    MSE=MSE+temp2(ind).*temp2(ind)/T;
    llk=llk+log(2*pi)*(-N/2)+logdet(temp, 'chol')*(-.5)-.5*(temp2)'/temp*temp2;
    K=C*S10*A'/(temp);
    xest(:,i+1)=C*xest(:,i)+K*temp2;
    S10=C*(S10-S10*A'/temp*A*S10)*C'+D;
    S10=(S10+S10')/2; %making sure the covariance matrix stays symmetric
end

end