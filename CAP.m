%% Cosmo-Ages Plotter (CAP)
%  Just plot ages in order
% BGFs are calculated for each group (see https://github.com/angelrodes/CEAA)
%
% Angel Rodes
% SUERC 2020



%% clear previous data and plots
clear
close all hidden
% clc

%% Version
script_version='0.4.1';

%% Import data
fid = fopen('data.csv');
% Sample name , age , uncertainty , moraine name 
mydata = textscan(fid, '%s %f %f %s',...
    'HeaderLines', 1,'Delimiter',',');
fclose(fid);

sample_names=mydata{1};
ages=mydata{2};
uncertainties=mydata{3};
unit_names=mydata{4};



%% Define useful functions

% Normal function
normal_probs=@(mu,sigma,x)...
    1/(sigma*(2*pi())^0.5)*exp(-(x-mu).^2/(2*sigma^2));

% One-sigma-values function
one_sigma_percent=0.682689492;
one_sigma_threshold=@(P)...
    interp1(sort(P,'descend'),...
    find(cumsum(sort(P,'descend')/sum(P))>=one_sigma_percent,1,'first'));
one_sigma_selection=@(P)...
    P>=one_sigma_threshold(P);



%% Calculate
disp('BGF:')
gr=0;
for seq=unique(unit_names)'
    gr=gr+1;
    
    % select samples
    sel=strcmpi(seq{:},unit_names);
    t=linspace(min(ages(sel)-2*std(ages(sel))),max(ages(sel)+2*std(ages(sel))),1000);
    if ~isempty(sel)
        % calulate the kernel density estimation of the unit
        kdei=t.*0;
        for sample=find(sel)'
            kdei=kdei+normal_probs(ages(sample),uncertainties(sample),t);
        end
        KDE=kdei/sum(kdei);
        [mu,sigma] = BFG(t,KDE);
        disp([seq{:} ':' num2str(mu) ' +/- ' num2str(sigma)])
        for sample=find(sel)'
            group(sample)=gr;
            BGFmu(sample)=mu;
            BGFsigma(sample)=sigma;
        end
        % check distributions
        figure
        hold on
        plot(t,KDE,'-k')
        plot(mu+sigma*[-1,1],max(KDE)*[1,1],'-b')
        title([seq{:} ':' num2str(mu) ' +/- ' num2str(sigma)])
    end
end

% sort
groups=1:gr;
for n=groups
    mus(n)=min(BGFmu(group==n));
end
[~,group_order]=sort(mus);

%% Plot
figure
hold on
set(0, 'DefaultLineLineWidth', 2);

x=0;
for gr=group_order
    x=x+1;
    sel=(group==gr);
    xmin=x-0.2;
    for sample=find(sel)
        x=x+1;
%         plot(x*[1,1],ages(sample)+uncertainties(sample)*[-1,1],'-k')
%         plot(x,ages(sample),'.k')
    end
    xmax=x+0.2;
    plot([xmin,xmax,xmax,xmin,xmin],BGFmu(sample)+BGFsigma(sample)*[1,1,-1,-1,1],'-b')
    plot([xmin,xmax],BGFmu(sample)+BGFsigma(sample)*[0,0],'--b')
end

x=0;
for gr=group_order
    x=x+1;
    sel=(group==gr);
    xmin=x-0.2;
    for sample=find(sel)
        x=x+1;
        plot(x*[1,1],ages(sample)+uncertainties(sample)*[-1,1],'-k')
        plot(x,ages(sample),'*k')
    end
    xmax=x+0.2;
    %     plot([xmin,xmax,xmax,xmin,xmin],BGFmu(sample)+BGFsigma(sample)*[1,1,-1,-1,1],'-b')
    %     plot([xmin,xmax],BGFmu(sample)+BGFsigma(sample)*[0,0],'--b')
    text(xmin,max(ages(sel)+1.2*uncertainties(sel)),unit_names{sample},...
             'HorizontalAlignment', 'left', ...
     'VerticalAlignment', 'bottom');
end

set(gca,'xtick',[])
box on 
grid on
