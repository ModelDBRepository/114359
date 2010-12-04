% Filename: MRC_LoadSimData.m
%
% Demo code showing how to load data from a 2D parameters scan.
%
% First create the DemoOutput directory and run
%         nrngui MRC_DemoNetwork.hoc MRC_DemoMRC_5c.ses
% and press the Loop Run button. Then run this script.
%
% Author: Ronald A.J. van Elburg ,(RonaldAJ at vanelburg eu)
% Affiliation:
%           Department of Artificial Intelligence
%           Groningen University
%

clear all
close all

% Set path to location spike analysis script
addpath(genpath('./../../analysis'))
addpath(genpath('./nrnbinreader'))

FilenameBase='DemoOutput/Sim';
offset=-1; % Offset 0 -> indices for .dat filenames start at 1, Offset -1 -> indices for .dat filenames start at 0
Filename='';

% Specify endianness
machineformat='l';

% Specify Noise in first stimulus
%hoc:             name="NetStimList.o(0).noise"
%                 lower_limit=0
%                 upper_limit=0.9
%                 stepsize=0.3
%                 use=1
%
NOISE_step=0.3;
NOISE_start=0;
NOISE_end=0.9;
NOISE_simrange=NOISE_start:NOISE_step:NOISE_end;
NOISE_plotrange=1:1:length(NOISE_simrange);


% Specify average interval both stimuli
% hoc:            name="NOISEINTERVAL"
%                 lower_limit=10
%                 upper_limit=50
%                 stepsize=10
%                 use=1
%
NOISEINTERVAL_step=10;
NOISEINTERVAL_start=10;
NOISEINTERVAL_end=50;
NOISEINTERVAL_simrange=NOISEINTERVAL_start:NOISEINTERVAL_step:NOISEINTERVAL_end;
NOISEINTERVAL_plotrange=1:1:length(NOISEINTERVAL_simrange);



% Map ranges to reusable variables
x_plotrange=NOISE_plotrange;
x_simrange=NOISE_simrange;
x_plot_size=length(x_plotrange);

y_plotrange=NOISEINTERVAL_plotrange;
y_simrange=NOISEINTERVAL_simrange;
y_plot_size=length(y_plotrange);

% Preallocate storage objects
spikes=cell(x_plot_size,y_plot_size);
tvec=cell(x_plot_size,y_plot_size);
yvec=cell(x_plot_size,y_plot_size);
ic=zeros(x_plot_size,y_plot_size);

% Load simulation results and calculate quantities of interest:
for y_coord=1:1:y_plot_size     %NOISEINTERVAL
    for x_coord=1:1:x_plot_size %NOISE
        
        
        %           hoc:  sectionname="HHCellList.o(1).soma"
        %                 membername="v( 0.5 )"
        %                 ...
        %                 shortname="VmHH2"
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_VmHH2_tvec.dat']
        [tvec{x_coord,y_coord},dummy]=nrn_vread(Filename,machineformat);
        
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_VmHH2_yvec.dat']
        [yvec{x_coord,y_coord},dummy]=nrn_vread(Filename,machineformat);
        
        
        %            hoc:     scalarname="getic()"
        %                     shortname="ic"
        
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_ic.dat']
        [ic(x_coord,y_coord),dummy]=nrn_vread(Filename,machineformat);
        %
        %            hoc:     listname="cellbody"
        %                     sectionname=""
        %                     membername="v(0.5)"
        %                     listtype=2
        %                     ...
        %                     isart=0
        %                     shortname="SingleSection"
        Filename=[FilenameBase,'_',num2str(x_plotrange(x_coord)+offset),'_',num2str(y_plotrange(y_coord)+offset),'_SingleSection_SingleSection_cellbody.dat']
        [spikes{x_coord,y_coord},dummy]=nrn_vread(Filename,machineformat);
        
    end
    
end
%%
for y_coord=1:1:y_plot_size     %NOISEINTERVAL
    for x_coord=1:1:x_plot_size %NOISE
       figure(1)
       
        subplot(y_plot_size,x_plot_size,(y_coord-1)*x_plot_size+ x_coord)
        plot(tvec{x_coord,y_coord}',yvec{x_coord,y_coord}')
        
    end
    
end

%%
 runNo=zeros(x_plot_size,y_plot_size);
for y_coord=1:1:y_plot_size     %NOISEINTERVAL
    for x_coord=1:1:x_plot_size %NOISE
      runNo(x_coord,y_coord)=(y_coord-1)*x_plot_size+ x_coord
        
    end
    
end

figure(2)
plot(runNo(:),ic(:))
ylim([0,0.01])
%%

figure(3)
clf
spikePlot(spikes,gca);

