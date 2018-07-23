%Notes from Jason for 'bouton size analysis'


% Steps needed for bouton size analysese
% Ref: Sammons et al. 2018. Size-Dependent Axonal Bouton Dynamics following Visual Deprivation In Vivo. Cell Reports 22, 576?584

% details from Supp material - QUANTIFICATION AND STATISTICAL ANALYSIS/Structural imaging Analysis

% 1 - generate histograms similar to Figs 1E-F using grpA and grpB size data
% 2 - generate Figs 1G-H - just use 'global mean' for now (ie mean for all epbs per group vs. mean sizes of "individual mean size" from each mouse/grp)
%       note for x-axis time points : 0=> day1 = -3 (ie day1 is -3 for us), 3=> day2 = 0); 6=> day3 = 3; 9=> day4 = 7)
% 3 - same for Figs 1I-L for 'day3' (which = 0-3 days deprived for us) and 'day4' (which = 3-7 days deprived for us) data

% 4 - Figs 1M-S: Analyze bouton size - size category for day3 and day4 based on bouton size on 'day1' imaging (day1, day2, day3, day4)
%   epb_small = 0-30th percentile on 'day1'
%   epb_medium = 30-70th percentile on 'day1'
%   epb_large = 70-100th percentile on 'day1'

% Key questions for us:
% 1) Are the baseline bouton sizes similar between groups for days 1 and 2?
% 2) Are the baseline (day1) vs day2, day3 and day4 sizes different within GrpA? within GrpB?
% 3) same questions as 1 and 2, but for change in size from day1 to day2 (baseline deltaSize), day1 to day3 (0-3d deprived deltaSize), day1 to day4 (3-7d deprived deltaSize)
% 4) same as 3 but relative changes to previous imaging day vs. just baseline day1 - (i.e. day1->day2, day2->day3, day3->day4)


%% This will concatenate data from Python mat files in variables by group and day
[aDay1] = concat_boutareas;
[aDay2] = concat_boutareas;
[aDay3] = concat_boutareas;
[aDay4] = concat_boutareas;
% cumplot(aDay1); hold all;
% cumplot(aDay2)
% cumplot(aDay3)
% cumplot(aDay4)

[bDay1] = concat_boutareas;
[bDay2] = concat_boutareas;
[bDay3] = concat_boutareas;
[bDay4] = concat_boutareas;

% figure();
% cumplot(bDay1); hold all;
% cumplot(bDay2)
% cumplot(bDay3)
% cumplot(bDay4)


% %%
% figure();
% title('day3 and day 4 - a v b');
% cumplot(aDay3, 'bo'); hold on;
% cumplot(bDay3, 'ro')
% 
% cumplot(aDay4, 'co'); hold on;
% cumplot(bDay4, 'mo')
% 
% %%
% figure();
% title('d2 v d3')
% cumplot(aDay2, 'b'); hold on;
% cumplot(aDay3, 'b--')
% 
% cumplot(bDay2, 'c'); hold on;
% cumplot(bDay3, 'c--')
% 
% %%
% figure();
% title('d3 v d4')
% cumplot(aDay3, 'b'); hold on;
% cumplot(aDay4, 'b--')
% 
% cumplot(bDay3, 'c'); hold on;
% cumplot(bDay4, 'c--')

%% Snippets for testing data etc.
% calculate delta-size changes

% First, for preMD condition (day1 and day2)
a2 = aDay2; % for groupA
a1 = aDay1;
tempa = (a2-a1)./(a2+a1);

b2 = bDay2; % for groupB
b1 = bDay1;
tempb = (b2-b1)./(b2+b1);

figure();
title('Size change (pre1 --> pre2) - a v b');
cumplot(tempa, 'bo'); hold on;
cumplot(tempb, 'ro');

% Second, for preMD (day2) vs. 3 days post-MD (day3)
a4 = aDay3;
a3 = aDay2;
tempa = (a4-a3)./(a4+a3);

b4 = bDay3;
b3 = bDay2;
tempb = (b2-b1)./(b2+b1);

figure();
title('Size change (preMD --> MD3) - a v b');
cumplot(tempa, 'bo'); hold on;
cumplot(tempb, 'ro');

% Third, for 3 days post-MD (day3) vs. 7 days post-MD (day4)
a6 = aDay4;
a5 = aDay3;
tempa = (a2-a1)./(a2+a1);

b6 = bDay4;
b5 = bDay3;
tempb = (b6-b5)./(b6+b5);

figure();
title('Size change (MD3 --> MD7) - a v b');
cumplot(tempa, 'bo'); hold on;
cumplot(tempb, 'ro');


% function [h,p] = cumplot_size(var1, var2, color)
% 
%     % Fourth, for preMD - day1-->day2; MD3 - day1-->day3; MD7 - day1-->day4
%     color = 'bo'
%     a1 = var1;
%     a2 = var2;
%     tempa = (a2-a1)./(a2+a1);
% 
%     b1 = bDay1;
%     b2 = bDay2;
%     tempb = (b2-b1)./(b2+b1);
% 
%     figure();
%     cumplot(tempa, color);
% 
%     [h,p]=kstest2(tempa,tempb)
%     
% end


[aD12_bout_sizechange] = cumplot_size(aDay1, aDay2, 'bo');

x = aD12_bout_sizechange;
h = hist(x,30);
plot(h)

hold all;
x = bD14_bout_sizechange;
h = hist(x,30);
plot(h, 'm')











