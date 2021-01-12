clear;
clc;
close all;

tic

load results_PC_EJ



for jj=1:length(log_posteriors)
   prior_draw(jj,:)= drchrnd(setup.dirichlet_prior_parameters,1); 
    
    
    
end

model_names={'small NK with wages','small NK','medium scale NK','search and matching','BGG'};


pts=0:0.001:1;



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

savefig('figure5.fig')
toc
 
 
