% Filename: simplifiedTopologiesDConst.m
%
% Calculate burstmeasure for all 23 simplified toplogies over a range of
% lengths, with somatic stimulation.
%
%
% Author:   Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University
%
% Set path to location spike analysis script
clear all
close all


addpath(genpath('./../analysis'))

FilenameBase='SimplifiedTopologiesDConst/Results/Sim_';
FilenameBase2='SimplifiedTopologiesDConst/Results/IC';


Filename='';
ISI_Cutoff=3000;
Analysis_Start=1000;

% Specify endianness
machineformat='l';

% Morphological parameter ranges
bStim =1:1;

Length_step=25;
Length_start=500;
Length_end=2500;
Length_simrange=Length_start:Length_step:Length_end;
Length_plotrange=1:1:length(Length_simrange);

Topology_step=1;
Topology_start=1;
Topology_end=23;
Topology_simrange=Topology_start:Topology_step:Topology_end;
Topology_plotrange=1:1:length(Topology_simrange);

x_plotrange=Length_plotrange;
x_simrange=Length_simrange;
x_plot_size=length(x_plotrange);

y_plotrange=Topology_plotrange;
y_simrange=Topology_simrange;
y_plot_size=length(y_plotrange);

offset=-1;

f=zeros(bStim(end),x_plot_size,y_plot_size);
B2=zeros(bStim(end),x_plot_size,y_plot_size);
MeanISI=zeros(bStim(end),x_plot_size,y_plot_size);
IC=zeros(bStim(end),x_plot_size,y_plot_size);
MEP=zeros(bStim(end),x_plot_size,y_plot_size);

DendArea=zeros(bStim(end),x_plot_size,y_plot_size);

fMat=zeros(x_plot_size,y_plot_size);
ICMat=zeros(x_plot_size,y_plot_size);
B2Mat=zeros(x_plot_size,y_plot_size);
DendAreaMat=zeros(x_plot_size,y_plot_size);
MepMat=zeros(x_plot_size,y_plot_size);

for somaStimulus=bStim 
    for y_coord=1:1:y_plot_size     % Topology
        for x_coord=1:1:x_plot_size % Length

            Filename=[FilenameBase,'0_0_',num2str(somaStimulus+offset),'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_spikes_spikes_soma.dat'];        
            j4a_spikes_soma=nrn_vread(Filename,machineformat);
            
            Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_ic.dat'];       
            [ic,dummy]=nrn_vread(Filename,machineformat);
            IC(somaStimulus,x_coord,y_coord)=ic;
                        
            Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_da.dat'];       
            da=nrn_vread(Filename,machineformat);
            DendArea(somaStimulus,x_coord,y_coord)=da;
  
            Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_mep.dat'];        
            mep=nrn_vread(Filename,machineformat);
            MEP(somaStimulus,x_coord,y_coord)=mep;
            
            [B2(somaStimulus,x_coord,y_coord),MeanISI(somaStimulus,x_coord,y_coord)] = burstMeasure(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start),ISI_Cutoff);

            f(somaStimulus,x_coord,y_coord)=spikeFrequency(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start));
            
        end
   end
end




%%
bStim=1;
figure(8)
clf

scrsz = get(0,'ScreenSize');
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])

   
    
    subplot(3,3,3)
    yvalues=zeros(23,1);
    yvalues(:)=B2( bStim,31,:);
    plot(1:23,yvalues,'k.')
    xlim([0,24])
    ylim([-0.1,1.1])

    subplot(3,3,[1:2,4:5,7:8])
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
figure(9)
clf

scrsz = get(0,'ScreenSize');
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])

%orient landscape
FirstVarMeshParams=Topology_simrange;
SecondVarMeshParams=Length_simrange;

% Meshing things up ...
[FirstVarMesh,SecondVarMesh] = meshgrid(FirstVarMeshParams, SecondVarMeshParams);

somaStimulus=1;
fMat(:,:)=f( somaStimulus,:,:);
ICMat(:,:)=IC( somaStimulus,:,:);
B2Mat(:,:)=B2( somaStimulus,:,:);
DendAreaMat(:,:)=DendArea( somaStimulus,:,:);
MepMat(:,:)=MEP( somaStimulus,:,:);
        
subplot(1,8,1:3)
        cla
        hold on
        image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
        [C,h] =contour(FirstVarMesh,SecondVarMesh,ICMat*1000,0:1:8,'w','Linewidth',3);
        % Set the area to be plotted
        axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
        clabel(C,h,'Color','w')
        caxis auto
        caxis([0,1])
        title('Bursting and IC' )
        ylabel('Length \mum')
        xlabel('Topology')
    
subplot(1,8,4:6)
        cla
        hold on
        image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
        [C,h] =contour(FirstVarMesh,SecondVarMesh,MepMat,0.07:0.07:0.5,'w','Linewidth',3);
        clabel(C,h,'Color','w')
        % Set the area to be plotted
        axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
        clabel(C,h,'Color','w')
        caxis auto
        caxis([0,1])
        title('Bursting and MEP' )
        set(gca,'Ytick',[])
         xlabel('Topology')

subplot(2,8,7:8)
        cla
        hold on
        image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
        % Set the area to be plotted
        axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
        clabel(C,h,'Color','w')
        caxis auto
        caxis([0,1])
        colorbar('EastOutside','YTick',0:0.5:1,'YTicklabel',{'B=0.0','B=0.5','B=1.0'})
        set(gca,'Ytick',[],'Xtick',[])




%%
figure(901)
clf

scrsz = get(0,'ScreenSize');
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])

%orient landscape
FirstVarMeshParams=Topology_simrange;
SecondVarMeshParams=Length_simrange;

% Meshing things up ...
[FirstVarMesh,SecondVarMesh] = meshgrid(FirstVarMeshParams, SecondVarMeshParams);

somaStimulus=1;
fMat(:,:)=f( somaStimulus,:,:);
ICMat(:,:)=IC( somaStimulus,:,:);
B2Mat(:,:)=B2( somaStimulus,:,:);
DendAreaMat(:,:)=DendArea( somaStimulus,:,:);
MepMat(:,:)=MEP( somaStimulus,:,:);



subplot(1,9,1:3)
    cla
    hold on

    image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,ICMat*1000,0:1:8,'w','Linewidth',3);

    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    clabel(C,h,'Color','w')
    caxis auto
    caxis([0,1])
    title('Bursting and IC')
    ylabel('Length \mum')
    xlabel('Topology')

subplot(1,9,4:6)
    cla
    hold on

    image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,MepMat,0.07:0.07:0.5,'w','Linewidth',3);
    clabel(C,h,'Color','w')

    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    clabel(C,h,'Color','w')
    caxis auto
    caxis([0,1])
    title('Bursting and MEP' )
    xlabel('Topology')

subplot(1,9,7:9)
    cla
    hold on

    image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,DendAreaMat,'w','Linewidth',3);
    clabel(C,h,'Color','w')

    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    clabel(C,h,'Color','w')
    caxis auto
    caxis([0,1])
    title('Bursting and DendArea' )
     xlabel('Topology')






%%
figure(902)
clf

scrsz = get(0,'ScreenSize');
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])

%orient landscape
FirstVarMeshParams=Topology_simrange;
SecondVarMeshParams=Length_simrange;

% Meshing things up ...
[FirstVarMesh,SecondVarMesh] = meshgrid(FirstVarMeshParams, SecondVarMeshParams);

somaStimulus=1;
 
fMat(:,:)=f( somaStimulus,:,:);
ICMat(:,:)=IC( somaStimulus,:,:);
B2Mat(:,:)=B2( somaStimulus,:,:);
DendAreaMat(:,:)=DendArea( somaStimulus,:,:);
MepMat(:,:)=MEP( somaStimulus,:,:);

subplot(1,9,1:3)
    cla
    hold on

    image(FirstVarMeshParams,SecondVarMeshParams,fMat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,ICMat*1000,0:1:8,'w','Linewidth',3);

    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    clabel(C,h,'Color','w')
    caxis auto

    title('Frequency and IC' )
    ylabel('Length \mum')
    xlabel('Topology')

subplot(1,9,4:6)
    cla
    hold on

    image(FirstVarMeshParams,SecondVarMeshParams,fMat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,MepMat,0.05:0.07:0.5,'w','Linewidth',3);
    clabel(C,h,'Color','w')

    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    clabel(C,h,'Color','w')
    caxis auto

    title('Frequency  and MEP' )
    xlabel('Topology')


subplot(1,9,7:9)
    cla
    hold on

    image(FirstVarMeshParams,SecondVarMeshParams,fMat,'CDataMapping','scaled')
    [C,h] =contour(FirstVarMesh,SecondVarMesh,DendAreaMat/1000,4:2:30,'w','Linewidth',3); % Scaling of matrix fixes a matlab bug.
    %      [C,h] =contour(FirstVarMesh,SecondVarMesh,DendAreaMat,'w','Linewidth',3);
    clabel(C,h,'Color','w')

    % Set the area to be plotted
    axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
    caxis auto

    title('Frequency  and DendArea' )
    xlabel('Topology')



%%
figure(903)
clf
bStim=1;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])

for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,1,1)
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
        
        subplot(3,1,2)
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
        
        subplot(3,1,3)
        hold on
        plot(MEP( somaStimulus,:,y_coord),B2( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        
        set(gca,'Box','off')
        xlabel('MEP')
        ylabel('Burstiness') 
    end
     xlim([min(MEP(:)),max(MEP(:))])
end

%%
figure(904)
clf
bStim=1;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])
for somaStimulus=bStim
    for y_coord=1:1:y_plot_size;
        
        subplot(3,1,1)
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
        
        subplot(3,1,2)
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
        
        subplot(3,1,3)
        hold on
        plot(MEP( somaStimulus,:,y_coord),f( somaStimulus,:,y_coord) ,'-','Color',[1-y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23,y_simrange(y_plotrange(y_coord))/23])
        
        set(gca,'Box','off')
        xlabel('MEP')
        ylabel('Frequency') 
    end
     xlim([min(MEP(:)),max(MEP(:))])
end

