function reg = add_regress(xdat,ydat,col,lw,inc_stats,lt);

%------------------------------------
% Add a regression line to a plot
% 
% reg = add_regress(xdat,ydat,col,lw,inc_stats); 
% 
% xdat = xdata
% ydat = ydata
% col = (optional) input colour
% lw = (optional) linewidth
% inc_stats = optional to include statistics on plot (0 = no; 1 = yes /
% default)
% lt = line type
%
% R. Izett
% March 2019
%------------------------------------

% error if x and y data different lengths
    if length(xdat) ~= length(ydat)
        error('X and Y data not same length!')
    end

%if colour doesn't exist, set default as red
    if ~exist('col','var')
        col = 'r';
    end
    
%if line width doesn't exist, set default as red
    if ~exist('lw','var')
        inc_stats = 1;
    end
    
%if include stats  doesn't exist, set default as 1
    if ~exist('inc_stats','var')
        lw = 1;
    end
    
%if line width doesn't exist, set default as red
    if ~exist('lt','var')
        lt = '--';
    end    

% remove nans
    ydat(abs(xdat)==Inf) = nan; xdat(abs(xdat)==Inf) = nan;
    xdat(abs(ydat)==Inf) = nan; ydat(abs(ydat)==Inf) = nan;
    
    xdat = xdat(~isnan(ydat)); ydat = ydat(~isnan(ydat));
    ydat = ydat(~isnan(xdat)); xdat = xdat(~isnan(xdat));
    
% perform regression
    xs = [ones(length(xdat),1), reshape(xdat,length(xdat),1)];
    ys = [reshape(ydat,length(ydat),1)];
    [m,ci,~,~,stats] = regress(ys,xs);
    new_y = get(gca,'xlim') .* m(2) + m(1);
        new_y = reshape(new_y,length(new_y),1);
    new_y_ci1 = get(gca,'xlim') .* ci(2,1) + ci(1,1);
        new_y_ci1 = reshape(new_y_ci1,length(new_y),1);
    new_y_ci2 = get(gca,'xlim') .* ci(2,2) + ci(1,2);
        new_y_ci2 = reshape(new_y_ci2,length(new_y),1);
    pred_y = xs(:,2) .* m(2) + m(1);
        pred_y = reshape(pred_y,length(pred_y),1);
        ydat = reshape(ydat,length(ydat),1);
        xdat = reshape(xdat,size(ydat));
%     plot(xdat,pred_y,'r.')
    rsq = stats(1); 
    pv = stats(end);
    
%Plot line
    hold on
    xl = get(gca,'xlim'); yl = get(gca,'ylim'); %get current x/y axes
    plot(get(gca,'xlim'),new_y,lt,'color',col,'linewidth',lw); %plot from min(x,y) to max(x,y);
%     plot(get(gca,'xlim'),new_y_ci1,lt,'color','y','linewidth',.5); %plot from min(x,y) to max(x,y);
%     plot(get(gca,'xlim'),new_y_ci2,lt,'color','y','linewidth',.5); %plot from min(x,y) to max(x,y);
    xlim([xl]); ylim([yl]); %reset axes limits
    if inc_stats
        reg.slope = m(2);
        reg.slope_ci = ci(2,:);
        reg.intercept = m(1);
        reg.intercept_ci = ci(1,:);
        reg.Rsq = rsq;
        reg.pval = pv;
        reg.rmse = sqrt(nanmean(((xdat-ydat)).^2));
        reg.rmse_pred = sqrt(nanmean(((pred_y-ydat)).^2));
        reg.pred = pred_y;
        reg.orig_y = ydat;
        reg.orig_x = xdat;
        
    else
        reg = [];
    end
