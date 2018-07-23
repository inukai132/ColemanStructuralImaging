% Function for calculating size change and plotting

function [bout_sizechange] = cumplot_size(var1, var2, color)

    % Fourth, for preMD - day1-->day2; MD3 - day1-->day3; MD7 - day1-->day4
    a1 = var1;
    a2 = var2;
    bout_sizechange = (a2-a1)./(a2+a1);
    cumplot(bout_sizechange, color);
    
end
