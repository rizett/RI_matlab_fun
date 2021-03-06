function add_1_to_1(col,lw,lt);

%------------------------------------
% Add a 1:1 line to a plot
% 
% col = (optional) input colour
% lw = (optional) linewidth
%
% R. Izett
% March 2019
%------------------------------------

%if colour doesn't exist, set default as red
    if ~exist('col','var')
        col = 'r';
    end
    
%if line width doesn't exist, set default as red
    if ~exist('lw','var')
        lw = 1;
    end
    
%if line type doesn't exist, set default as red
    if ~exist('lt','var')
        lt = '--';
    end    

%Plot line
    hold on
    xl = get(gca,'xlim'); yl = get(gca,'ylim'); %get current x/y axes
    plot([min([xl yl]),max([xl yl])],[min([xl yl]),max([xl yl])],'--','color',col,'linewidth',lw,'linestyle',lt) %plot from min(x,y) to max(x,y);
    xlim([xl]); ylim([yl]); %reset axes limits
