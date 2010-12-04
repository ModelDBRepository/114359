% Filename: simplifiedTopologies.m
%
% Calculate burstmeasure for all 23 simplified toplogies over a range of
% lengths, with both dendritic and somatic stimulation.
%
% Author:   Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University
%
%
close all
clear all

% Set path to location spike analysis script
addpath(genpath('./../analysis'))

FilenameBase='SimplifiedTopologies/Results/Sim';
FilenameBase2='SimplifiedTopologies/Results/IC';
FiguresNameBase='SimplifiedTopologies/Figures/';
offset=-1; % Offset 0 -> indices for .dat filenames start at 1, Offset -1 -> indices for .dat filenames start at 0
Filename='';
ISI_Cutoff=3000;
Analysis_Start=1000;

% Specify endianness
machineformat='l';

% Morphological parameter ranges
bStim =1:2;

% Morphological parameter ranges
Length_step=25;
Length_start=1000;
Length_end=3500;
Length_simrange=Length_start:Length_step:Length_end;
Length_plotrange=1:1:length(Length_simrange);

Topology_step=1;
Topology_start=1;
Topology_end=23;
Topology_simrange=Topology_start:Topology_step:Topology_end;
Topology_plotrange=1:23;

% Map ranges to reusable variables
x_plotrange=Length_plotrange;
x_simrange=Length_simrange;
x_plot_size=length(x_plotrange);

y_plotrange=Topology_plotrange;
y_simrange=Topology_simrange;
y_plot_size=length(y_plotrange);

% Preallocate storage objects
spikes=cell(bStim(end),x_plot_size,y_plot_size);
tvec=cell(bStim(end),x_plot_size,y_plot_size);          %membrane potential vector: times
yvec=cell(bStim(end),x_plot_size,y_plot_size);          %membrane potential vector: membrane potential

f=zeros(bStim(end),x_plot_size,y_plot_size);             % frequency
B2=zeros(bStim(end),x_plot_size,y_plot_size);            % Burstmeasure
MeanISI=zeros(bStim(end),x_plot_size,y_plot_size);
IC=zeros(bStim(end),x_plot_size,y_plot_size);           % Input Conductance
MEP=zeros(bStim(end),x_plot_size,y_plot_size);          % Mean Electrotonic Pathlength
DendArea=zeros(bStim(end),x_plot_size,y_plot_size);

fMat=zeros(x_plot_size,y_plot_size);                     % frequency
ICMat=zeros(x_plot_size,y_plot_size);                   % Input Conductance
B2Mat=zeros(x_plot_size,y_plot_size);                   % Burstmeasure
DendAreaMat=zeros(x_plot_size,y_plot_size);
MepMat=zeros(x_plot_size,y_plot_size);                  % Mean Electrotonic Pathlength

Depth=zeros(bStim(end),y_plot_size);

for somaStimulus=bStim
    for y_coord=1:1:y_plot_size     % Topology
        for x_coord=1:1:x_plot_size % Length
            
            Filename=[FilenameBase,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(somaStimulus+offset),'_',num2str(x_plotrange(x_coord)+offset),'_spikes_spikes_soma.dat'];
            j4a_spikes_soma=nrn_vread(Filename,machineformat);
            
            Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_ic.dat'];
            ic=nrn_vread(Filename,machineformat);
            IC(somaStimulus,x_coord,y_coord)=ic;
                        
            Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_da.dat'];
            da=nrn_vread(Filename,machineformat);
            DendArea(somaStimulus,x_coord,y_coord)=da;
            
            Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_mep.dat'];
            mep=nrn_vread(Filename,machineformat);
            MEP(somaStimulus,x_coord,y_coord)=mep;
            
            [B2(somaStimulus,x_coord,y_coord),MeanISI(somaStimulus,x_coord,y_coord)] = burstMeasure(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start),ISI_Cutoff);
           
            spikes{somaStimulus,x_coord,y_coord}=j4a_spikes_soma;
            
            f(somaStimulus,x_coord,y_coord)=spikeFrequency(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start));
            
        end
        
        Depth(somaStimulus,y_coord)=y_simrange(y_plotrange(y_coord));
    end
end

%%
figure(6)
clf
bStim=2;

% Plot Membrane potential traces at fixed lengths (1750 um) and different topologies
tops4fig=[1,6,11,12,17,23];
for t=0:5
    subplot(11,10,2+t*5:5+t*5)
    Filename=[FilenameBase,'_VTraces_',num2str(tops4fig(t+1)-1),'_1_0_vtrace_soma_yvec.dat'];
    vm=nrn_vread(Filename,machineformat);
    Filename=[FilenameBase,'_VTraces_',num2str(tops4fig(t+1)-1),'_1_0_vtrace_soma_tvec.dat'];
    tsteps=nrn_vread(Filename,machineformat);
    plot(tsteps,vm)
    xlim([3000,4000])
    set(gca,'Visible','off')
end
scaleBar(3500,-70,100,100,'100 ms','100 mV');

% Plot Burstmeasure at fixed lengths (1750 um) and different topologies
subplot(22,3,24:3:39)
yvalues=zeros(23,1);
yvalues(:)=B2( bStim,31,:);
plot(1:23,yvalues,'k.')
xlim([0,24])
ylim([-0.1,1.1])


% Plot Membrane potential traces at fixed topology  (topology 1) and
% different lengths 1000:300:2900 um

subplot(22,5,[74:5:109,75:5:110])
% L_simrange=1000:100:4000;
L_plotrange=0:3:19;

hold on
for L_index=1:length(L_plotrange)
    Filename=[FilenameBase,'_T1_VTraces_0_1_',num2str(L_plotrange(L_index)),'_vtrace_soma_yvec.dat'];
    vm=nrn_vread(Filename,machineformat);
    Filename=[FilenameBase,'_T1_VTraces_0_1_',num2str(L_plotrange(L_index)),'_vtrace_soma_tvec.dat'];
    tsteps=nrn_vread(Filename,machineformat);
    plot(tsteps,vm-L_index*160)
    xlim([3000,4000])
    set(gca,'Visible','off')
end
scaleBar(3500,-470,100,100,'100 ms','100 mV');

% Plot B2 vs Length with Toplogy related offset 
subplot(11,5,[16+5:5:51,17+5:5:52,18+5:5:53])
hold on
NoOfColors=23;
vspace=0.05;

for y_coord=1:1:y_plot_size;
    ColorShift=mod(y_coord-1,NoOfColors)/(NoOfColors-1);
    plot(x_simrange(x_plotrange),B2( bStim,:,y_coord)+vspace*(23-y_simrange(y_plotrange(y_coord))),'-','Color',[1-ColorShift,ColorShift,ColorShift])
    
    set(gca,'Box','off')
    xlabel('Length')
    ylabel('Burstiness')
    ylim([-0.1,1.1+22*vspace])
end


%%
bStim=1;
figure(7)

clf

% Plot Membrane potential traces at fixed lengths (1900 um) and different topologies
tops4fig=[1,6,11,12,17,23];
for t=0:5
    subplot(11,10,2+t*5:5+t*5)
    Filename=[FilenameBase,'_VTraces_',num2str(tops4fig(t+1)-1),'_0_1_vtrace_soma_yvec.dat'];
    vm=nrn_vread(Filename,machineformat);
    Filename=[FilenameBase,'_VTraces_',num2str(tops4fig(t+1)-1),'_0_1_vtrace_soma_tvec.dat'];
    tsteps=nrn_vread(Filename,machineformat);
    plot(tsteps,vm)
    xlim([3000,4000])
    ylim([-80,70])
    set(gca,'Visible','off')
end
scaleBar(3500,-70,100,100,'100 ms','100 mV');

% Plot Burstmeasure at fixed lengths (1900 um) and different topologies
subplot(22,3,24:3:39)
    yvalues=zeros(23,1);
    yvalues(:)=B2( bStim,37,:);
    plot(1:23,yvalues,'k.')
    xlim([0,24])
    ylim([-0.1,1.1])

% Plot Membrane potential traces at fixed topology (topology 1) and
% different lengths 1000:400:3500 um
subplot(22,5,[74:5:109,75:5:110])
% L_simrange=1000:100:4000;
L_plotrange=0:4:25;

hold on
for L_index=1:length(L_plotrange)
    Filename=[FilenameBase,'_T1_VTraces_0_0_',num2str(L_plotrange(L_index)),'_vtrace_soma_yvec.dat'];
    vm=nrn_vread(Filename,machineformat);
    Filename=[FilenameBase,'_T1_VTraces_0_0_',num2str(L_plotrange(L_index)),'_vtrace_soma_tvec.dat'];
    tsteps=nrn_vread(Filename,machineformat);
    plot(tsteps,vm-L_index*160)
    xlim([2500,3500])
end
set(gca,'Visible','off')
scaleBar(3500,-470,100,100,'100 ms','100 mV');

% Plot B2 vs Length with Topology related offset 
subplot(11,5,[16+5:5:51,17+5:5:52,18+5:5:53])

hold on
NoOfColors=23;
vspace=0.05;

for y_coord=1:1:y_plot_size;
    ColorShift=mod(y_coord-1,NoOfColors)/(NoOfColors-1);
    plot(x_simrange(x_plotrange),B2( bStim,:,y_coord)+vspace*(23-y_simrange(y_plotrange(y_coord))),'-','Color',[1-ColorShift,ColorShift,ColorShift])

    set(gca,'Box','off')
    xlabel('Length')
    ylabel('Burstiness')
    xlim([1000,3500])
    ylim([-0.1,1.1+22*vspace])
end


%%
figure(10)
clf
bStim=[1,2];
titles={'Dendritic stimulation','Somatic stimulation'};
FirstVarMeshParams=Topology_simrange;
SecondVarMeshParams=Length_simrange;

% Meshing things up ...
[FirstVarMesh,SecondVarMesh] = meshgrid(FirstVarMeshParams, SecondVarMeshParams);

for somaStimulus=bStim
    startIndex=3*(3-somaStimulus)-2;
    endIndex=3*(3-somaStimulus);
    subplot(1,8,startIndex:endIndex)
    cla
    hold on
    fMat(:,:)=f( somaStimulus,:,:);
    ICMat(:,:)=IC( somaStimulus,:,:);
    B2Mat(:,:)=B2( somaStimulus,:,:);
    DendAreaMat(:,:)=DendArea( somaStimulus,:,:);
    MepMat(:,:)=MEP( somaStimulus,:,:);
    
    image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,MepMat,0.18+(1-somaStimulus)*0.04:0.16:1,'w','Linewidth',3);
    clabel(C,h,'Color','w')
    
    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    clabel(C,h,'Color','w')
    caxis auto
    caxis([0,1])
    title(titles{somaStimulus})
    if(somaStimulus==2)
         ylabel('Length')
    else
        set(gca,'Ytick',[])
    end
end


subplot(2,8,7:8)
cla
hold on
fMat(:,:)=f( somaStimulus,:,:);
ICMat(:,:)=IC( somaStimulus,:,:);
B2Mat(:,:)=B2( somaStimulus,:,:);
DendAreaMat(:,:)=DendArea( somaStimulus,:,:);
MepMat(:,:)=MEP( somaStimulus,:,:);

image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')

% Set the area to be plotted
axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
clabel(C,h,'Color','w')
caxis auto
caxis([0,1])
colorbar('EastOutside','YTicklabel',{'B=0.0','B=0.5','B=1.0'})
set(gca,'Ytick',[],'Xtick',[])

 
%%
figure(1001)
clf
bStim=[1,2];
for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,2,somaStimulus)
        hold on
        plot(DendArea( somaStimulus,:,y_coord),B2( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        set(gca,'Box','off')
        xlabel('Dendritic Surface Area')
        ylabel('Burstiness')
        
    end
    xlim([min(DendArea(:)),max(DendArea(:))])
end

for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,2,somaStimulus+2)
        hold on
        plot(IC( somaStimulus,:,y_coord),B2( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        set(gca,'Box','off')
        xlabel('Input Conductance')
        ylabel('Burstiness')
    end
     xlim([min(IC(:)),max(IC(:))])
end

for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,2,somaStimulus+4)
        hold on
        plot(MEP( somaStimulus,:,y_coord),B2( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        
        set(gca,'Box','off')
        xlabel('MEP')
        ylabel('Burstiness') 
    end
     xlim([min(MEP(:)),max(MEP(:))])
end

%%
figure(1002)
clf
bStim=[1,2];
for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,2,somaStimulus)
        hold on
        plot(DendArea( somaStimulus,:,y_coord),f( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        set(gca,'Box','off')
        xlabel('Dendritic Surface Area')
        ylabel('Frequency')
        
    end
    xlim([min(DendArea(:)),max(DendArea(:))])
end

for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,2,somaStimulus+2)
        hold on
        plot(IC( somaStimulus,:,y_coord),f( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        set(gca,'Box','off')
        xlabel('Input Conductance')
        ylabel('Frequency')
    end
     xlim([min(IC(:)),max(IC(:))])
end

for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,2,somaStimulus+4)
        hold on
        plot(MEP( somaStimulus,:,y_coord),f( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        
        set(gca,'Box','off')
        xlabel('MEP')
        ylabel('Frequency') 
    end
     xlim([min(MEP(:)),max(MEP(:))])
end

