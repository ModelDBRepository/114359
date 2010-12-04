% File name		: burstMeasure.m
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
% Goal 			: Function to calculate the B2 burstmeasure, this measure
%                 was introduced in:
%                 R.A.J. van Elburg, A. van Ooyen, A new measure for
%                 bursting,Neurocomputing 58-60 (2003), 497-502. 
%                 
% Remarks        : cutoff was introduced to deal with data sets with long
%                 silence periods, this is for now an ad-hoc solution and it works 
%                 well if the the number of long intervals (> cutoff) is much smaller
%                 then the number of short intervals.
%

function [B2,MeanDtRes] = burstMeasure(data,cutoff)

[rows,cols]=size(data);

if(0==cols)
    B2=NaN;
    MeanDtRes=NaN;
else
    B2=zeros(cols,1);
    MeanDtRes=zeros(cols,1);
end

for i=1:cols
    col=data(:,i);    
    col=col(~isnan(col));           % Remove NaN (expected to occur at end of column)
    dif1=diff(col);                 % Convert to diff1
    
    dif1 = dif1(cutoff-dif1>0);     % Remove silent periods larger than cutoff (not completely neat)

    dif2=dif1(1:end-1,:)+dif1(2:end,:);
    if(length(dif2)>1)
        MeanDt=mean(dif1);

        if(MeanDt~=0)
            B2(i,1)=(2*var(dif1)-var(dif2))./(2*MeanDt^2);
        else
            B2(i,1)=NaN;
        end
    else
            if(~isempty(dif1))
                MeanDt=mean(dif1);
            else
                MeanDt=NaN;
            end
            B2(i,1)=NaN;
    end
    MeanDtRes(i,1)=MeanDt;
    
end


