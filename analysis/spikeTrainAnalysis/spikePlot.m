% SPIKEPLOT.M Display spike rasters.
%
% Author: Ronald van Elburg  (RonaldAJ at vanElburg eu)
%
% Matlab script for the paper:
%
% Ronald A.J. van Elburg and Arjen van Ooyen (2010) `Impact of dendritic size and
% dendritic topology on burst firing in pyramidal cells', 
% PLoS Comput Biol 6(5): e1000781. doi:10.1371/journal.pcbi.1000781.
%
% Please consult readme.txt or instructions on the usage of this file.
%
% This software is released under the GNU GPL version 3: 
% http://www.gnu.org/copyleft/gpl.html
%
%   SPIKEPLOT(T) Plots the rasters of spiketimes (T in samples) for N trials, each of length
%   L samples, Sampling rate = 1kHz. Spiketimes are hashed by the trial length.
%
%   SPIKEPLOT(T,H) Plots the rasters in the axis handle H
%
%   SPIKEPLOT(T,H,FS) Plots the rasters in the axis handle H. Using a sampling rate of FS (Hz)
%
%   SPIKEPLOT(T,H,low,high) Plots the rasters in the axis handle H. Only
%   using spikes in  the specified interval
%
%   Example:
%          ExpData=cell(3,1)
%          ExpData{1}=[20,90,300];
%          ExpData{2}=[33,95,277];
%          ExpData{3}=[43,91,332];
%          spikeplot(ExpData);
%
%   Adapted from rasterplot.m by Rajiv Narayan, askrajiv@gmail.com, Boston University, Boston, MA

function [hresp,yticks]=spikePlot(spiketrains,varargin)
nin=nargin;

%%%%%%%%%%%%%% Plot variables %%%%%%%%%%%%%%
plotwidth=1;     % spike thickness
plotcolor='k';   % spike color
trialheight=0.7;    % distance between trials
defaultfs=1000;  % default sampling rate
showtimescale=1; % display timescale
showlabels=1;    % display x and y labels
marklength=0.5;  % length of mark
usebounds=0;     % apply upperbounds to data
%%%%%%%%% Code Begins %%%%%%%%%%%%
switch nin
    case 1 %no handle so plot in a separate figure
        figure;
        hresp=gca;
        fs=defaultfs;
    case 2 %handle supplied
        hresp=varargin{1};
        if (~ishandle(hresp))
            error('Invalid handle');
        end
        fs=defaultfs;
   case 3 %colors supplied
        hresp=varargin{1};
        if (~ishandle(hresp))
            error('Invalid handle');
        end
        fs=defaultfs;
        plotcolor = varargin{2};
    case 4 %fs supplied
        hresp=varargin{1};
        if (~ishandle(hresp))
            error('Invalid handle');
        end
        fs = varargin{3};
    case 5 %fs supplied
        hresp=varargin{1};
        if (~ishandle(hresp))
            error('Invalid handle');
        end
       fs=defaultfs;
       plotcolor = varargin{2};
       lowerbound=varargin{3};
       upperbound=varargin{4};
       usebounds=1;
    otherwise
        error ('Invalid Arguments');
end

HoldState = ishold;
hold on

% plot spikes
[rows,cols]=size(spiketrains);
noOfSpiketrains=rows*cols;

if(usebounds==1)
    for spiketrain = 1:noOfSpiketrains
        mySpiketrain=spiketrains{spiketrain};
        fitbounds=(lowerbound < mySpiketrain).*(mySpiketrain<upperbound);
        spiketrains{spiketrain}=mySpiketrain(fitbounds>0);
    end
end

maxSpiketrainLen=max(cellfun('size',spiketrains,2));

% Take care of multidimensional cases
while(length(maxSpiketrainLen)>1)
    maxSpiketrainLen=max(maxSpiketrainLen);
end

xx=ones(2*noOfSpiketrains,maxSpiketrainLen)*nan;
yy=ones(2*noOfSpiketrains,maxSpiketrainLen)*nan;
yticks=zeros(noOfSpiketrains,1);

maximum_t=2;

for spiketrain=0:noOfSpiketrains-1
    yy(2*spiketrain+1,1:maxSpiketrainLen)=spiketrain*trialheight+(trialheight-marklength)/2;
    yy(2*spiketrain+2,1:maxSpiketrainLen)=yy(2*spiketrain+1,1:maxSpiketrainLen)+marklength;
    yticks(spiketrain+1)=spiketrain*trialheight+trialheight-marklength/2;

    spiketrainLen=length(spiketrains{spiketrain+1});
    for spike=1:spiketrainLen
        xx(2*spiketrain+1,spike)=spiketrains{spiketrain+1}(spike)*1000/fs;
        xx(2*spiketrain+2,spike)=spiketrains{spiketrain+1}(spike)*1000/fs;
    end
    if(length(spiketrains{spiketrain+1})>0)
        maximum_t=ceil(max(maximum_t,max(spiketrains{spiketrain+1})));
    end
end


xlim=[1, (maximum_t+1)*1000/fs];

axes(hresp);



if(~iscell(plotcolor))
    for spiketrain=0:noOfSpiketrains-1
        line(xx(2*spiketrain+1:2*spiketrain+2,:),yy(2*spiketrain+1:2*spiketrain+2,:),'Color',plotcolor,'LineWidth',plotwidth)
    end
else
    for spiketrain=0:noOfSpiketrains-1
        line(xx(2*spiketrain+1:2*spiketrain+2,:),yy(2*spiketrain+1:2*spiketrain+2,:),'Color',plotcolor{spiketrain+1,1},'LineWidth',plotwidth)
    end
end

axis ([xlim,0,(noOfSpiketrains)*trialheight+(trialheight-marklength)/2]);

set(hresp,'YDir','reverse');
set(hresp,'Box','On');
if (showtimescale)
    set(hresp, 'ytick', yticks,'yticklabel',1:noOfSpiketrains,'tickdir','out');
else
    set(hresp,'ytick',yticks,'xtick',[]);
end

if (showlabels)
    xlabel('Time(ms)');
    ylabel('Trials');
end

if(usebounds==1)
    set(hresp,'XLim', [lowerbound,upperbound]);
end

if (HoldState==0)
	hold off
end
  
