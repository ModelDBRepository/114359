% Filename: simplifiedTopologiesGKCaGActScanPanels.m
%
% Calculate burstmeasure from several pruned trees, and show trace from
% some example trees.
%
% Author: Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University
%
%

% Set path to location spike analysis script

close all
clear all

addpath(genpath('./../analysis'))


FilenameBase='SimplifiedTopologiesGKCaGActScan/Results/Sim';
FilenameBase2='SimplifiedTopologies/Results/IC';
FiguresNameBase='SimplifiedTopologiesGKCaGActScan/Figures/ScanPanel';

Filename='';
ISI_Cutoff=3000;
Analysis_Start=1000;

% Specify endianness
machineformat='l';

% Morphological parameter ranges
bStim =2:2; %bStim =1:2; used in paper

Length_step=500; %Length_step=25;used in paper
Length_start=1000;
Length_end=3500;
Length_simrange=Length_start:Length_step:Length_end;
Length_plotrange=1:1:length(Length_simrange);

Topology_step=11;%Topology_step=1; used in paper
Topology_start=1;
Topology_end=23;
Topology_simrange=Topology_start:Topology_step:Topology_end;
Topology_plotrange=1:3; %Topology_plotrange=1:23;; used in paper

x_plotrange=Length_plotrange;
x_simrange=Length_simrange;
x_plot_size=length(x_plotrange);

y_plotrange=Topology_plotrange;
y_simrange=Topology_simrange;
y_plot_size=length(y_plotrange);


% Meshing morphological parameter ranges ...
FirstVarMeshParams=Topology_simrange;
SecondVarMeshParams=Length_simrange;
[FirstVarMesh,SecondVarMesh] = meshgrid(FirstVarMeshParams, SecondVarMeshParams);

% Variables for storing simulation data
spikes=cell(bStim(end),x_plot_size,y_plot_size);
tvec=cell(bStim(end),x_plot_size,y_plot_size);
yvec=cell(bStim(end),x_plot_size,y_plot_size);

offset=-1;

f=zeros(bStim(end),x_plot_size,y_plot_size);
B2=zeros(bStim(end),x_plot_size,y_plot_size);
MeanISI=zeros(bStim(end),x_plot_size,y_plot_size);
IC=zeros(bStim(end),x_plot_size,y_plot_size);
MEP=zeros(bStim(end),x_plot_size,y_plot_size);
SCC=zeros(bStim(end),x_plot_size,y_plot_size);

DendArea=zeros(bStim(end),x_plot_size,y_plot_size);

fMat=zeros(x_plot_size,y_plot_size);
ICMat=zeros(x_plot_size,y_plot_size);
B2Mat=zeros(x_plot_size,y_plot_size);
SCCMat=zeros(x_plot_size,y_plot_size);

DendAreaMat=zeros(x_plot_size,y_plot_size);
MepMat=zeros(x_plot_size,y_plot_size);

Depth=zeros(bStim(end),y_plot_size);
B2Mean=zeros(bStim(end),y_plot_size);
B2SEM=zeros(bStim(end),y_plot_size);
fMean=zeros(bStim(end),y_plot_size);
fSEM=zeros(bStim(end),y_plot_size);

% Ion channel density factors
GKCaFactorRange=1:2;
GKCaFactorValues=0.7:0.6:1.3; % GKCaFactorValues=0.7:0.2:1.3; used in paper
NoOfRows=length(GKCaFactorRange);


GKmFactorRange =1:2;
GKmFactorValues=0.7:0.6:1.3; %GKmFactorValues=0.7:0.2:1.3; used in paper
NoOfCols=length(GKmFactorRange);



axes_handles=zeros(NoOfRows,NoOfCols);
%GNaFactorRange=1;
GNaFactorRange=1:2;

GNaFactorValues = 0.9:0.2:1.1; %GNaFactorValues=0.7:0.2:1.3; used in paper

bStim=[1,2]; % bStim=[1,2];used in paper

% Start figure
scrsz = get(0,'ScreenSize');
%figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])

for GNaFactor=GNaFactorRange;

   
   for somaStimulus=bStim
      FigureNo=600+100*(2-somaStimulus)+GNaFactor;
      
      figureHandle=figure(FigureNo);
      set(figureHandle,'PaperType','A4')
      set(figureHandle,'Position',[1 scrsz(4) scrsz(3)/2 scrsz(4)])
      
      FigureName=[FiguresNameBase,'GNa',num2str(10*GNaFactorValues(GNaFactor)),'somastim',num2str(somaStimulus)];
      
      clf
      myFigureTitle=['GKCa vs GKm Scan with ',num2str(100*GNaFactorValues(GNaFactor)), ' percent of original Na ionchannels'];
      

      for GKCaFactor=GKCaFactorRange
         for GKmFactor=GKmFactorRange
            
            ImageNo=GKCaFactor+NoOfRows*(GKmFactor-1);
            axes_handles(GKmFactor,GKCaFactor)=subplot(NoOfCols,NoOfRows,ImageNo);
            cla
            if(GKCaFactor==3 && GKmFactor==1)
                title(myFigureTitle)
            end
           if(GKCaFactor==1 )
                ylabel({['f_{Km}=',num2str(GKmFactorValues(GKmFactor))], 'Length (\mum)'})
            end
            
            if(GKmFactor==NoOfRows )
                xlabel({'Topology',['f_{KCa}=',num2str(GKCaFactorValues(GKCaFactor))]})
            end
            hold on
            % Read  subplot simulation data
            for y_coord=1:1:y_plot_size     % Topology
               for x_coord=1:1:x_plot_size % Length

                  Filename=[FilenameBase,'_',num2str(GNaFactor-1),'_',num2str(GKmFactor-1),'_',num2str(GKCaFactor-1),'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(somaStimulus+offset),'_',num2str(x_plotrange(x_coord)+offset),'_spikes_spikes_soma.dat'];
                  j4a_spikes_soma=nrn_vread(Filename,machineformat);

                  Filename=[FilenameBase2,'_',num2str(y_plotrange(y_coord)+offset),'_',num2str(x_plotrange(x_coord)+offset),'_mep.dat'];
                  mep=nrn_vread(Filename,machineformat);
                  MEP(somaStimulus,x_coord,y_coord)=mep;

                  [B2(somaStimulus,x_coord,y_coord),MeanISI(somaStimulus,x_coord,y_coord)] = burstMeasure(j4a_spikes_soma(j4a_spikes_soma > Analysis_Start),ISI_Cutoff);
                  
                  if(isnan(B2(somaStimulus,x_coord,y_coord))==1)
                     %                 B2(somaStimulus,x_coord,y_coord)=-1;
                  end

                  spikes{somaStimulus,x_coord,y_coord}=j4a_spikes_soma;
                  
               end

               Depth(somaStimulus,y_coord)=y_simrange(y_plotrange(y_coord));
            end

            % Plot subplot
            B2Mat(:,:)=B2( somaStimulus,:,:);
            MepMat(:,:)=MEP( somaStimulus,:,:);

            image(FirstVarMeshParams,SecondVarMeshParams,B2Mat,'CDataMapping','scaled')
            [C,h] =contour(FirstVarMesh,SecondVarMesh,MepMat,0.18+(1-somaStimulus)*0.04:0.16:1,'w','Linewidth',2);
            clabel(C,h,'Color','w')
            set(gca, 'YTick',[1250,1750,2250,2750,3250])
            
            % Set the area to be plotted
            axis( [FirstVarMesh(1),FirstVarMesh(end),SecondVarMeshParams(1),SecondVarMeshParams(end)] )
            clabel(C,h,'Color','w')
            caxis([0,1])


         end
      end
   end
end


       

