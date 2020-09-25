function format_plot(ax)

%Generic function to format a figure axis.

if ~exist('ax','var')
    ax = gca;
end

%Add grid lines and minor ticks
set(ax,'xgrid','on','ygrid','on','box','on','layer','top','xminortick','on','yminortick','on')

%Set x,y labels to bold.
xlab = get(gca,'xlabel');
    xlab.FontWeight = 'bold';
ylab = get(gca,'ylabel');
    ylab.FontWeight = 'bold';
    
return
