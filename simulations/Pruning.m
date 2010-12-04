% Filename: Pruning.m
%
% Calculate burstmeasure from several pruned trees, and show traces for
% some example trees.
%
% Author: Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University
%
%
% Set path to location spike analysis script

addpath(genpath('./../analysis'))

FilenameBase='Pruning/Results/Sim';
FiguresNameBase='Pruning/Figures/';
offset=0; % Offset 0 -> indices for .dat filenames start at 1, Offset -1 -> indices for .dat filenames start at 0
Filename='';
ISI_Cutoff=3000;
Analysis_Start=1000;
stimulation={'somatic','dendritic'}

% Specify endianness
machineformat='l';

% Morphological parameter ranges
dendStimRange =[0,1];

% Specify Seeds
Seed_step=1;
Seed_start=1;
Seed_end=20; % Seed_end=20; was used in paper
Seed_simrange=Seed_start:Seed_step:Seed_end;
Seed_plotrange=1:1:length(Seed_simrange);

% Specify Pruning Depths
PruningDepth_step=1;
PruningDepth_start=0;
PruningDepth_end=20;
PruningDepth_simrange=PruningDepth_start:PruningDepth_step:PruningDepth_end;
PruningDepth_plotrange=1:1:length(PruningDepth_simrange);

% Map ranges to reusable variables
x_plotrange=Seed_plotrange;
x_simrange=Seed_simrange;
x_plot_size=length(x_plotrange);

y_plotrange=PruningDepth_plotrange;
y_simrange=PruningDepth_simrange;
y_plot_size=length(y_plotrange);

% Preallocate storage objects
spikes=cell(2,x_plot_size,y_plot_size);
tvec=cell(2,x_plot_size,y_plot_size);
yvec=cell(2,x_plot_size,y_plot_size);

f=zeros(2,x_plot_size,y_plot_size);
B2=zeros(2,x_plot_size,y_plot_size);
MeanISI=zeros(2,x_plot_size,y_plot_size);

Depth=zeros(2,y_plot_size);
B2Mean=zeros(2,y_plot_size);
B2SEM=zeros(2,y_plot_size);
fMean=zeros(2,y_plot_size);
fSEM=zeros(2,y_plot_size);

% Load simulation results and calculate quantities of interest: burstmeasure
% , MeanISI, spikeFrequency. 
for dendStim=dendStimRange+1  
    for y_coord=1:1:y_plot_size     %PruneDepth
        for x_coord=1:1:x_plot_size % Seed

            Filename=[FilenameBase,'_',num2str(dendStim),'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_j4a_spikes_j4a_spikes_soma.dat']        
            j4a_spikes_soma=nrn_vread(Filename,machineformat);                                             
            
            [B2(dendStim,x_coord,y_coord),MeanISI(dendStim,x_coord,y_coord)] = burstMeasure(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start),ISI_Cutoff);
            if(isnan(B2)==1)
                B2=-1;
            end

            spikes{dendStim,x_coord,y_coord}=j4a_spikes_soma;

            f(dendStim,x_coord,y_coord)=spikeFrequency(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start));
            
        end
        [B2Mean(dendStim,y_coord),B2SEM(dendStim,y_coord)]=grpstats(B2(dendStim,:,y_coord)',ones(x_plot_size,1), {'mean','sem'});
        [fMean(dendStim,y_coord),fSEM(dendStim,y_coord)]=grpstats(f(dendStim,:,y_coord)',ones(x_plot_size,1),{'mean','sem'});
        
        Depth(dendStim,y_coord)=y_simrange(y_plotrange(y_coord));
    end
end

%%
figure(3)
trace_indices={[2,6],[2,6];[2,7],[2,7];[17,6],[17,6];[17,7],[17,7]};
for dendStim=dendStimRange+1
    subplot(2,2,dendStim)
    errorbar(Depth(dendStim,:),B2Mean(dendStim,:),B2SEM(dendStim,:),'r.')
    set(gca,'Box','off')
    xlabel('Prune depth')
    ylabel('Burstiness')
    xlim([0,20])
    ylim([0,0.8])
    title(stimulation{dendStim})
end

for row_no=1:2
    for col_no=1:2
        for dendStim=dendStimRange+1
            trace_seed=trace_indices{(row_no-1)*2+col_no,dendStim}(1);
            trace_depth=trace_indices{(row_no-1)*2+col_no,dendStim}(2);
            x_coord=trace_seed;
            y_coord=trace_depth;

            Filename=[FilenameBase,'_',num2str(dendStim),'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_j4a_vtrace_soma_tvec.dat'];         
            tvec{dendStim,x_coord,y_coord}=nrn_vread(Filename,machineformat);

            Filename=[FilenameBase,'_',num2str(dendStim),'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_j4a_vtrace_soma_yvec.dat'];         
            yvec{dendStim,x_coord,y_coord}=nrn_vread(Filename,machineformat);

            position=(row_no-1)*24+(col_no-1)*3+(dendStim-1)*6+61
            subplot(16,6,position:position+2)
            plot(tvec{dendStim,trace_seed,trace_depth},yvec{dendStim,trace_seed,trace_depth},'k-')

            ylim([-80,40])
            set(gca,'Visible','off')
            xlim([2000,3000])           
        end
    end
end

subplot(16,6,position:position+2)
scaleBar(2800,-70,100,50,'100 ms','50 mV')



%%
figure(301)

for dendStim=dendStimRange+1
    subplot(2,2,dendStim)
    hold on        
    for y_coord=1:1:x_plot_size
        A=zeros(y_plot_size,1);
        A(1:end,1)=B2(dendStim,y_coord,1:end);
        plot(Depth(dendStim,:),A,'r.')
    end
    set(gca,'Box','off')
    xlabel('Prune depth')
    ylabel('Burstiness')
    xlim([0,20])
    ylim([0,0.8])
    title(stimulation{dendStim})
end


%% 
figure(302)
clf
A=zeros(y_plot_size,1);
for x_coord=1:1:x_plot_size;
    
    subplot(4,5,x_coord)
    hold on
    A(1:1:y_plot_size,1)=B2(1,x_plotrange(x_coord),:);
    plot(y_plotrange,A,'r+')
    A(1:1:y_plot_size,1)=B2(2,x_plotrange(x_coord),:);
    plot(y_plotrange,A,'bo')
    set(gca,'Box','off')
    xlabel('Index')
    ylabel('Burstiness')
    xlim([0,21])
    ylim([0,0.9])
    myText=['Seed=',num2str(x_coord)];
    text(12,0.7,myText)
end

subplot(4,5,1)

legend(stimulation)