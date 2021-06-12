function format_subplot(np,bw,L,B,T,R,same);

%— ABOUT:
% Formats vertical subplot - reduce space between subplots, 
% remove tick axes, add vertical grid lines
%
% USAGE: format_subplot(np,bw,L,B,T,R,same) 
% 
% INPUT:
% np = number of plots
% bw = space between subplots (default = 0.075)
% [L,B,T,R] = left,bottom,top,right margins
% same = true (1) / false (0) for whether to make x-limits the same
% 
% R. Izett
% UBC Oceanography
% Last modified: Nov. 2019
%—

if nargin<7
    same = 1;
end

if ~exist('bw','var')
    bw = 0.05; %space between subplots
    if ~exist('L','var')
        L = 0.1; %white space at left
    end
    if ~exist('B','var')
        B = 0.1; %bottom
    end
    if ~exist('T','var')
        T = 0.06; %top
    end
    if ~exist('R','var')
        R = 0.08; %right
    end
end

if isempty('bw')
    bw = 0.05; %space between subplots
    if ~exist('L','var')
        L = 0.12; %white space at left
    end
    if ~exist('B','var')
        B = 0.1; %bottom
    end
    if ~exist('T','var')
        T = 0.06; %top
    end
    if ~exist('R','var')
        R = 0.06; %right
    end
end

ht = (1 - T - B - (np-1)*bw) / np; %height of subplots
wd = 1 - L - R; %width 

%Go through each plot and get children properties
    Fc = get(gcf,'Children');
    n_axes = 0;
    rem = [];
    for kk = 1:numel(Fc)
%         if strcmp(Fc(kk).Type,'legend')
%             fcp(kk,[1:4]) = nan;
%             xl(kk,[1:2]) = nan;
%             rem = [rem; kk];
%             continue           
%         end
        if ~strcmp(Fc(kk).Type,'axes')
            fcp(kk,[1:4]) = nan;
            xl(kk,[1:2]) = nan;
            rem = [rem; kk];
            continue
        end
        %get position
            fcp(kk,:) = Fc(kk).Position;
            
        %number of axes
            n_axes = n_axes+1;
            
        %get xlims
            xl(kk,:) = Fc(kk).XLim;

    end
    
    %Get new Xlims to apply to all (if they are different)
        xl = [nanmin(xl(:,1)) nanmax(xl(:,2))];
    
    fcp(rem,:) = [];
    Fc(rem) = [];
        
    %Sort subplots from top to bottom
        [~,ii] = sort(fcp(:,2),'descend');
        fcp = fcp(ii,:);
        Fc = Fc(ii);
        
    ax = [];
    if ~(n_axes == np) %if n_axes is NOT the same as the number of subplots (i.e. plotyy plots included)
        %Get subplot no.    
        fcp(n_axes+1:end,:) = []; %remove position info for non-axes handles
        Fc(n_axes+1:end) = [];
        
        for kk = 2:n_axes
%         kk=2;
%         while kk >=2 & kk <= n_axes;
            sp_here = fcp(kk,:);
            
            %where subplot positions are the same as other subplots
            a=find(all(sp_here' == fcp'));
            
            if numel(a) > 1
                if a(1) ~= kk
                    ax = [ax; Fc(kk)];
                    Fc(kk) = []; %get rid of axes if it is a "repeat" / plotyy
                end
            end  
%             n_axes = numel(Fc);
%             kk=kk+1;
        end
    end

%re-adjust subplot sizes
    %check if x,y grids are on
        xgr = get(Fc(1),'xgrid');
        ygr = get(Fc(1),'ygrid');
            
    for kk = 1:np
        
        p = Fc(kk); %get subplot handle

        bot = B + (bw+ht)*(np-kk); %bottom position

        p.Position = [L bot wd ht]; %re-position [left bottom width height]

        if kk < np & same
            set(p,'xticklabel',[]) %,'xminortick','on','yminortick','on'); %remove x-tick labels
        end
        
        if same
            set(p,'xgrid',xgr,'xlim',[xl],'ygrid',ygr);
        else
            set(p,'xgrid',xgr,'ygrid',ygr);
        end
        
        set(p,'box','on');

        ax = [ax; p];
    end
    if same
        linkaxes(ax,'x');
    end
    
    