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
% File name		:   SpikeFrequency.m
% Goal 			:   Function to calculate the spike frequency (spikes per second)

function [f]= spikeFrequency(data,varargin)
nin=nargin;

switch nin
    case 1 %By default we assume that the data are given in ms
         t_conversion_factor=1000;
    case 2 %User opportunity to specify conversion factor converting from user time units to seconds
         t_conversion_factor=varargin{1};
end

% Determine total number of spikes in data
NoOfSpikes=length(data);

if NoOfSpikes < 2
    f = NaN;
%     warning('spikeTrainAnalysis:InsufficientData','Insufficient data to calculate a frequency, returning NaN.') 
    return
end

% Calculate frequency
f=  t_conversion_factor * (NoOfSpikes-1) /(data(end)-data(1));
       







