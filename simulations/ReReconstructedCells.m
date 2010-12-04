% Filename: ReReconstructedCells.m
%
% Show traces from cells with different apical dendritic tree topologies
% ,but unchanged metrics.
%
%
% Author: Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University
%
%
close all
clear all

% Set path to location spike analysis script
addpath(genpath('./../analysis'))

% Set paths to neuron output
FilenameBase='ReReconstructedCells/Results/Sim';
FiguresNameBase='ReReconstructedCells/Figures/';
offset=0; % Offset 0 -> indices for .dat filenames start at 1, Offset -1 -> indices for .dat filenames start at 0
Filename='';

% Specify analysis parameters
ISI_Cutoff=3000;
Analysis_Start=1500;

% Specify endianness neuron binary files
machineformat='l';

% Morphological parameter ranges
TreeNo_step=1;
TreeNo_start=1;
TreeNo_end=7;
TreeNo_simrange=TreeNo_start:TreeNo_step:TreeNo_end;
TreeNo_plotrange=[1,5:7,2:4];%1:1:length(TreeNo_simrange);

% Stimulus types
dendStim_step=1;
dendStim_start=0;
dendStim_end=1;
dendStim_simrange=dendStim_start:dendStim_step:dendStim_end;
dendStim_plotrange=1:1:length(dendStim_simrange);
stimuli={'somatic','dendritic'};

% Map ranges to reusable variables
x_plotrange=TreeNo_plotrange;
x_simrange=TreeNo_simrange;
x_plot_size=length(x_plotrange);

y_plotrange=dendStim_plotrange;
y_simrange=dendStim_simrange;
y_plot_size=length(y_plotrange);


% Preallocate storage objects
spikes=cell(x_plot_size,y_plot_size);   % spike times
tvec=cell(x_plot_size,y_plot_size);     % membrane potential trace: times   
yvec=cell(x_plot_size,y_plot_size);     % membrane potential trace: potential

f=zeros(x_plot_size,y_plot_size);        % frequency
B2=zeros(x_plot_size,y_plot_size);       % Burstmeasure
MeanISI=zeros(x_plot_size,y_plot_size);
TreeNumber=zeros(x_plot_size,y_plot_size);  % TreeNumbers 
MEP=zeros(x_plot_size,1);                   % Mean electrontonic pathlength

for y_coord=1:1:y_plot_size
    for x_coord=1:1:x_plot_size
 
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_j4a_spikes_j4a_spikes_soma.dat'];         
        j4a_spikes_soma=nrn_vread(Filename,machineformat);
        
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_j4a_vtrace_soma_tvec.dat'];         
        tvec{x_coord,y_coord}=nrn_vread(Filename,machineformat);
        
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_j4a_vtrace_soma_yvec.dat'];         
        yvec{x_coord,y_coord}=nrn_vread(Filename,machineformat);

        [B2(x_coord,y_coord),MeanISI(x_coord,y_coord)] = burstMeasure(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start),ISI_Cutoff);
        if(isnan(B2)==1)
            B2=-1;
        end

        spikes{x_coord,y_coord}=j4a_spikes_soma;

        f(x_coord,y_coord)=spikeFrequency(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start));
        TreeNumber(x_coord,y_coord)=x_plotrange(x_coord);
    end
end

for x_coord=1:1:x_plot_size
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_mep11.dat'];
        MEP(x_coord,1)=nrn_vread(Filename,machineformat);
end





%%  Plot Membrane Potential 
figure(5)
handles=zeros(x_plot_size,y_plot_size);
for y_coord=1:1:y_plot_size
    for x_coord=1:1:x_plot_size
 
        handles(x_coord,y_coord)=subplot(x_plot_size,y_plot_size,(x_coord-1)*y_plot_size+y_coord);
        plot(tvec{x_coord,y_coord},yvec{x_coord,y_coord},'k-')
        
        xlim([2000,3000])
        ylim([-80,40])
        set(gca,'Visible','off')
       text(3100,40, ['B=',num2str(B2(x_coord,y_coord),'%0.2f')],'FontName','Arial','FontSize',10)
       text(3050,80, ['MEP=',num2str(MEP( x_coord),'%0.2f')],'FontName','Arial','FontSize',10)
    end
end
subplot(x_plot_size,y_plot_size,(x_plot_size-1)*y_plot_size+1)
scaleBar(2800,-70,100,50,'100 ms','50 mV')

%%  Plot Spike Trains 
figure(501)
clf
spikePlot(spikes,gca,100,1000);
ylabel('TreeNumber')
set(gca, 'yticklabel',[1:7,1:7])

%% Plot B2 versus MEP
figure(12)
clf 
hold on
plot(MEP,B2(:,1),'rO','MarkerFaceColor','r')
plot(MEP,B2(:,2),'g^','MarkerFaceColor','g')
ylabel('Bursting')
xlabel('MEP (\lambda)')
title('Bursting vs MEP')
legend(stimuli)

%% Plot B2 versus Tree Number
figure(1201)
clf
hold on
plot(TreeNumber(:,1),B2(:,1)','r+')
plot(TreeNumber(:,1),B2(:,2)','go')
ylabel('Bursting')
xlabel('Tree Number')
xlim([0,8])
title(' B2 versus Tree Number')
legend(stimuli)

%% Plot f versus TreeNumber
figure(1202)
clf 
hold on
plot(TreeNumber(:,1),f(:,1),'r+')
plot(TreeNumber(:,1),f(:,2),'go')
ylabel('Frequency (Hz)')
xlabel('Tree Number')
xlim([0,8])
title(' f versus Tree Number')
legend(stimuli)