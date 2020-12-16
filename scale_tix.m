function [tl,tls] = scale_tix(h,ax,scale,set);

%-------------------------------------------------------------------------
%Scale axis tick labels by a user defined scale value. NOTE: apply this
%function AFTER adjusting axes positions.
%
%e.g. scale_tix(gca,'x',100,1); << scales tick labels on xaxis by 100
%
%INPUT:
% h = axis handle
% ax = 'x' or 'y'
% scale = scale number
% set = true(1)/false(0) indicator to set ticklabels to scaled version
% (default = true)
%
%INPUT:
% tl = original tick labels
% tls = scaled tick labels
%-------------------------------------------------------------------------

if nargin < 4 
    set = 1;
end

%Get original tick labels
    xl = get(h,'xlim')
    yl = get(h,'ylim')
    if ax == 'x'
        hi = get(h,'xaxis');
    elseif ax == 'y'
        hi = get(h,'yaxis');
    end
    tl = hi.TickLabel; 
    tx = hi.TickValues;
    
%Scale tick labels    
    tls = tl;
    for kk = 1:numel(tl)
        tls{kk} = num2str(str2num(tl{kk})*scale);
    end
    
%Set tick labels
    if set
        h.XLim = xl;
        h.YLim = yl;
        hi.TickLabel = tls;
        hi.TickValues = tx;
    end



