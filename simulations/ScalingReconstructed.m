% Filename: ScalingReconstructed.m
%
% Plot burstmeasure and frequency for trees whose length has been rescaled.
%
%
% Author:   Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University

clear all
close all

% Set path to location spike analysis script
addpath(genpath('./../analysis'))

FilenameBase='ScalingReconstructed/Results/Sim';
FiguresNameBase='ScalingReconstructed/Figures/';
offset=0; % Offset 0 -> indices for .dat filenames start at 1, Offset -1 -> indices for .dat filenames start at 0
Filename='';
pwd()
ISI_Cutoff=3000;
Analysis_Start=1000;

% Stimulus Regimes
dendStimRange =[0,1];

% Morphological parameter range
L_Factor_step=0.1;
L_Factor_start=0.5;
L_Factor_end=2.5;
L_Factor_simrange=L_Factor_start:L_Factor_step:L_Factor_end;
L_Factor_plotrange=1:1:length(L_Factor_simrange);


% Map range to reusable variables
x_plotrange=L_Factor_plotrange;
x_simrange=L_Factor_simrange;
x_plot_size=length(x_plotrange);

spikes=cell(x_plot_size,2); % spike times
tvec=cell(x_plot_size,length(dendStimRange)); % membrane potential trace: times   
yvec=cell(x_plot_size,length(dendStimRange)); % membrane potential trace: potential



% Preallocate storage objects
f=zeros(x_plot_size,2);  % frequency
B2=zeros(x_plot_size,2); % Burstmeasure
MeanISI=zeros(x_plot_size,2);
for dendStim=dendStimRange+1
    for x_coord=1:1:x_plot_size

        Filename=[FilenameBase,'_',num2str(dendStim),'_',num2str(x_plotrange(x_coord)+offset),'_j4a_spikes_j4a_spikes_soma.dat'];
        machineformat='l';
        [j4a_spikes_soma,errmsg]=nrn_vread(Filename,machineformat);

        Filename=[FilenameBase,'_',num2str(dendStim),'_',num2str(x_plotrange(x_coord)+offset),'_j4a_vtrace_soma_tvec.dat'];      
        tvec{x_coord,dendStim}=nrn_vread(Filename,machineformat);
        
        Filename=[FilenameBase,'_',num2str(dendStim),'_',num2str(x_plotrange(x_coord)+offset),'_j4a_vtrace_soma_yvec.dat'];         
        yvec{x_coord,dendStim}=nrn_vread(Filename,machineformat);
        
        [B2(x_coord,dendStim),MeanISI(x_coord,dendStim)] = burstMeasure(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start),ISI_Cutoff);
        if(isnan(B2)==1)
            B2=-1;
        end
        
        spikes{x_coord,1}=j4a_spikes_soma';

        f(x_coord,dendStim)=spikeFrequency(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start));
    end
end

%% Plot B vs Scaling Factor
figure(4)
clf

y_plot_size=length(dendStimRange);
x_plot_range2=2:2:x_plot_size-6;
x_plot_size2=length(x_plot_range2);
handles=zeros(x_plot_size2,y_plot_size);

for dendStim=dendStimRange+1
    handles(1,dendStim)=subplot(x_plot_size2+2,2,[dendStim,dendStim+2]);
    plot(L_Factor_simrange(L_Factor_plotrange),B2(:,dendStim),'k+')
    xlim([0.4,2.6])
    ylim([-0.1,0.9])
    set(gca,'Box','off')
    xlabel('L-Factor')
    ylabel('Burstiness')
end

for dendStim=dendStimRange+1
    for x_coord=1:1:x_plot_size2
 
        handles(x_coord,dendStim)=subplot(x_plot_size2+2,y_plot_size,(x_coord-1)*y_plot_size+dendStim+4);
        plot(tvec{x_plot_range2(x_coord),dendStim},yvec{x_plot_range2(x_coord),dendStim},'k-')
        
        xlim([2000,3000])
        ylim([-80,40])
        set(gca,'Visible','off')
        text(3100,40, ['B=',num2str(B2(x_plot_range2(x_coord),dendStim),'%0.2f')],'FontName','Arial','FontSize',10)
        text(3100,80, ['LFactor=',num2str(L_Factor_simrange(x_plot_range2(x_coord)),'%0.2f')],'FontName','Arial','FontSize',10)
    end
end

subplot(x_plot_size2+2,y_plot_size,(x_plot_size2-1)*y_plot_size+1+4)
scaleBar(2800,-70,100,50,'100 ms','50 mV');

%% Plot f versus Scaling factor
figure(401)
for dendStim=dendStimRange+1
    subplot(2,2,dendStim)
    plot(L_Factor_simrange(L_Factor_plotrange),f(:,dendStim),'k+')
    xlim([0.4,2.6])
    ylim([0,30])
    set(gca,'Box','off')
    xlabel('L-Factor')
    ylabel('f (Hz)')
end


