temp=squeeze(IRFS(1,:,:,:)-IRFS(2,:,:,:));
temp1=zeros(size(temp,1),1,size(temp,3));
temp2=zeros(size(temp,1),1,size(temp,3));

equal_weights=ones(5,1)/5;
estimated_weights=mean(draws(end-4:end,:),2);
for mm=1:5
   temp1=temp1+equal_weights(mm)*temp(:,mm,:); 
   temp2=temp2+estimated_weights(mm)*temp(:,mm,:); 
end

temp1=squeeze(temp1);

IRFs_equal_weights=prctile(temp1,50,2);

temp2=squeeze(temp2);

IRFs_estimated_weights=prctile(temp2,50,2);