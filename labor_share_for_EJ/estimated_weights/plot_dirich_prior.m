for jj=1:length(log_posteriors)
   prior_draw(jj,:)= drchrnd(setup.dirichlet_prior_parameters,1); 
    
    
    
end

model_names={'small NK with wages','small NK','medium scale NK','search and matching','BGG'};
figure;
for mm=1:5
 subplot(2,3,mm)
    hist(prior_draw(:,mm))
    title(model_names{mm})
end

print -depsc


figure; 
for mm=1:5
 subplot(2,3,mm)
    hist(draws(end-5+mm,:))
    title(model_names{mm})
end

print -depsc

pts=0:0.001:1;
[f_post,xi] = ksdensity(draws(end-5+mm,:),pts);


figure; 
for mm=1:5
 subplot(2,3,mm)
    [f_post,~] = ksdensity(draws(end-5+mm,:),pts);
    [f_prior,~] = ksdensity(prior_draw(:,mm),pts);
    plot(pts,f_prior,pts,f_post,'LineWidth',2)
    %legend('prior','posterior')
    title(model_names{mm})
    grid on
end
subplot(2,3,6)
plot(1,1,1,1,'LineWidth',2)
legend('prior','posterior')
 set(gca,'visible','off');
print -depsc
 set(gca,'visible','on');


figure; 
for mm=1:5
 subplot(2,3,mm)
    [f_post,~] = ksdensity(draws(end-5+mm,:),pts);
    [f_prior,~] = ksdensity(prior_draw(:,mm),pts);
    yyaxis left
    plot(pts,f_prior,'--','LineWidth',2)
    yyaxis right
    plot(pts,f_post,'LineWidth',2)
    %legend('prior','posterior')
    title(model_names{mm})
    grid on
end
subplot(2,3,6)
plot(1,1,'--',1,1,'LineWidth',2)
legend('prior','posterior')
 set(gca,'visible','off');
print -depsc
 set(gca,'visible','on');
 
 
 
 figure; 
for mm=1:5
 subplot(2,3,mm)
    histogram(draws(end-5+mm,:),50);
    hold on
    histogram(prior_draw(:,mm),50);
   hold off
    title(model_names{mm})
    grid on
end
subplot(2,3,6)
plot(1,1,1,1,'LineWidth',2)
legend('posterior','prior')
 set(gca,'visible','off');
print -depsc
 set(gca,'visible','on');