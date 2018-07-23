function cumplot(x,varargin)
% plots cdf function as a solid line connecting points. 
%
%Line color and style can be included (accepts all plot properties
%
% arguments are [data, varargin]

% % % % figure();
% % %     font_size=6;
% % %     fig_size=7;
% % %     set(gca,'Units','centimeters','position',[2 6 fig_size*0.75 fig_size/2],'FontSize',font_size); % formatting to the real size in cm
% % % %     %hold on;
% % %     %set(gca,'DataAspectRatio',[24 1 1]); %for 2-p MS => [x y z] where y,z = 1; x = (xaxis_range/1.25) for xlim [-20 10] (/5.5556 for 3 points)
% % %     %set(gca,'XLim',[0 1]);

% plot(sort(abs(x)),((1:length(x))./length(x)),varargin{:}) 

% plot(sort(x),((1:length(x))./length(x)),varargin{:}) % removed abs, should handle neg vals in x

% new addition (12-12-13) - ignores NaNs in x
    x_nan=isnan(x);
    y_nan=find(x_nan == 0);
    x_nan=length(y_nan);
        
    plot(sort(x(y_nan)),((1:length(y_nan))./length(y_nan)),varargin{:}) % removed abs, should handle neg vals in x
        
% set(gca,'XScale','log','YScale','log');
% set(gca,'YLim',[0 1],'XScale','log');
set(gca,'YLim',[0 1]);
ylabel('Cumulative probability')

% hold all
% 
% plot(sort(x),((1:length(x))./length(x)),varargin2{:},'r-','XScale','log') % removed abs, should handle neg vals in x

%saveas(gcf,'R-X_am251_cumplot.ai')
end

%saveas(gcf,'filename.ai')

