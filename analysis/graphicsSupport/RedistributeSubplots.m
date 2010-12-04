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
%---------------- Redistribute subplots over the available area ------------------
%
% Usage:
%       In your own code save all subplot axes handles to a matrix
%       e.g.
%       for y_coord=1:1:y_plot_size
%           for x_coord=1:1:x_plot_size
%                axes_handles(x_coord,y_coord)=subplot(y_plot_size,x_plot_size,(y_coord-1)*(x_plot_size)+x_coord);
%                % Create the figure you want to put in the subplot here.
%           end
%       end
%                % Then call this function
%       RedistributeSubplots(axes_handles,x_plot_size,y_plot_size,0, 0)
%
% Bugs: 
%      The margins are an adhoc enhancement and accidentally move the
%      first row of subplots down and the last column to the right. As a result
%      of this repeated application of the algorithm with non-zero margins will 
%      create ever larger top and right margins.
%

function RedistributeSubplots(axes_handles,x_plot_size,y_plot_size,xmargin,ymargin, moveticks ,removelabels)

if nargin < 7,  removelabels=1;   end
if nargin < 6,  moveticks=1;    end
if nargin < 5,  ymargin=0;      end
if nargin < 4,  xmargin=0;      end
% Retrieve present positions and calculate new
if(y_plot_size>1)
    ypos=cell2mat(get(axes_handles(1,:),'pos'));

    ytop=ypos(:,2)+ypos(:,4);
    [dummy,idx]=sortrows(-ytop);
    ypos=ypos(idx,:);

    Hy=(ypos(1,2)+ypos(1,4))-ypos(end,2); %total height of axes
    Hyused=sum(ypos(:,4));     
    ystretch=max(Hy/Hyused,1);
    ypos(1,2)=ypos(1,2)-ypos(1,4)*(ystretch-1);
    ypos(:,4)=ypos(:,4)*ystretch;

    for y_coord=2:y_plot_size
        ypos(y_coord,2)=ypos(y_coord-1,2)-ypos(y_coord,4);
    end
    ypos(:,4)=ypos(:,4)*(1-ymargin);
end


if(x_plot_size>1)
    xpos=cell2mat(get(axes_handles(:,1),'pos'));
    
    xtop=xpos(:,1)+xpos(:,3);
    [dummy,idx]=sortrows(-xtop);
    xpos=xpos(idx,:);

    Hx=(xpos(1,1)+xpos(1,3))-xpos(end,1); %total height of axes
    Hxused=sum(xpos(:,3));     
    xstretch=max(Hx/Hxused,1);
    xpos(1,1)=xpos(1,1)-xpos(1,3)*(xstretch-1);
    xpos(:,3)=xpos(:,3)*xstretch;

    for x_coord=2:x_plot_size
        xpos(x_coord,1)=xpos(x_coord-1,1)-xpos(x_coord,3);
    end
    
    xpos(:,3)=xpos(:,3)*(1-xmargin);
end

% Set the new positions and move or remove axes and ticklabels
for y_coord=1:1:y_plot_size;
    for x_coord=1:1:x_plot_size;
        axes_handle=axes_handles(x_coord,y_coord);
        thispos=get(axes_handle,'pos');
        if(x_plot_size>1)
            thispos(1)=xpos(x_plot_size-x_coord+1,1);
            thispos(3)=xpos(x_plot_size-x_coord+1,3);
        end
        if(y_plot_size>1)
            thispos(2)=ypos(y_coord,2);
            thispos(4)=ypos(y_coord,4);
        end

        set(axes_handle,'pos',thispos);

        set(axes_handle,'TickDir','in');
        if(moveticks==1) 
            if (y_coord == 1)
                set(axes_handle,'XAxisLocation', 'top');
            elseif(y_coord == y_plot_size )
                set(axes_handle,'XAxisLocation', 'bottom');
            else
                set(axes_handle,'XTickLabel', []);
            end

            if (x_coord == 1)
                set(axes_handle,'YAxisLocation', 'left');
            elseif(x_coord == x_plot_size )
                set(axes_handle,'YAxisLocation', 'right');
            else
                set(axes_handle,'YTicklabel', []);
            end
        end
        
        if(removelabels==1) 
            if (y_coord ~= 1 && y_coord ~= y_plot_size )
                  set(get(axes_handle,'Xlabel'),'String', '')
            end

            if (x_coord ~= 1 && x_coord ~= x_plot_size )
                set(get(axes_handle,'Ylabel'),'String', '');
            end
        end
    end
end
