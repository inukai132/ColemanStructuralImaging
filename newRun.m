DAYS = 4;
DAYLAB = {'-3', '0', '3', '7'};
aData=[];
bData=[];
aAll=cell(0,0);
bAll=cell(0,0);

TestDataA={'aDay1','aDay2','aDay3','aDay4'};
TestDataB={'bDay1','bDay2','bDay3','bDay4'};
TESTING=1;
%Setup Testing Data% 
%% load grpA 

% Works now, creates aAll which is labeled data split by days and aData which is unlabled
% data split by days


% the rest hopefully you can see changes (eg see changes relative to day '-3', etc)

aAll = {};

    for i=1:DAYS %Loop through days
        

        t = sprintf('Please select folder for day %i, Group A',i);
        if ~TESTING
            tempdir = uigetdir('.',t);%Get folder
        else
            tempdir=TestDataA{i};
        end
        filenames = dir(tempdir);
        filenames = filenames(3:end);%Filter out the relative folders '. and ..'
        dayData = cell(1,2);
        for filename = 1:length(filenames)%Loop through files in folder
            
            name = filenames(filename).name;
            if strcmp(name(end-3:end), '.ini')%skip desktop.ini
                continue
            end
            newBout = loadBout([tempdir '/'],name,int2str(i),'A'); %Load bouton data
            dayData{1} = [dayData{1} newBout{1}];%Append it to the current day's data
            dayData{2} = [dayData{2} newBout{2}];
            
        end
        aAll(i,:)=dayData;%Add day to full list
        t=aAll{i,2};
        
    end
%Check that all files have the same number of elements across the days and
%remove ones that don't
files = unique(upper(aAll{1,1})); %Get file names
nums = [];
for file_i = 1:length(files)
    nums = [nums sum(strcmp(upper(aAll{1,1}),files(file_i)))]; %Count elements in each filename for day 1
end
nums_o = nums;
for days_i = 2:DAYS
    for file_i = 1:length(files)
        if nums(file_i) ~= sum(strcmp(upper(aAll{days_i,1}),files(file_i))) %If a day's elements under a certain file don't match, mark the file as invalid
            nums(file_i) = -1;
            sprintf('INVALID FILE FOUND: aDay%i/%s had %i elements, expecting %i',days_i,files{file_i},sum(strcmp(upper(aAll{days_i,1}),files(file_i))),nums(file_i))
        end
    end
end

del = upper(files(nums<0)); %Get list of invalid filenames
for days_i = 1:DAYS
    keep_i = ~ismember(upper(aAll{days_i,1}),del);
    aAll{days_i,1}=aAll{days_i,1}(keep_i);%Remove the invalid data
    aAll{days_i,2}=aAll{days_i,2}(keep_i);
    aData(:,days_i) = aAll{days_i,2}'; %While we're looping, append day data as a column
end


%% load grpB

bAll = {};

    for i=1:DAYS %Loop through days
        

        t = sprintf('Please select folder for day %i, Group B',i);
        
        if ~TESTING
            tempdir = uigetdir('.',t);%Get folder
        else
            tempdir=TestDataB{i};
        end
        filenames = dir(tempdir);
        filenames = filenames(3:end);%Filter out the relative folders '. and ..'
        dayData = cell(1,2);
        for filename = 1:length(filenames)%Loop through files in folder
            name = filenames(filename).name;
            if strcmp(name(end-3:end), '.ini')%skip desktop.ini
                continue
            end
            newBout = loadBout([tempdir '/'],name,int2str(i),'B'); %Load bouton data
            dayData{1} = [dayData{1} newBout{1}];%Append it to the current day's data
            dayData{2} = [dayData{2} newBout{2}];
            
        end
        
        bAll(i,:)=dayData;%Add day to full list
        t=bAll{i,2};
        
    end
%Check that all files have the same number of elements across the days and
%remove ones that don't
files = unique(upper(bAll{1,1})); %Get file names
nums = [];
for file_i = 1:length(files)
    nums = [nums sum(strcmp(upper(bAll{1,1}),files(file_i)))]; %Count elements in each filename for day 1
end
nums_o = nums;
for days_i = 2:DAYS
    for file_i = 1:length(files)
        if nums_o(file_i) ~= sum(strcmp(upper(bAll{days_i,1}),files(file_i))) %If a day's elements under a certain file don't match, mark the file as invalid
            sprintf('INVALID FILE FOUND: bDay%i/%s had %i elements, expecting %i',days_i,files{file_i},sum(strcmp(upper(bAll{days_i,1}),files(file_i))),nums_o(file_i))
            nums(file_i) = -1;
        end
    end
end

del = upper(files(nums<0)); %Get list of invalid filenames
for days_i = 1:DAYS
    keep_i = ~ismember(upper(bAll{days_i,1}),del);
    bAll{days_i,1}=bAll{days_i,1}(keep_i);%Remove the invalid data
    bAll{days_i,2}=bAll{days_i,2}(keep_i);
    bData(:,days_i) = bAll{days_i,2}'; %While we're looping, append day data as a column
end


% da = aData(:,2:end)-aData(:,2:end-1);
% sa = aData(:,1:end-1)+aData(:,2:end);
% ma = da./sa;
% 
% db = bData(:,2:end)-bData(:,1:end-1);
% sb = bData(:,1:end-1)+bData(:,2:end);
% mb = db./sb;

%% process - jc data

a_dMD = [aData(:,2)-aData(:,1), aData(:,3)-aData(:,1), aData(:,4)-aData(:,1)];
b_dMD = [bData(:,2)-bData(:,1), bData(:,3)-bData(:,1), bData(:,4)-bData(:,1)];

a_sMD = [aData(:,2)+aData(:,1), aData(:,3)+aData(:,1), aData(:,4)+aData(:,1)];
b_sMD = [bData(:,2)+bData(:,1), bData(:,3)+bData(:,1), bData(:,4)+bData(:,1)];

ma = a_dMD./a_sMD;
mb = b_dMD./b_sMD;


%% jc plots



% percentile-based size categories:

% small -> 0-30
aMD0_ind_smallEPB = find(aData(:,1) <= prctile(aData(:,1), 30));
bMD0_ind_smallEPB = find(bData(:,1) <= prctile(bData(:,1), 30));

atemp1 = find(aData(:,1) > prctile(aData(:,1), 30));
btemp1 = find(bData(:,1) > prctile(bData(:,1), 30));

% mid ->   30-70
aMD0_ind_midEPB = find(atemp1(:,1) <= prctile(atemp1(:,1), 70));
bMD0_ind_midEPB = find(btemp1(:,1) <= prctile(btemp1(:,1), 70));

% large -> 70-100
aMD0_ind_largeEPB = find(atemp1(:,1) > prctile(atemp1(:,1), 70));
bMD0_ind_largeEPB = find(btemp1(:,1) > prctile(btemp1(:,1), 70));


%% a v b - all EPBs
for i = 1:3
    figure('name',sprintf('Size change (%s to %s) - a v b ALL EPB',DAYLAB{1},DAYLAB{i+1}));
    cumplot(ma(:,i), 'b');
    hold on
    cumplot(mb(:,i), 'r')
    t=sprintf('Size change (%s --> %s) - a v b',DAYLAB{1},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(:,i), mb(:,i));
    
    
    title([t 'p=' num2str(p)])
end

%% a v b - large EPBs

a_epb_sizegroup = aMD0_ind_largeEPB;
b_epb_sizegroup = bMD0_ind_largeEPB;

for i = 1:3
    figure('name',sprintf('Size change (%s to %s) - a v b LRG EPB',DAYLAB{1},DAYLAB{i+1}));
    cumplot(ma(a_epb_sizegroup,i), 'b');
    hold on
    cumplot(mb(b_epb_sizegroup,i), 'r')
    t=sprintf('Size change (%s --> %s) - a v b | LRG EPBs',DAYLAB{1},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(a_epb_sizegroup,i), mb(b_epb_sizegroup,i));
    
    
    title([t 'p=' num2str(p)])
end

%% a v b - med EPBs

a_epb_sizegroup = aMD0_ind_midEPB;
b_epb_sizegroup = bMD0_ind_midEPB;

for i = 1:3
    figure('name',sprintf('Size change (%s to %s) - a v b MED EPB',DAYLAB{1},DAYLAB{i+1}));
    cumplot(ma(a_epb_sizegroup,i), 'b');
    hold on
    cumplot(mb(b_epb_sizegroup,i), 'r')
    t=sprintf('Size change (%s --> %s) - a v b | MED EPBs',DAYLAB{1},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(a_epb_sizegroup,i), mb(b_epb_sizegroup,i));
    
    
    title([t 'p=' num2str(p)])
end

%% a v b - small EPBs

a_epb_sizegroup = bMD0_ind_smallEPB;
b_epb_sizegroup = bMD0_ind_smallEPB;

for i = 1:3
    figure('name',sprintf('Size change (%s to %s) - a v b SML EPB',DAYLAB{1},DAYLAB{i+1}));
    cumplot(ma(a_epb_sizegroup,i), 'b');
    hold on
    cumplot(mb(b_epb_sizegroup,i), 'r')
    t=sprintf('Size change (%s --> %s) - a v b | SML EPBs',DAYLAB{1},DAYLAB{i+1});
    
    [h,p]=kstest2(ma(a_epb_sizegroup,i), mb(b_epb_sizegroup,i));
    
    
    title([t 'p=' num2str(p)])
end



%% plots deltaSize

    for i=1:3
        figure('name',sprintf('Size change (%s to %s) - a v b',DAYLAB{1},DAYLAB{i+1}));
        subplot(2,1,1);
        hold off;
        t=sprintf('Size change (%s --> %s) - a v b',DAYLAB{1},DAYLAB{i+1});
        H=cdfplot(ma(:,i));
    %     set(H,'Marker','o');
    %     set(H,'LineStyle','none');
        H.Color='r';
        Ax=H.XData;
        Ax(1)=-.5;
        Ax(end)=.5;
        [~,ia,~]=unique(Ax);
        Ax=Ax(ia);
        Ay=H.YData;
        Ay=Ay(ia);
        H.XData=Ax;
        H.YData=Ay;
        sumA=cumtrapz(Ax,Ay);
        hold on;
        H=cdfplot(mb(:,i));
    %     set(H,'Marker','o');
    %     set(H,'LineStyle','none');
        H.Color='b';
        Bx=H.XData;
        Bx(1)=-.5;
        Bx(end)=.5;
        [~,ia,~]=unique(Bx);
        Bx=Bx(ia);
        By=H.YData;
        By=By(ia);
        H.XData = Bx;
        H.YData = By;
        sumB=cumtrapz(Bx,By);
        title(t);
        ylim([0 1]);
        xlim([-.5 .5]);
        subplot(2,1,2);
        if length(sumA) > length(sumB)
            sumB=interp1(Bx,sumB,Ax);
        elseif length(sumA) < length(sumB)
            sumA=interp1(Ax,sumA,Bx);
        end
        hold off;
        df = sumA-sumB;
        area(df);
        hold on;
        plot(zeros(size(sumA)),'k')
        plot(-.5:1/(length(df)-1):.5,df)
        ylim([0 2]);
        title('Cumulative difference |a-b|');
    end

    BINWIDTH=5;
    BINLIM=[0 90];
    BINX=BINLIM(1):BINWIDTH:BINLIM(2)-BINWIDTH;

    %% histograms - size

for day=1:4
    figure('name', sprintf('Bouton Histogram Day %s',DAYLAB{day}));
    subplot(2,1,1);
    hold off;
    histogram(aData(:,day),'BinWidth',BINWIDTH,'BinLimits',BINLIM,'normalization','probability');
    dist=fitdist(aData(:,day),'Kernel','BandWidth',5);
    kernel=pdf(dist,BINX);
    hold on;
    plot(BINX,kernel/sum(kernel), 'r-', 'LineWidth',2);
    t=sprintf('Bouton Size Day %s Group A',DAYLAB{day});
    title(t);
    
    subplot(2,1,2);
    hold off;
    histogram(bData(:,day),'BinWidth',BINWIDTH,'BinLimits',BINLIM,'normalization','probability');
    dist=fitdist(bData(:,day),'Kernel','BandWidth',5);
    kernel=pdf(dist,BINX);
    hold on;
    plot(BINX,kernel/sum(kernel), 'r-', 'LineWidth',2);
    t=sprintf('Bouton Size Day %s Group B',DAYLAB{day});
    title(t);
end


    %% Population correlations
    
aGroups = unique(upper(aAll{1,1})); %Gets the names of the groups
figure('name', 'Mean activity across all days');
title('Means Normalized to Day -3');
aMean = mean(aAll{1,2});
m=zeros(1,DAYS);
hold on;
for group_i = 1:length(aGroups)
    %Get mean across the days, normalized to day 0(-3)
    x=0:3;
    data_i = ismember(upper(aAll{1,1}),aGroups(group_i));
    %Plot the means in a light color across the days (0-3)
    y=zeros(1,DAYS);
    for day_i = 1:DAYS
        data = aAll{day_i,2}(data_i);
        y(day_i)=mean(data)/aMean;
        m(day_i)=m(day_i)+sum(data);
    end
    plot(x,y,'-o','Color',[.8 .8 1],'MarkerSize',10,'LineWidth',2);
end
%Get the mean of the means and add as bar
m = m./length(aAll{1,2})./aMean;
bar(x,m,'FaceAlpha',0.1,'LineWidth',2);

%Do the same for group b (4-7)
bGroups = unique(upper(bAll{1,1})); %Gets the names of the groups
bMean = mean(bAll{1,2});
m=zeros(1,DAYS);
hold on;
for group_i = 1:length(bGroups)
    %Get mean across the days, normalized to day 0(-3)
    x=5:8;
    data_i = ismember(upper(bAll{1,1}),bGroups(group_i));
    %Plot the means in a light color across the days (0-3)
    y=zeros(1,DAYS);
    for day_i = 1:DAYS
        data = bAll{day_i,2}(data_i);
        y(day_i)=mean(data)/bMean;
        m(day_i)=m(day_i)+sum(data);
    end
    plot(x,y,'-o','Color',[1 .8 .8],'MarkerSize',10,'LineWidth',2);
end
%Get the mean of the means and add as bar
m = m./length(bAll{1,2})./bMean;
bar(x,m,'FaceAlpha',0.1,'LineWidth',2,'FaceColor',[1 0 0]);
plot(0:9,ones(1,10),'k--')
set(gca,'XTickLabel',[' ',DAYLAB,' ',DAYLAB])
hold off;


%Repeat with variance
figure('name', 'Activity variance across all days');
title('Variance Normalized to Day -3');
aVar = var(aAll{1,2});
hold on;
for group_i = 1:length(aGroups)
    %Get variance across the days, normalized to day 0(-3)
    x=0:3;
    data_i = ismember(upper(aAll{1,1}),aGroups(group_i));
    %Plot the variances in a light color across the days (0-3)
    y=zeros(1,DAYS);
    for day_i = 1:DAYS
        data = aAll{day_i,2}(data_i);
        y(day_i)=var(data)/aVar;
    end
    plot(x,y,'-o','Color',[.8 .8 1],'MarkerSize',10,'LineWidth',2);
end
%Get the var of the entire group and add as bar
v = var(cell2mat(aAll(:,2)),0,2)./aVar;
bar(x,v,'FaceAlpha',0.1,'LineWidth',2);

%Do the same for group b (4-7)
bVar = var(bAll{1,2});
hold on;
for group_i = 1:length(bGroups)
    %Get variance across the days, normalized to day 0(-3)
    x=5:8;
    data_i = ismember(upper(bAll{1,1}),bGroups(group_i));
    %Plot the variances in a light color across the days (5-8)
    y=zeros(1,DAYS);
    for day_i = 1:DAYS
        data = bAll{day_i,2}(data_i);
        y(day_i)=var(data)/bVar;
    end
    plot(x,y,'-o','Color',[1 .8 .8],'MarkerSize',10,'LineWidth',2);
end
%Get the var of the entire group and add as bar
v = var(cell2mat(bAll(:,2)),0,2)./bVar;
bar(x,v,'FaceAlpha',0.1,'LineWidth',2,'FaceColor',[1 0 0]);

plot(0:9,ones(1,10),'k--')
set(gca,'XTickLabel',[' ',DAYLAB,' ',DAYLAB])
hold off;

    %% Save figures

% saveFolder = 0;
saveFolder = uigetdir('.','Choose a folder to save the figures');
figs = findobj(allchild(0), 'flat', 'Type', 'figure');
for fig_i = 1:length(figs)
    h = figs(fig_i);
    if saveFolder ~= 0
        n = get(h, 'Name');
        n = strrep(n,' ','_');
        saveas(h, fullfile(saveFolder, n));
        saveas(h, fullfile(saveFolder, n), 'epsc');
    end
    close(h)
end













